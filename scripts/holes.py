#!/usr/bin/env python3
"""Count the proof holes in a Lean file.

    scripts/holes.py FILE            ->  "<holes> <decls> <unfinished>"
    scripts/holes.py -v FILE         ->  plus one line per hole

"holes"  = `sorry` occurrences in CODE (comments and strings excluded)
"decls"  = `example` / `theorem` / `lemma` declarations in code
"unfinished" = declarations that contain at least one hole

The comment stripper keeps newlines so reported line numbers stay correct,
and it is a state machine across lines: Lean's /-! doc comments and /-- doc
strings routinely span dozens of lines.
"""
import re
import sys


def strip_code(src_lines):
    """Blank out comments and strings, preserving every line break."""
    out, in_block = [], False
    for line in src_lines:
        buf, i, n = [], 0, len(line)
        while i < n:
            if in_block:
                j = line.find('-/', i)
                buf.append(' ' * (j + 2 - i) if j >= 0 else ' ' * (n - i))
                i = j + 2 if j >= 0 else n
                if j >= 0:
                    in_block = False
                continue
            if line.startswith('/-', i):
                in_block = True
                j = line.find('-/', i + 2)
                buf.append(' ' * (j + 2 - i) if j >= 0 else ' ' * (n - i))
                i = j + 2 if j >= 0 else n
                if j >= 0:
                    in_block = False
                continue
            if line.startswith('--', i):
                buf.append(' ' * (n - i))
                i = n
                continue
            if line[i] in '"\'':
                q, j = line[i], i + 1
                while j < n and line[j] != q:
                    j += 2 if line[j] == '\\' else 1
                j = min(j + 1, n)
                buf.append(' ' * (j - i))
                i = j
                continue
            buf.append(line[i])
            i += 1
        out.append(''.join(buf))
    return out


DECL = re.compile(r'\s*(?:example|theorem|lemma)\b')
SORRY = re.compile(r'\bsorry\b')


def scan(path):
    src = open(path).read().splitlines()
    code = strip_code(src)

    holes = [(k + 1, code[k].strip()[:72]) for k in range(len(code))
             if SORRY.search(code[k])]
    decl_lines = [k for k in range(len(code)) if DECL.match(code[k])]

    # Attribute each hole to the nearest declaration ABOVE it -- the same one
    # again for a multi-line proof like a calc block. A declaration counts as
    # unfinished if it owns at least one hole.
    with_holes = set()
    for hline, _ in holes:
        for d in reversed(decl_lines):
            if d < hline:
                with_holes.add(d)
                break
    return holes, len(decl_lines), len(with_holes)


def main():
    args = sys.argv[1:]
    verbose = '-v' in args
    files = [a for a in args if a != '-v']
    if not files:
        sys.exit("usage: holes.py [-v] FILE...")

    for path in files:
        holes, decls, unfinished = scan(path)
        print(f"{len(holes)} {decls} {unfinished}")
        if verbose:
            for ln, txt in holes:
                print(f"    {ln:>4}: {txt}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
# AGENTS

- `exercise/` and `src/` are the student's code: write skeletons + comments
  only, never the proof. You may show the first 1–2 tactics; they write the
  rest. `examples/` is read-only reference — never edit it.
- When they say an exercise is done, run `scripts/check.sh <file>` and report
  the remaining count. If it still has holes, say so plainly.
- Talk zh/en mixed, keep technical terms in English. Be concise.
- Never `git commit` without explicit approval.
- Long jobs (lake update, cache get, build) go in a herdr pane via
  `scripts/bg.sh`, never blocking this one.

## Layout

| path | what |
|---|---|
| `exercise/` | their exercises, `sorry` holes to fill |
| `src/Toric/` | the `lean-toric` reproduction, mirrors the reference tree |
| `examples/` | read-only copies of reference repos |
| `notes/` | knowledge worth keeping (markdown) |
| `logs/run/` | machine output, gitignored |
| `logs/dev/` | hand-written journal, tracked |
| `scripts/` | helper scripts; `scripts/tests/` holds the Lean smoke test |
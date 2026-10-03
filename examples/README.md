# examples/ — 参考代码与计划

两个文件：

- **`PLAN.md`** — 教学计划（先读这个）
- `README.md` — 本目录的清单

## 规矩

拷贝进来的**参考代码不要改**。它们是唯一的对照物，改脏了就失去参照价值。
`PLAN.md` 和 `README.md` 是我们自己写的，随便改。

拷贝代码用 `scripts/copy_reference.sh`，拷完在下表加一行。

## glimpseoflean/

`~/Public/lean-GlimpseOfLean/` 的源码副本（2026-10-01 拷入，448 KB）。

只拷了源码和文档，**没有** `.lake/`、`.git/`、`*.olean`。上游用
mathlib v4.27.0，本仓库用 v4.34.1 —— 所以这棵树里的文件**不能**直接编译，
只读。

```
GlimpseOfLean/
├── Introduction.lean          1 个完整证明，0 练习。先读它。
├── Exercises/                 题目（证明被替换成 sorry）
│   ├── 01Rewriting.lean           10 个待填证明
│   ├── 02Iff.lean                  6
│   ├── 03Forall.lean               4
│   ├── 04Exists.lean               3
│   ├── Shorter.lean               17
│   └── Topics/                     91
├── Solutions/                 答案。**最后才看。**
├── Library/                   教学补丁层，README 附录 B 有解释
├── tactics.tex / .pdf         tactic 速查表
└── mk_exercises.py            从 Solutions 生成 Exercises 的脚本
```

中文导读、tactic 速查表（翻译成 Markdown）、和本仓库的用法约定，全在
[`../notes/00-GlimpseOfLean.md`](../notes/00-GlimpseOfLean.md)。

## 什么时候往这里加

需要新参考代码时**按需拷贝**，别预先囤 —— 见下面的 `copy_reference.sh`。

拷完在「清单」表里加一行说明。

## 清单

| dir | 来源 | 拷入日期 | 用途 |
|---|---|---|---|
| `glimpseoflean/` | `~/Public/lean-GlimpseOfLean` | 2026-10-03 | 阶段 1 练习来源 |
| `toric/` | `~/Public/lean-toric` | — | 阶段 2 复现目标（待拷） |
| `prove2me-toric-foliation/` | `~/Public/lean-prove2me-toric-foliation` | — | 阶段 3 实战（待拷） |

按需拷：

```bash
scripts/copy_reference.sh ~/Public/lean-toric
scripts/copy_reference.sh ~/Public/lean-prove2me-toric-foliation
```

（第二个仓库基本是 `.md` / `.py` / `.json`，脚本的过滤规则够用。）
# references/ — 参考资料（只读）

上游仓库的原文副本：题目、源码树、编译好的 blueprint PDF。成品答案在
[`../examples/`](../examples/README.md)。

## 规矩

**不要改这里的内容。** 它们是唯一的对照物：`exercise/` 的骨架从这里生成，
`src/Toric/` 将来要跟 `toric/Toric/` 逐行 `diff -ru`。改脏了就失去参照价值。

拷贝用 `scripts/copy_reference.sh [-f] <repo> [path...]`，目标固定在
`references/<name>/`（`lean-` 前缀去掉、转小写）。尾巴上那几个参数就是**只拿这些路径**——
不给参数就是整棵树，会把 `website/`、CI 配置、`lakefile.toml` 一起拖进来，那类东西没有阅读价值。
跳过 `.lake` / `.git` / `*.olean` / blueprint 编译产物。拷完在下表加一行。

`-f` 刷新会保留目标里已存在的 `*.pdf`：那是我们自己编出来的，上游没有东西能替换它。

## 树

```
GlimpseOfLean/                ~/Public/lean-GlimpseOfLean 的副本（12 文件）
├── Introduction.lean          导读 + 第一个完整证明（ε-δ 连续 ⇒ 列连续）
└── Exercises/                 题目原文，证明被 mk_exercises.py 换成 sorry
    ├── 01Rewriting.lean           10 个待填证明
    ├── 02Iff.lean                  6
    ├── 03Forall.lean               4
    ├── 04Exists.lean               3
    ├── Shorter.lean               17
    └── Topics/                     91（六个专题文件）

toric/                        ~/Public/lean-toric 的副本（19 个 .lean + 1 个 PDF）
├── Toric.lean                 库根，18 个模块的 import 清单（模块地图）
├── Toric/                     18 个 .lean，阶段 2 的复现对象
└── Toric.pdf                  blueprint 的 PDF，30 页 / 144 KB
```

blueprint 的 LaTeX 源码**没拿过来**：读定义只需要 PDF，源码在
`~/Public/lean-toric/blueprint/src/`，随时可以重新编译。

中文导读、tactic 速查表（译成 Markdown）、本仓库用法约定：
[`../notes/00-GlimpseOfLean.md`](../notes/00-GlimpseOfLean.md)。

## 清单

| dir | 来源 | 拷入日期 | 拿了什么 |
|---|---|---|---|
| `GlimpseOfLean/` | `~/Public/lean-GlimpseOfLean` | 2026-10-01 | `Introduction.lean` + `Exercises/` |
| `toric/` | `~/Public/lean-toric` | 2026-10-04 | `Toric/` + `Toric.lean` + 编译好的 `Toric.pdf` |

刷新：

```bash
scripts/copy_reference.sh -f ~/Public/lean-GlimpseOfLean Introduction Exercises
scripts/copy_reference.sh -f ~/Public/lean-toric Toric Toric.lean
```

## 两棵树都编不过

| 树 | 上游 toolchain / mathlib | 本仓库 | 后果 |
|---|---|---|---|
| `GlimpseOfLean/` | v4.27.0 | v4.34.1 | tactic 行为可能对不上；`Exercises/*` 的 import 指向 `GlimpseOfLean.Library.*`，而那棵树在 `examples/` 里 |
| `toric/Toric/` | `v4.34.0-rc2` / mathlib `62d0e07` | v4.34.1 / mathlib v4.34.1 | 若干 API 移位，这是故意的练习，不是事故 |

`exercise/` 里的副本已经做过 import 替换（换成 `import Mathlib`），见每个文件的头注释块。

## Toric.pdf 怎么再来一次

```bash
cd ~/Public/lean-toric/blueprint/src && latexmk          # 需要 xelatex，产物在 ../print/print.pdf
latexmk -C                                               # 清掉编译中间文件
cp ~/Public/lean-toric/blueprint/print/print.pdf ~/Projects/lean/references/toric/Toric.pdf
```

本机依赖齐全：`xelatex` + `unicode-math` + `sansmath` + `mathtools` + `bibtex`。
web 版还要 python 包 `blueprint` 和 `plastex`，**本机没装**，所以只有 print 版。

## 还没拷进来的

| 仓库 | 用途 | 命令 |
|---|---|---|
| `~/Public/lean-prove2me-toric-foliation` | 阶段 3 实战（1 定义 + 5 定理） | `scripts/copy_reference.sh ~/Public/lean-prove2me-toric-foliation` |

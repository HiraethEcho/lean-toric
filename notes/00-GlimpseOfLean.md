# A glimpse of Lean（中文）

> 本文是 `~/Public/lean-GlimpseOfLean/README.md` 的中文翻译。
> 上游作者 Patrick Massot，本地副本无 `.git`，用 pnpm/vim 均可，来源见文末。

---

## Lean 惊鸿一瞥

这个仓库是给**没耐心的人**准备的 Lean 定理证明入门。目标是在 2–3 小时里
建立"在 Lean 里证明大概长什么样"的直觉；愿意的话也可以花半天或一整天。

有两条路线，两条都从读 `Introduction.lean` 开始。

**短线**：接着做 `Shorter.lean`。如果你推进得够快，两小时就能接触到
不那么空洞的数学证明。

**长线**：时间充裕的话，改去读 `Basics/` 里的讲解并做练习，然后从
`Topics/` 里挑一个文件做。时间更多的话，`Topics/` 下的文件可以全都玩一遍。

要做练习，你得先有一个 Lean 环境：本地安装，或者用 lean4web 服务器，
或者用 Codespaces，或者用 Gitpod。

## 在线版，无需注册

不想装 Lean、也不想在任何网站注册，可以直接用 [Lean FRO](https://lean-fro.org/)
托管的 [lean4web 服务器](https://live.lean-lang.org/)：

* 读[入门文件](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FIntroduction.lean)
* 然后读并编辑短线用的[讲解与练习文件](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FShorter.lean)

走长线的话，对应链接：

* 基础四讲：[01Rewriting](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2F01Rewriting.lean) ·
  [02Iff](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2F02Iff.lean) ·
  [03Forall](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2F03Forall.lean) ·
  [04Exists](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2F04Exists.lean)

之后按数学口味挑：

* [SequenceLimits](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FSequenceLimits.lean) —— 实数列的基本性质
* [RingTheory](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FRingTheory.lean) —— 交换代数，一直到交换环上的中国剩余定理
* [Probability](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FProbability.lean) —— 一些概率论
* [GaloisAdjunctions](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FGaloisAdjunctions.lean) —— 初等抽象胡说（有序集之间的伴随，附群论和拓扑的应用）
* [ClassicalPropositionalLogic](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FClassicalPropositionalLogic.lean) —— 经典数理逻辑
* [IntuitionisticPropositionalLogic](https://live.lean-lang.org/#project=GlimpseOfLean&url=https%3A%2F%2Fraw.githubusercontent.com%2FPatrickMassot%2FGlimpseOfLean%2Frefs%2Fheads%2Fmaster%2FGlimpseOfLean%2FExercises%2FTopics%2FIntuitionisticPropositionalLogic.lean) —— 直觉主义数理逻辑（**不懂 Heyting 代数就别试**）

做练习时可以随时翻 [tactics 速查表](tactics.pdf)。tactic 在 Lean 文件里
也有讲解，但当参考用 PDF 更方便。

## 在线版，需要注册

也有一些用起来更舒服、但需要 [GitHub](https://www.github.com) 账号的方案：

* **Codespaces**：登录 GitHub，点下面的按钮，选 `4-core`，按
  `Create codespace`。几分钟后浏览器里会打开一个装好 Lean 的编辑器。

    [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/PatrickMassot/GlimpseOfLean)

* **Gitpod**：跟 Codespaces 几乎一样，点按钮，按 `Continue`，等几分钟。

    [![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/PatrickMassot/GlimpseOfLean)

## 本地安装

想要完整的 Lean 体验，就在自己的电脑上装一份。步骤见
[这里](https://leanprover-community.github.io/get_started.html)。

时间更充裕的话，去读教材 [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)。

---

# 附录 A：tactic 速查表

原文是 `tactics.tex` 编译出的 `tactics.pdf`（Lean 3 版本的作者是
Patrick Massot 和 Johan Commelin）。本地用不到 PDF，翻译成表格。

## 逻辑符号 → 怎么打

| 符号 | 在目标里 | 在假设 `h` 里 |
|---|---|---|
| `∀` 全称 | `intro x` | `apply h` 或 `specialize h x` |
| `∃` 存在 | `use x` | `rcases h with ⟨x, hx⟩` |
| `→` 蕴含 | `intro h` | `apply h` 或 `specialize h1 h2` |
| `↔` 双箭头 | `constructor` | `rw [h]` |
| `∧` 合取 | `constructor` | `h.1` 或 `h.2` |

## tactic 手册

### 重写与化简

| tactic | 作用 |
|---|---|
| `ring` | 用交换环公理证明目标成立。 |
| `rw [expr]` | 在目标里，把 `expr` 左侧的**所有**出现换成右侧。`expr` 必须是等式、`<->` 或定义。 |
| `rw [expr] at h` | 同上，但作用在假设 `h` 里。 |
| `simp` | 用所有化简引理化简目标。 |
| `unfold` | 展开给定项的定义。 |

### 用等式、不等式和其他关系推理

| tactic | 作用 |
|---|---|
| `calc?` | 生成一个 `calc` 块 |
| `calc a = b := by tac` <br> `    _ ≤ c := by tac` <br> `    _ < d := by tac` | 走一条推导链。把光标放在 `:= by` 后面、shift-click 目标里的子项，可以生成新的一步。 |
| `congr` | 用同余（congruence）规则证明等式。 |
| `gcongr` | 用同余规则证明不等式。 |

### 搜索

| tactic | 作用 |
|---|---|
| `apply?` | 列出所有能作用于当前目标的引理。 |

---

# 附录 B：本仓库怎么用

上游的东西我们**不直接跑**。我们在 `~/Projects/lean/`，用 Lean 4.34.1 +
mathlib v4.34.1（上游是 v4.27.0，落后 8 个 minor，tactic 行为可能对不上）。

## 目录对照

| 上游 | 本仓库 | 说明 |
|---|---|---|
| `Introduction.lean` | 待搬 | 90 行，1 个完整证明，0 练习，纯演示 |
| `Exercises/*.lean` | `exercise/NN*.lean` | **你写 proof** |
| `Exercises/Topics/*.lean` | `exercise/Topics/` | 专题，按口味挑 |
| `Solutions/*` | `examples/GlimpseOfLean/Solutions/` | 答案。卡住 30 分钟以上再看 |
| `Library/*` | 也在 examples/ 里 | 见下面「关于 Library」 |
| `tactics.pdf` | 本文附录 A | 翻译成了 Markdown 表格 |

源码副本在 `examples/GlimpseOfLean/`（448 KB，只拷源码，不带 `.lake` / `.git`）。

## import 要改

上游每个练习都 `import GlimpseOfLean.Library.Basic`。我们换成：

- `01`–`04`、多数 Topics → `import Mathlib`
- `Probability` → 额外 `import Mathlib.Probability.Notation`
- `03Forall` → 额外 `import Mathlib.Topology.Order.IntermediateValue` 等

`import Mathlib` 全都覆盖，所以我们的版本**可能比上游慢几秒编译**，
但不需要维护 `Library/`。

## 检查单个文件

```bash
scripts/check.sh exercise/01Rewriting.lean
scripts/check.sh -v exercise/01Rewriting.lean   # 列出每个还剩的洞
scripts/check.sh                               # 全部练习 + 总数
```

比 `lake build` 快得多（1–5 秒 vs 几分钟）。`declaration uses 'sorry'`
的警告一条条减少，就是进度。

## 题目总量

上游 11 个文件，**137 个待填证明**（分布在 187 个声明里）：

| 文件 | 待填证明 | 解完行数 |
|---|---:|---:|
| `01Rewriting` | 10 | 217 |
| `02Iff` | 6 | 235 |
| `03Forall` | 4 | 244 |
| `04Exists` | 3 | 127 |
| `Shorter` | 17 | 764 |
| `Topics/ClassicalPropositionalLogic` | 12 | 283 |
| `Topics/GaloisAdjunctions` | 25 | 696 |
| `Topics/IntuitionisticPropositionalLogic` | 12 | 269 |
| `Topics/Probability` | 11 | 202 |
| `Topics/RingTheory` | 24 | 462 |
| `Topics/SequenceLimits` | 13 | 370 |

建议顺序：`01` → `02` → `03` → `04` → `Shorter` → 挑一个 `Topics`。
`GaloisAdjunctions` 和 `RingTheory` 最重（25 / 24），放最后。

## 关于 `Library/`

上游的 `Library/` 是**教学补丁层**，不是正常写证明该用的东西：

| 文件 | 干了什么 | 我们要不要 |
|---|---|---|
| `Basic.lean` (78行) | 把 `ring` 改写成 `first \| ring1 \| ring_nf`；给 `min`/`max` 加 pretty-printer；补 mathlib 缺的引理 `ge_max_iff`、`abs_sub_le'`、`Finset.sum_univ_eq_single` | 不要 |
| `Short.lean` (31行) | 同上的精简版，给 `Shorter.lean` 用 | 不要 |
| `Ring.lean` (7行) | 一个 `setup` macro | 不要 |
| `Probability.lean` (14行) | 一条 `ENNReal.mul_self_eq_self_iff` | 遇到再说 |

其中被 `Library/Short.lean` 改写的 `ring` 值得留意：它**改变了 `ring`
的语义**（先试 `ring1` 再试 `ring_nf`）。我们在 `import Mathlib` 下用的是
mathlib 原版 `ring`。这不一定是坏事 —— 原版更接近你以后实际会用的东西。

## 分寸

上游的 `Solutions/` 是完整答案，`Exercises/` 是被 `mk_exercises.py` 把证明
替换成 `sorry` 生成的（两种标记：`-- sorry`…`-- sorry` 块，和单行的
`/- inline sorry -/…/- inline sorry -/`）。两个标记在源码副本里都能看到。

我们这边：我只写**题目骨架 + 中文注释 + 每题前 1–2 个 tactic**，剩下的你写。
比上游给的少，但比上游的 `Solutions` 多。

**先别看 `Solutions/`。** 真卡住了再看，看完在 `notes/` 里记下你当时
卡在哪 —— 那才是这份教程对你有价值的地方。

---

来源：`~/Public/lean-GlimpseOfLean/`
上游：<https://github.com/PatrickMassot/GlimpseOfLean>（MIT）

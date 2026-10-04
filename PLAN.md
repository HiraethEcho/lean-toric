# 教学计划

2 h/天，三个阶段。每个阶段结束有一次自测，**不通过就不进下一阶段**。

| 阶段 | 材料 | 规模 | 预计 |
|---|---|---|---|
| 1 | `references/GlimpseOfLean/Exercises` | 137 个证明 | ~25 h |
| 2 | `references/toric/Toric` | 18 文件 / 2050 行 | ~30 h |
| 3 | Prove2Me toric-foliation | 1 定义 + 5 定理 | ~15 h |

合计约 70 h ≈ **35 天**（每阶段之间留缓冲）。

检查进度随时用：

```bash
scripts/status.sh
scripts/check.sh -v exercise/01Rewriting.lean
```

---

## 每天的 2 小时怎么花

| 段 | 时长 | 干什么 |
|---|---|---|
| A | 15 min | 读**下一道题**的材料（散文、注释），不写代码 |
| B | 85 min | 写证明。卡住就跳到下一道，回头再来 |
| C | 20 min | `scripts/check.sh` + 在 `notes/` 记一条今天学到的 |

C 段不能省。"我以为我会了"和"我能写出来"是两件事，只有 C 段能区分。

**卡住超过 30 分钟**才准看 `examples/GlimpseOfLean/Solutions/`。看完必须在 `notes/`
写清楚卡在哪 —— 那条笔记比省下的 30 分钟值钱。

---

# 阶段 1：GlimpseOfLean

先把 `references/GlimpseOfLean/Introduction.lean` 读完（90 行，
1 个完整证明，**不用打字**）。它讲的是 proof state 长什么样：`⊢` 右边是目标，
上面是变量和假设；每写一行 tactic，面板就变一次。

看懂就够了，然后进 `01Rewriting`。

## 顺序

| 次 | 文件 | 洞 | 学什么 | 自测 |
|---|---|---:|---|---|
| 1–2 | `01Rewriting` | 10 | `ring` `rw` `exact` `calc` | 能手写 5 行 `calc` 并解释每行的目标 |
| 3 | `02Iff` | 6 | `↔` 拆两向、`constructor` | 能说清 `constructor` 和 `rw [h]` 各在什么场合用 |
| 4 | `03Forall` | 4 | `∀` `intro` `apply` `specialize` | 拿到一个 `∀` 目标知道先 `intro` |
| 5 | `04Exists` | 3 | `∃` `use` `rcases h with ⟨x, hx⟩` | 能把 `∃` 的假设拆成两部分 |
| 6–9 | `Shorter` | 17 | 综合 + `obtain` `specialize` | 独立做完，不查提示 |
| 10+ | 挑 `Topics` 一个 | 12–25 | 见下 | — |

阶段 1 共 **137** 个证明：Basics `01`–`04` 共 23、`Shorter` 17、`Topics` 共 97。

## Topics 选哪个

| 文件 | 洞 | 内容 | 和阶段 2 的关系 |
|---|---:|---|---|
| `SequenceLimits` | 13 | 实数列极限 | 中 —— `ℕ → ℝ` 的索引和 toric 里的 `Fin n` 同构 |
| `ClassicalPropositionalLogic` | 12 | 经典逻辑 | 低 |
| `IntuitionisticPropositionalLogic` | 12 | 直觉逻辑 | 低（不懂 Heyting 代数别碰） |
| `Probability` | 11 | 概率论 | 低 |
| `RingTheory` | 24 | 交换环、中国剩余定理 | **高** —— toric 大量用环论 |
| `GaloisAdjunctions` | 25 | 伴随 | 中 —— Pang 伴随就是 Galois 伴随 |

**建议**：`RingTheory` 或 `SequenceLimits`。时间够就两个都做。

## 阶段 1 自测

不看任何文件，说得出这些就算过：

- [ ] `ring` 什么时候能用，什么时候一定不能用
- [ ] `rw [h]` 之后目标发生了什么变化
- [ ] `rw [← h]` 的方向指的是哪一边
- [ ] `calc` 里 `_` 代表什么
- [ ] `∀` 目标和 `∃` 目标，分别第一步用什么
- [ ] `obtain ⟨x, hx⟩ := h` 干的是什么

---

# 阶段 2：复现 lean-toric

参考代码已经在 `references/toric/Toric/`（18 文件）+ `references/toric/Toric.lean`
（模块地图），blueprint 只留了编译好的 `references/toric/Toric.pdf`（30 页，
LaTeX 源码没拿过来，在上游）。要刷新副本才需要跑：

```bash
scripts/copy_reference.sh -f ~/Public/lean-toric Toric Toric.lean
```

刷新后在 `references/README.md` 的表里改日期。

## 做法

`src/Toric/` 的路径跟参考树**一一对应**，所以：

```bash
diff -ru references/toric/Toric src/Toric
```

这条命令的正确输出是**只有注释的差异**。代码不同就是写错了。

每做完一个文件，往 `src/Toric.lean` 加一行 import，顺序跟参考仓库一样。

## 顺序（从小到大）

| # | 文件 | 行 | 这一步在建立什么 |
|---|---|---:|---|
| 1 | `Mathlib/LinearAlgebra/Finsupp/LinearCombination.lean` | 16 | `Finsupp.linearCombination` |
| 2 | `Mathlib/Algebra/Category/Ring/Under/Basic.lean` | 16 | 范畴论的小用法 |
| 3 | `Imports.lean` | 20 | 依赖清单 |
| 4 | `Mathlib/Algebra/Polynomial/Bivariate.lean` | 25 | 二元多项式 |
| 5 | `MvLaurentPolynomial.lean` | 36 | 多变量 Laurent 多项式 |
| 6 | `SphericalVariety.lean` | 37 | 球面簇的接口 |
| 7 | `Examples/CharCocharPairing.lean` | 49 | 特征与余特征的配对 |
| 8 | `ToricVariety/FromMonoid.lean` | 54 | 从幺半构造簇 |
| 9 | `Hopf/GrpAlg.lean` | 56 | group algebra |
| 10 | `Mathlib/RingTheory/HopfAlgebra/Convolution.lean` | 61 | Hopf 代数卷积 |
| 11 | `ToricVariety/Defs.lean` | 66 | 簇的定义 |
| 12 | `ToricIdeal.lean` | 89 | 扇的理想 |
| 13 | `Hopf/Diagonalisable.lean` | 118 | 对角化 Hopf 代数 |
| 14 | `GroupScheme/MonoidAlgebra.lean` | 171 | 幺半代数上的群簇 |
| 15 | `GroupScheme/Torus.lean` | 179 | 环面 |
| 16 | `GroupScheme/Character.lean` | 198 | 特征簇 |
| 17 | `Examples/SO2.lean` | 425 | **`SO₂` 的显式构造，最难** |
| 18 | `GroupScheme/Diagonalizable.lean` | 434 | 可对角化群簇，**最难** |

第 1–13 个是声明和小引理，第 14–16 个是真正的构造，第 17–18 个是大工程。
**不要**从 17 开始 —— 卡住的原因会是"前面的没看懂"，不是这题难。

## 版本差异

参考仓库用 mathlib `62d0e07`（toolchain `v4.34.0-rc2`），我们用 `v4.34.1`。
只差一个 patch，破坏性改动很少。真撞上 API 变了：

- 先查 mathlib 的 `Changelog.md`
- 记进 `notes/` —— **版本迁移是这次复现的额外收益**

## 阶段 2 自测

- [ ] 能画出 `lean-toric` 的模块依赖图（谁 import 谁）
- [ ] `ToricVariety/Defs.lean` 里每个字段是什么意思
- [ ] 能说出 `ToricIdeal` 是怎么从扇造出来的
- [ ] `diff -ru` 对参考仓库只有注释差异

---

# 阶段 3：Prove2Me 实战

材料在 `~/Public/lean-prove2me-toric-foliation/`（不在 git 里，需要时拷进 `references/`）。

Fujino–Sato《A remark on toric foliations》定理 1.3。
**这题在文献里已经证过了** —— 这里是形式化，不是出新数学。

## 6 个 item，按依赖顺序

| # | item | 是什么 | 难度 |
|---|---|---|---|
| 1 | `ToricFoliations` | 定义：格 `Fin n → ℤ`、复化 `Fin n → ℂ`、`WallData n`、`divisorIntersection`、`curveLength`、`IsProjectiveSpaceBundle` | 骨架，难在记号对齐 |
| 2 | `divisor_intersection_le_one` | 论文 (3.2)：`D_{v_i} · C ≤ 1` | 中 —— 代入定义后是环算术 |
| 3 | `exists_r_add_one_vectors_in_subspace` | 论文 (3.3)：鸽笼原理，`-K_F · C > r` ⟹ 至少 `r+1` 个向量在 `V` 里 | 中 —— 注意 0/1 下标位移 |
| 4 | `tail_coefficients_eq_one` | Claim：`a_{n-r+1} = ⋯ = a_{n+1} = 1` | **难** —— 整篇的数论核心 |
| 5 | `length_bound` | 定理 1.3(1)：`l_F(R) ≤ r+1` | 中 —— 依赖 2、3、4 |
| 6 | `projective_space_bundle` | 定理 1.3(2)（**goal**）：长射线给出一个 `ℙ^r`-丛 | **最难** |

## 已知的坑（mission-description 自己写的）

- 0/1 下标的位移 —— 论文从 1 开始，Lean 的 `Fin` 从 0 开始
- `ℚ` 里除法是**全域的**，`divisorIntersection` 不需要任何 side condition
- item 4 是整篇的关键，multiplicity 的整除关系必须先建好引理

## 阶段 3 自测

- [ ] 能用 `WallData` 的字段说清论文 (3.1) 的 wall relation
- [ ] 能解释为什么 `divisorIntersection` 不需要假设分母非零
- [ ] item 4 的整除论证每一步都能说出用的是哪个 `mult`

---

## 每天收工前

```bash
scripts/status.sh
```

然后在 `notes/` 加一段。**格式随便，但要有"卡在哪"** —— 那部分三个月后最值钱。
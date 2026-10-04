import Mathlib

/-!
# exercise/02Iff.lean — Implication 与 Equivalence

规则见 `AGENTS.md`：我只写骨架 + 中文注释 + 每题前 1–2 个 tactic，剩下你自己填。

检查：

```
scripts/check.sh exercise/02Iff.lean
scripts/check.sh -v exercise/02Iff.lean   # 列出每个还剩的洞
```

题目原文：`examples/GlimpseOfLean/Exercises/02Iff.lean`
答案：`examples/GlimpseOfLean/Solutions/02Iff.lean`（最后才看）
tactic 速查表：`notes/00-GlimpseOfLean.md` 附录 A

原文件的 `import GlimpseOfLean.Library.Basic` 换成了 `import Mathlib`。
这一题要用到的引理都在 mathlib 里，但**形状和教程写的不同**，见下面每一节的注。

本文件结束时你会用到这四个 tactic：`intro` / `apply` / `have` / `constructor`。
-/

/-!
## 使用 implication

Lean 里"命题的居民恰好就是这个命题的证明"。证 `P → Q` 等价于给出一个把
`P` 的证明变成 `Q` 的证明的**函数**。所以 Lean 用 `→` 写蕴含，而不是 `⇔`
那种逻辑符号（字体小一点的话 `→` 和 `⇒` 你得分清）。

`sq_pos_of_pos` 说的是 `0 < a → 0 < a^2`。下面这个证明就是把"函数"
`sq_pos_of_pos` 作用在假设 `ha` 上。

键盘上打不出来的符号（比如 `→`），把光标放到它上面，tooltip 会告诉你怎么打：
`\to` 加空格。

**本 mathlib 版本的注**：`sq_pos_of_pos` 是泛型版本，
`{M₀} [MonoidWithZero M₀] [PartialOrder M₀] [PosMulStrictMono M₀] : 0 < a → 0 < a^2`。
`ℝ` 满足这些 typeclass，所以在这里直接用没问题。
-/

example (a : ℝ) (ha : 0 < a) : 0 < a^2 := by
  exact sq_pos_of_pos ha

/-!
上面是**正向**证明（forward reasoning）：已知 `0 < a`，把它喂进蕴含。

也可以用**逆向**推理（backward reasoning），也就是 `apply`：手里没有现成的结论，
就从目标倒推"要证这个，只需先证那个"。
-/

example (a : ℝ) (ha : 0 < a) : 0 < (a^2)^2 := by
  apply sq_pos_of_pos -- 靠 sq_pos_of_pos，只需证 `0 < a^2`
  apply sq_pos_of_pos -- 再靠一次，只需证 `0 < a`
  exact ha            -- 这就是假设 ha

/-!
### 练习一

用 `add_pos` 做下一题。

**教程写的形状** `add_pos : 0 < x → 0 < y → 0 < x + y` 在 mathlib v4.34.1 里是
更一般的形式：

```
add_pos : b < c → 0 < a → b < c + a
```

把 `b` 取成 `0` 就是你熟悉的那条：`0 < x → 0 < y → 0 < x + y`。
`apply add_pos` 会**产生两个 goal**，你要一个一个证（Lean 会替你记着还剩几个）。

`p → q → r` 读作 `p → (q → r)`，右结合。
-/

example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 0 < a^2 + b^2 := by
  apply add_pos
  apply sq_pos_of_pos
  exact ha
  apply sq_pos_of_pos
  exact hb

/-!
## `have`：把中间结论起个名字

要宣布一个中间命题，写：

```
have my_name : my_statement := by
```

然后缩进一层。于是多出一个 goal：证 `my_statement`。证完之后，这个命题就以
`my_name` 的名字可用了。

如果证明只有一条 `exact`，可以把 `by` 和 `exact` 都省掉，直接把 term 写在 `:=` 后面。
-/

example (a : ℝ) (ha : 0 < a) : 0 < (a^2)^2 := by
  have h2 : 0 < a^2 := by     -- 宣布 0 < a^2 为子目标
    apply sq_pos_of_pos       -- 开始证子目标
    exact ha                  -- 这行有缩进，属于子目标的证明
  exact sq_pos_of_pos h2      -- 子目标证完，用回来证主目标

/-!
### 练习二

同一个命题，这次**只用正向推理**（`have` 把两个中间结论拎出来，再合成）。
-/

example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 0 < a^2 + b^2 := by
  have ha2 : 0 < a^2 := by 
    apply sq_pos_of_pos
    exact ha
  have hb2 : 0 < b^2 := by
    apply sq_pos_of_pos
    exact hb
  exact add_pos ha2 hb2

/-!
## 证 implication

要证一个蕴含，就得"假设前件、证出后件"。这是 `intro` 干的事。

上面那些题其实偷偷在证 `a > 0 → (a^2)^2 > 0`，只不过前件已经由 binder 替我们
`intro` 好了。
-/

example (a b : ℝ) : a > 0 → b > 0 → a + b > 0 := by
  intro ha hb -- 名字随你起
  exact add_pos ha hb

/-!
### 练习三

纯命题逻辑，不需要任何实数引理。提示：三个 `intro` 就够了，注意 `add_pos` 那种
"把一个假设喂给另一个假设"的形状。
-/

example (p q r : Prop) : (p → q) → (p → q → r) → p → r := by
  intro ha hb hc
  exact hb hc (ha hc)

example (p q r : Prop) : (p → q) → (p → q → r) → p → r := by
  intro ha hb hc
  have hq : q := by
    exact ha hc
  have hqr : q → r := by
    exact hb hc
  exact hqr hq


/-!
用 `intro` 必须给假设起名字。Lean 允许你复用已经用过的名字，此时新假设会
**遮蔽**（shadow）旧的，旧的之后就访问不到了。默认做法：起新名字。
-/

/-!
# Equivalence

## 用 equivalence 重写命题

上一文件里我们用过等式重写。对命题做同样操作的工具是**用等价式重写**，还是 `rw`。
Lean 用 `↔` 表示等价。

接下来会用到这条引理：

```
sub_nonneg : 0 ≤ y - x ↔ x ≤ y
```

注意 v4.34.1 里它的实际形状是 `0 ≤ a - b ↔ b ≤ a`，跟教程一致，只是变量名不同。
-/

example {a b c : ℝ} : c + a ≤ c + b ↔ a ≤ b := by
  rw [← sub_nonneg] -- 这一行 rw 用的是 equivalence
  have key : (c + b) - (c + a) = b - a := by
    ring
  rw [key] -- 这一行 rw 用的是一个等式结果，不是 equivalence
  rw [sub_nonneg] -- 再转回来，得到重言式 a ≤ b ↔ a ≤ b

/-!
### 练习四

换个方向：加在右边。照上面那三步走一遍，形状几乎一样。
-/

example {a b : ℝ} (c : ℝ) : a + c ≤ b + c ↔ a ≤ b := by
  rw [← sub_nonneg]
  have key : (b + c) - (a + c) = b - a := by
    ring
  rw [key]
  rw [sub_nonneg]

/-!
上面这条引理 mathlib 里已经有了，叫 `add_le_add_iff_right`：

```
add_le_add_iff_right (c : ℝ) : a + c ≤ b + c ↔ a ≤ b
```

这行读作："`add_le_add_iff_right` 是一个函数，吃进一个实数 `c`，吐出
`a + c ≤ b + c ↔ a ≤ b` 的一个证明"。下面是用它的一个例子。
-/

example {a b : ℝ} (ha : 0 ≤ a) : b ≤ a + b := by
  calc
    b = 0 + b := by ring
    _ ≤ a + b := by rw [add_le_add_iff_right b]; exact ha

/-!
## 把 equivalence 当成一对蕴含用

上面证明的第二行有点傻：用命题重写把目标化到假设 `ha`。更自然的做法是把等价式看成
**双向蕴含**。`h : P ↔ Q` 的两个方向分别是 `h.1 : P → Q` 和 `h.2 : Q → P`。
于是可以改写成：
-/

example {a b : ℝ} (ha : 0 ≤ a) : b ≤ a + b := by
  calc
    b = 0 + b := by ring
    _ ≤ a + b := by exact (add_le_add_iff_right b).2 ha

/-!
### 练习五

换成 `add_le_add_iff_left a : a + b ≤ a + c ↔ b ≤ c` 做同样的事。
先想清楚你需要的是 `.1` 还是 `.2`。
-/

example (a b : ℝ) (hb : 0 ≤ b) : a ≤ a + b := by
  calc
    a = a + 0 := by ring
    _ ≤ a + b := by exact (add_le_add_iff_left a).2 hb

/-!
**重要**：上面这些题里我们把 `add_le_add_iff_left` 这类引理当等价式的入门练习手工调用。
真做数学时逐条调用这种东西会累死人。有 tactic 专门自动干这些（`linarith` 等），
但那不是本文件的主题。

## 证 equivalence

两条路：

1. `rw` 到目标变成重言式 `P ↔ P`（跟等式那套一样）。
2. 用 `constructor` 把 `↔` 拆成两条蕴含分别证。

下面的例子用了第二条路。把光标停在 `constructor` 后面，会看到两个 goal。
`·` 这个"focus dot"把每个 goal 的证明在排版上隔开，Lean 替你记哪个还没证完。
-/

example (a b : ℝ) : (a - b) * (a + b) = 0 ↔ a^2 = b^2 := by
  constructor
  · intro h
    calc
      a^2 = b^2 + (a - b) * (a + b) := by ring
        _ = b^2 + 0                  := by rw [h]
        _ = b^2                      := by ring
  · intro h
    calc
      (a - b) * (a + b) = a^2 - b^2 := by ring
                      _ = b^2 - b^2 := by rw [h]
                      _ = 0         := by ring

/-!
### 练习六

`a = b ↔ b - a = 0`。`constructor` 拆两条，每条都很短 —— 一条 `intro` 加一个
`rw`/`linarith` 级别的动作就能收尾。不许翻答案，自己想。
-/

example (a b : ℝ) : a = b ↔ b - a = 0 := by
  constructor
  · intro h
    linarith
  · intro h
    linarith

/-!
# 恭喜，02Iff 到此为止

这个文件里你学会了怎么处理 implication 和 equivalence，用到的 tactic：

* `intro` —— 证蕴含：把前件请进 context
* `apply` —— 逆向推理：从目标倒推所需
* `have` —— 正向推理：给中间结论起名
* `constructor` —— 把 `↔`（以及 `∧`）拆成两半

下一站：`examples/GlimpseOfLean/Exercises/03Forall.lean`。
要不要我照这个格式给你铺 03 的骨架，说一声。
-/

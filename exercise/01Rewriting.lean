import Mathlib

open Real

/-!
# exercise/ — 这里面的代码是你写的

规则（见 `AGENTS.md`）：

* 我只写**题目骨架 + 中文注释 + 每题前 1–2 个 tactic**
* 剩下的 tactic 你自己填
* 卡住超过 30 分钟再叫我

检查（比 `lake build` 快得多，1–5 秒）：

```
scripts/check.sh exercise/01Rewriting.lean
scripts/check.sh -v exercise/01Rewriting.lean   # 列出每个还剩的洞
scripts/check.sh                               # 全部练习的进度
```

填完把 `sorry` 换成真正的证明，"N 个待填证明" 会往下掉。

题目原文：`examples/glimpseoflean/GlimpseOfLean/Exercises/01Rewriting.lean`
答案：`examples/glimpseoflean/GlimpseOfLean/Solutions/01Rewriting.lean`（最后才看）
导读 + tactic 速查表：`notes/00-GlimpseOfLean.md`
原文件的 import 依赖它自己的 `GlimpseOfLean.Library.Basic`，这里换成了 `import Mathlib`。
-/

/-!
# Computing

## `ring`

最早遇到的一类证明就是"算一下"。它不是真的在算，而是用一堆关于运算律的
引理在推。mathlib 把这些打包成 `ring` tactic：凡是能由交换环公理推出的
等式，它都能证。

`ring` 只认交换环公理 —— 它不知道 `exp`、不知道 `^`、不知道任何有结构的
东西。遇到超出边界的场合要靠下一节的 `rw`。

小提醒：`a * b * c` 在 Lean 里读作 `(a * b) * c`，左结合。`ring` 知道乘法
可结合，所以它自己会用上这条引理；但你自己写 `calc` 时要按左结合的形状对齐。
-/

example (a b c : ℝ) : (a * b) * c = b * (a * c) := by
  ring

/- 你的第一题。目标两边都是多项式，展开后由交换律和分配律相等。

`ring` 处理的正是这一类：它把两边都归约成规范形式再比较。
所以这一题只有一行。**我不写答案** —— 上面那段 `ring` 的例子里已经有了，
动手敲一遍比看我敲要有用。

目标：`example (a b : ℝ) : (a+b)^2 = a^2 + 2*a*b + b^2 := by sorry`
-/

example (a b : ℝ) : (a+b)^2 = a^2 + 2*a*b + b^2 := by
  ring

/-!
# The rewriting tactic

`ring` 不会碰假设。假设给的信息要用**重写**：`rw`。
等式的基本性质 —— 任意命题里出现的 A 都可以换成 B，只要你知道 `A = B`。
这一步就是把左边展开，所以要在 `rw [h]` 之后**重新看目标**。
-/

example (a b c d e : ℝ) (h : a = b + c) (h' : b = d - e) : a + e = d + c := by
  rw [h]
  rw [h']
  ring

-- 第一步之后目标变成了 `b + c + e = d + c`。
-- 可以理解成："我想证 `a + e = d + c`，但既然 `h` 说 `a = b + c`，
-- 那只要证 `b + c + e = d + c`。"
--
-- `rw` 不知道该往哪重写，所以每一步都要你点名。可以一次写多个：
--   rw [h, h']
-- 它按从左到右的顺序依次作用在**当前**目标上。

/- 第二题。目标里有 `a` 和 `b`，而 `h`、`h'` 正好各管一个。
注意 `ring` 依然会用，但它不碰假设 —— 这里的 `+ 4 * d` 只能靠假设化简。

我给第一步：先处理 `h`（它管 `b`，而 `b` 出现在目标的左边）。

```lean
  rw [h]        -- 目标变成 a + d + d = c + 4 * d
```

剩下 `a` 怎么办？提示：看 `h'` 管的是谁。
-/

example (a b c d : ℝ) (h : b = d + d) (h' : a = b + c) : a + b = c + 4 * d := by
  rw [h']
  rw [h]
  ring

/-!
## 用引理重写

上面重写的是局部假设。引理同样能重写。`ring` 只懂环公理，所以
`exp (x + y) = exp x * exp y` 这类必须靠 `exp_add`。

不给参数时，`rw` 重写**第一个**匹配的子表达式。有时候需要更精确，
就把参数写上：`rw [exp_add (a + b) c]`。
-/

example (a b c : ℝ) : exp (a + b + c) = exp a * exp b * exp c := by
  rw [exp_add (a + b) c]
  rw [exp_add a b]

example (a b c : ℝ) : exp (a + b + c) = exp a * exp b * exp c := by
  rw [exp_add, exp_add]

/- 第三题。目标里有个减法、有个 `exp 0`，而右边分母上挂了个 `exp 0`。
两个可用的引理：`exp_sub x y : exp (x - y) = exp x / exp y`，
以及 `exp_zero : exp 0 = 1`。

原题给了两条路：要么用 `ring`，要么用 `mul_one x : x * 1 = x` 把右边分母
上的 `1` 消掉。

第一步我用 `exp_sub`，把左边的减号拆开：

```lean
  rw [exp_sub]   -- 目标变成 exp (a + b) / exp c = (exp a * exp b) / (exp c * exp 0)
```

接下来左边还剩一个 `exp (a + b)`，右边还剩一个 `exp 0`。想想看。
-/

example (a b c : ℝ) : exp (a + b - c) = (exp a * exp b) / (exp c * exp 0) := by
  rw [exp_sub (a+b) c]
  rw [exp_add a b]
  rw [exp_zero] 
  rw [mul_one]

/-!
# 从右往左重写

等式是对称的，所以也能用 `←` 把右边的换成左边的。

键盘上没有 `←`：把光标放到它上面看 tooltip，或者直接打 `\l `（反斜杠、
小写 l、空格）。

**最容易搞错的地方**：`←` 说的是"你要用的那条引理"的方向，不是"你要证的
那个目标"的方向。`rw [← h]` 是拿 `h` 的**左边**去换目标里的东西。
-/

example (a b c d e : ℝ) (h : a = b + c) (h' : a + e = d + c) : b + c + e = d + c := by
  rw [← h, h']

/- 第四题。这一题考的是上面那个方向问题。

目标 `b + c = d`。三条假设：`h : a = b + b`、`h' : b = c`、`h'' : a = d`。
目标的左边是 `b` 和 `c`，右边是 `d` —— 你手上**唯一**能产出 `d` 的信息是
`h''`，而 `h''` 的左边是 `a`，不在目标里。

所以第一步必须把 `a` 搬进目标：

```lean
  rw [← h'']   -- 目标变成 b + c = a
```

现在目标里出现了 `a`，`h` 和 `h'` 就都能用上了。接着做。
-/

example (a b c d : ℝ) (h : a = b + b) (h' : b = c) (h'' : a = d) : b + c = d := by
  rw [← h'']
  rw [h]
  rw [h']

/-!
# 在假设里重写

也可以把重写作用到局部假设上：语法是 `rw [引理] at h`。
`exact` 给出显式证明项。

`calc` 则把证明写成论文里的推导链的样子。每一行的 `:=` 右边要证的是
"这一行左边 = 上一行左边"（第一行则和整体左端相等）。
把光标放在每个 `by` 后面看 tactic state，逐行确认。
-/

example (a b c d : ℝ) (h : c = d*a + b) (h' : b = d) : c = d*a + d := by
  rw [h'] at h
  -- 现在的 `h` 恰好就是我们要证的东西
  exact h

example (a b c d : ℝ) (h : c = b*a - d) (h' : d = a*b) : c = 0 := by
  calc
    c = b*a - d   := by rw [h]
    _ = b*a - a*b := by rw [h']
    _ = 0         := by ring

/- 第五题，用 `calc`。目标和假设：

```
(a b c : ℝ) (h : a = b + c) : exp (2 * a) = (exp b) ^ 2 * (exp c) ^ 2
```

策略：先把 `a` 换成 `b + c`，再把 `2 * (b + c)` 重排成 `b + b + c + c`，
然后两次 `exp_add`，最后把 `x * x` 收成 `x ^ 2`。

我写第一步示范 `calc` 的形状 —— 注意每行左端的 `_` 代表"上一行的结果"：

```lean
    exp (2 * a) = exp (2 * (b + c)) := by rw [h]
```

后面四行你来。第 4、5 行的引理提示：mathlib 里 `x ^ 2` 展开就是 `x * x`，
你可以在 `#check` 里找它的名字。
-/

example (a b c : ℝ) (h : a = b + c) : exp (2 * a) = (exp b) ^ 2 * (exp c) ^ 2 := by
  calc
    exp (2 * a) = exp (2 * (b + c))                 := by rw [h]
              _ = exp ((b + b) + (c + c))           := by ring
              _ = exp (b + b) * exp (c + c)         := by rw [exp_add (b+b) (c+c)]
              _ = (exp b * exp b) * (exp c * exp c) := by rw [exp_add, exp_add]
              _ = (exp b) ^ 2 * (exp c)^2           := by ring

/-!
写长证明时有个实用技巧：把 Lean Infoview 的状态刷新**暂停**（右上角的
pause 图标），先把整条推导写完、每行结尾填 `:= ?_`，再恢复刷新逐行补证明。

下划线要放在第一行左端的正下方。对齐 `=` 和 `:=` 不是必须的，但好看。
-/

/- 第六题。目标 `c = 2*a*d`，假设 `h : c = d*a + b`、`h' : b = a*d`。
两条假设各消掉一个尾巴，最后剩一个交换律。

先把 `calc` 的架子搭出来（三行左端我写好了，证明你填）—— 这就是上面说的
"先写 `:= ?_`" 的做法：

```lean
  calc
    c = d*a + b   := by ?
    _ = d*a + a*d := by ?
    _ = 2*a*d     := by ?
```

前两行是 `rw [h]` 和 `rw [h']`，最后一行交给 `ring`。
-/

example (a b c d : ℝ) (h : c = d*a + b) (h' : b = a*d) : c = 2*a*d := by
  calc
    c = d*a + b   := by rw [h]
    _ = d*a + a*d := by rw [h']
    _ = 2*a*d     := by ring

/-!
# 恭喜，01Rewriting 到此为止

这一份你见过了四种 tactic：

* `ring` —— 交换环里的计算，不碰假设
* `rw` —— 用假设或引理做替换，每步都要重新读目标
* `exact` —— 直接给一个证明项
* `calc` —— 把证明写成推导链

下一份：`02Iff.lean`。
-/

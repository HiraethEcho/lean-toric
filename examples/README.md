# examples/ — 成品示例

这里只放**已经证完的东西**，当范例读。当前一份：`GlimpseOfLean/`。

```
GlimpseOfLean/
├── Solutions/        全部答案（01–04、Shorter、Topics/）
└── Library/          Solutions 的 import 依赖，教学补丁层
```

`Solutions/*.lean` 都写着 `import GlimpseOfLean.Library.Basic`。这个仓库里没有
那棵树，所以**这些文件在这里编不过**，只读。真要跑，抄进 `exercise/` 并把 import
换成 `Mathlib`（`exercise/` 里每个文件都已经这么做过一遍）。

`Library/` 干了什么，见 [`../notes/00-GlimpseOfLean.md`](../notes/00-GlimpseOfLean.md)
附录 B「关于 Library」。一句话：它把 `ring` 改写成 `first | ring1 | ring_nf`，
加了 `min`/`max` 的 pretty-printer，补了三条 mathlib 缺的引理。

## 规矩

**不要改这里的内容。** 它是唯一的成品对照物，改脏了就失去参照价值。

题目原文、上游源码树在 [`../references/`](../references/README.md)。

## 清单

| dir | 来源 | 拷入日期 | 用途 |
|---|---|---|---|
| `GlimpseOfLean/` | `~/Public/lean-GlimpseOfLean` | 2026-10-01 | 阶段 1 的答案 + 其依赖 |

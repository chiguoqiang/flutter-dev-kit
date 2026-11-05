# lib/ · 状态管理规则（L3 · Riverpod）

> 仅当任务触碰 `lib/` 下任何 Dart 代码时生效；与根 `AGENTS.md` 冲突以本文件为准。

## 边界

- 所有跨页面/跨组件状态一律 Riverpod；单 Widget 内部的临时 UI 态（输入框、动画进度）可用局部 State
- Provider 定义放对应域文件（如 `lib/pages/customer_providers.dart` 或域内就近文件），
  禁止集中堆在 main.dart / 一个 giant providers.dart

## Riverpod 写法（Riverpod 3.x）

- 状态类不可变：字段 `final`，变更只经 `copyWith` 生成新实例后返回新状态
- 异步数据一律 `AsyncValue`，UI 必须三分支处理（loading / error / data），
  禁止只写 data 分支；error 分支至少给重试入口
- 重建范围最小化：只 watch 需要的 Provider；列表项用 `ProviderScope`/family 隔离，
  禁止整页 watch 大对象导致全页重建
- 依赖注入用 `ref` 传递，Provider 内禁止引用 `BuildContext` / `WidgetRef`
- 与路由配合：需要 context 的动作放在 Widget 层（`ref.read` 触发），不放进 Provider

## 常见坑

- 在 Provider 体内直接发网络请求却不包 `AsyncValue.guard` → 异常裸奔；
  统一用 `AsyncValue.guard(() => api())` 或 try/catch 转 error 状态
- 忘记 dispose 自动管理的自动依赖（autoDispose）导致页面退出后仍轮询 →
  轮询/订阅类 Provider 必须标 autoDispose

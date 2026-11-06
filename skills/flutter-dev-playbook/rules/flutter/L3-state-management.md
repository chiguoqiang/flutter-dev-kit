# 状态管理规则（L3）

> 方案以 `docs/tech-stack.yaml` 的 `state_management` 为准（默认 Riverpod）；本文件只写通用铁律。
> 放 `lib/AGENTS.md`（触碰任何 lib 代码即生效）。预算 ≤40 行。

## 通用（无论哪种方案）

- 状态类不可变：字段 `final`，变更只经 `copyWith` / 事件方法；禁止原地改字段后手动通知
- 状态里禁止存 `BuildContext`、禁止存 Widget 引用
- 状态提升最小化：输入框、动画等局部 UI 态留在组件内部，不进全局状态
- 重建范围最小化：只订阅需要的字段（selector / select / 细粒度 provider），禁止整页 watch
- 业务规则禁止写进状态层：计算与校验下沉 model/service，状态层只做"取数→持状态→编排动作"

## 默认方案 · Riverpod（kit 默认选型）

- Provider 内禁止引用 `WidgetRef` / `BuildContext`
- `AsyncValue` 必须三态处理（loading / error / data），不许忽略 error 分支
- 统一用 `AsyncValue.guard(() => api())` 或 try/catch 包请求，异常裸奔视为违规
- 轮询/订阅类 Provider 必须标 `autoDispose`，防页面退出后仍跑

## 其他方案

选型换为下列方案时，**细则以库级规范为准**（本文件不再重复维护）：

- Bloc → `libs/bloc.md`
- GetX → `libs/getx.md`
- Provider / setState / 未收录库 → 项目自写 `docs/rules/state-management.md`（覆盖本层）

# 状态管理规则（L3）

> 方案已在根 `AGENTS.md` 声明：<setState | Provider | Riverpod | Bloc>，本文件细化写法。
> 放 `lib/AGENTS.md`（触碰任何 lib 代码即生效）。预算 ≤55 行。

## 通用（无论哪种方案）

- 状态类不可变：字段 `final`，变更只经 `copyWith` / 事件方法；禁止原地改字段后手动通知
- 状态里禁止存 `BuildContext`、禁止存 Widget 引用
- 状态提升最小化：输入框、动画等局部 UI 态留在组件内部，不进全局状态
- 重建范围最小化：只订阅需要的字段（selector / select / 细粒度 provider），禁止整页 watch

## 方案细则（按本项目所选方案保留一段，删掉其余）

- **setState**：仅限单页面内且联动字段 ≤3 个；跨页面共享数据必须换正式方案或经 service 层
- **Provider**：变更统一在 ChangeNotifier 方法内完成再 `notifyListeners()`；禁止在 `build` 中调用会触发通知的方法
- **Riverpod**：Provider 内禁止引用 WidgetRef；`AsyncValue` 必须三态处理（loading / error / data），不许忽略 error 分支
- **Bloc**：一个 Bloc 只管一个聚合根；UI 用 BlocBuilder / BlocListener 按需订阅，禁止到处 `context.read` 触发事件

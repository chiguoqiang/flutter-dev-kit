# lib/pages/ & lib/widgets/ · UI 层规则（L3 · go_router）

> 仅当任务触碰 `lib/pages/` 或 `lib/widgets/` 时生效；与根 `AGENTS.md` 冲突以本文件为准。

## 页面与路由

- 一页一文件 `*_page.dart`；新路由必须先在 `lib/router.dart` 注册（name 用小驼峰）
- 跳转统一 `context.go('/customer/$id')` 或 `context.pushNamed('customerDetail', pathParameters: ...)`；
  禁止 `Navigator.push` 与 go_router 混用
- 深链/鉴权重定向等路由级逻辑只改 `router.dart`，不散落在页面里

## 页面结构

- `build()` 超过 ~80 行或嵌套超过 4 层 → 拆私有 Widget 或提升 `lib/widgets/`
- 页面只做三件事：watch Provider 取状态 / 触发动作（ref.read）/ 布局；业务规则下沉 service/model
- Riverpod：Widget 用 `ConsumerWidget` / `ConsumerStatefulWidget`；
  watch 只取需要的 Provider（见 `lib/AGENTS.md`）

## build() 内禁止

- 网络请求、文件 IO、重计算
- 创建 Controller 或订阅（initState 创建、dispose 释放）
- 硬编码 `Color(0xFF…)` / 裸 `TextStyle` / 裸间距数字
  （一律 `Theme.of(context)` 或 `AppTheme.gap*`，见 `lib/theme/app_theme.dart`）

## 性能与正确性

- 长列表 `ListView.builder` + `ValueKey(业务id)`；item 尽量 const
- `await` 后使用 `context` 前必须 `if (!context.mounted) return;`
- TextEditingController / FocusNode / AnimationController / StreamSubscription 必须 dispose
- 四态（loading/empty/error/success）必须有实现，标准见 `docs/ui/` 对应页面文档

## 组件库（lib/widgets/）

- 复用 ≥2 处才入库；参数 `required` 具名 + 回调 `onXxx`
- 组件不直接访问 ApiClient/Store：数据由构造参数或 ProviderScope 注入

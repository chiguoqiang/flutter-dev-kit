# lib/pages/ & lib/widgets/ · UI 层规则（L3）

> 仅当任务触碰 `lib/pages/` 或 `lib/widgets/` 时生效；与根 `AGENTS.md` 冲突以本文件为准。预算 ≤60 行。

## 页面结构

- 一页一文件放 `lib/pages/`，命名 `*_page.dart`；路由方式全项目统一（<Navigator.push | 命名路由 | go_router>）
- `build()` 超过 ~80 行或嵌套超过 4 层 → 必须拆出私有 Widget 或提升到 `lib/widgets/`
- 页面只做三件事：取数（service）→ 持有状态 → 布局；业务规则下沉到 service / model

## build() 内禁止

- 网络请求、文件 IO、重计算（大列表的排序 / 过滤在状态变更时做一次，不在 build 里做）
- 创建 Controller 或订阅（一律 initState 创建、dispose 释放）
- 硬编码 `Color(0xFF…)` / 裸 `TextStyle`（必须走 `Theme.of(context)` 或 `lib/theme/`）

## 性能与正确性

- 长列表必须 `ListView.builder`；item Widget 尽量 `const` 构造
- `await` 之后使用 `context` 前必须 `if (!mounted) return;`
- TextEditingController / AnimationController / FocusNode / StreamSubscription 必须 dispose
- 列表项有状态或会增删时必须给 Key（`ValueKey(业务唯一id)`），禁止用 index 当 Key

## 组件库（lib/widgets/）

- 复用 ≥2 处才进组件库；参数用 `required` 具名 + 回调 `onXxx` 命名
- 组件不直接访问全局单例 / 服务：数据由构造参数注入，保证可测试

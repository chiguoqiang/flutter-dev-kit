# lib/widgets/ · 复用组件库规则（L3）

> 就近薄指针：UI 通用规则（四态/命名/热区/禁硬编码）见 `lib/pages/AGENTS.md`，
> 基础封装标准见 rules/flutter/INFRA-STANDARD.md §6——本文件不重复，只补 widgets 专属。

- 复用 ≥2 处才入库；入库组件必须支持 `const` 构造
- 参数用 `required` 具名 + `onXxx` 回调命名；禁止可选位置参数堆超过 3 个
- 组件禁止 import 任何 service/store/单例：数据经构造参数注入（保证可测试）
- 组件内禁止路由跳转（导航归页面）；如需通知上层用回调

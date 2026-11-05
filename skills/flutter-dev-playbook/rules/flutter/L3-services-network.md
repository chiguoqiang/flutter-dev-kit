# lib/services/ · 网络与存储层规则（L3）

> 仅当任务触碰 `lib/services/`（或网络 / 持久化代码）时生效；与根 `AGENTS.md` 冲突以本文件为准。
> 放置：本目录 `AGENTS.md`，或 `.cursor/rules/services.mdc`（globs: `lib/services/**`），或 `.github/instructions/services.md`（applyTo: `lib/services/**`）。预算 ≤55 行。

## 边界（最重要）

- 所有 HTTP 必须收敛到本层唯一客户端（<dio 单例 | http 封装 | `lib/services/<xxx>_api.dart`>）
- UI 层（pages/widgets）禁止 `import 'package:dio/http.dart'`；禁止拼 URL、禁止手写 JSON 编解码
- 本地存储（shared_preferences / hive / sqflite）同样收敛到 `*_store.dart`，禁止散落各页面

## 请求规范

- 每个请求必须设置超时（连接 <10s> / 接收 <30s>），禁止无限等待
- 错误三分法并自定义类型：网络异常 / 业务错误码 / 解析失败；UI 只 catch 这三种，不碰底层异常
- 打日志必须脱敏：token、手机号等先掩码再输出

## 数据契约

- JSON 解码在本层完成，对外只返回 Model；禁止把 `Map<String, dynamic>` 泄露给 UI
- 字段缺失是常态：解析必须容错（try + 默认值），单字段出错不能炸掉整个请求

## 测试

- 每个 api / store 方法至少 1 个成功用例 + 1 个失败路径用例
- 测试禁止真实网络：mock 掉 HTTP 客户端再断言

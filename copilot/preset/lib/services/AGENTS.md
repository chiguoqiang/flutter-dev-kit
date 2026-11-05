# lib/services/ · 网络与存储层规则（L3）

> 仅当任务触碰 `lib/services/`（或网络 / 持久化代码）时生效；与根 `AGENTS.md` 冲突以本文件为准。

## 边界（最重要）

- 所有 HTTP 必须走 `lib/services/api_client.dart` 的 `ApiClient.instance`（dio 单例）
- UI 层（pages/widgets）禁止 `import 'package:dio/dio.dart'`；禁止拼 URL、禁止手写 JSON 编解码
- 本地存储（shared_preferences / hive / sqflite 引入时）同样收敛到 `*_store.dart`

## 请求规范

- 超时已统一在 ApiClient（连接 10s / 接收 30s，来自 `Config`），禁止单独请求另设超时绕过
- 错误统一收敛为 `ApiException`（网络/超时 → 用户可读文案；业务码 → code+message）；
  UI 只 catch `ApiException`，禁止 catch DioException
- 每个后端域一个 `<域>_api.dart`（如 `customer_api.dart`），方法返回 Model，不返回 `Map`
- 日志必须脱敏：token、手机号、客户敏感信息先掩码再输出

## 数据契约

- JSON 解码在本层完成；禁止把 `Map<String, dynamic>` 泄露给 UI
- 字段缺失是常态：解析容错（默认值/可空），单字段出错不能炸掉整个请求
- 新增接口的完整流程见 `docs/ai-coding-rules/flutter/PLAYBOOK-NEW-API.md`（先建 `docs/api/` 文档）

## 测试

- 每个 api / store 方法至少 1 个成功用例 + 1 个失败路径用例（mocktail mock ApiClient/Dio）
- 测试禁止真实网络

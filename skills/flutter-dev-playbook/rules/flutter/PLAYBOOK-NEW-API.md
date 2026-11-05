# Playbook C · 对接新接口 SOP（API 文档 → Model + Service + Test）

> 场景：拿到接口文档（或后端描述），要生成对应的 Dart 模型与服务方法。
> 本文件是 `PLAYBOOK-NEW-FEATURE.md` 中 **类型 B（对接新接口）** 的详细版。
> 文档怎么写见 `API-DOC-TEMPLATE.md`。

---

## 流程总览

```text
拿到接口 → ① 文档落位 docs/api/ → ② L2 路由表登记
        → ③ 发 Agent 生成任务（Prompt 模板）→ ④ 人工 review（检查清单）
        → ⑤ DoD → ⑥ 提交（文档改动与代码同一 PR）
```

## ① 文档落位

- 按 `API-DOC-TEMPLATE.md` 写入 `docs/api/<域名>.md`；已有域直接追加接口小节
- 响应示例**必须真实抓包**；可空性列必须逐字段确认过

## ② 路由表登记

在根 `AGENTS.md` 的「深入阅读 · 路由表」加/更新一行：

```markdown
| 接口对接 / docs/api/ 下文档 | docs/api/<域名>.md | 接口契约与字段可空性 |
```

## ③ 发 Agent 生成任务（Prompt 模板，直接复制改占位符）

```text
请实现「<中文接口名>」接口对接，契约见 docs/api/<域名>.md 第 <N> 节：

1. 先读 lib/models/AGENTS.md、lib/services/AGENTS.md 与 docs/api/<域名>.md 文件头
2. Model：按响应字段表新增/修改 <ModelName>——
   字段可空性必须与文档一致；金额/ID 用 int 或 String；
   提供 fromJson/toJson/==/hashCode/copyWith；
   文档备注中的特殊解析（如二次 jsonDecode）在 model 或 service 层实现并注释
3. Service：在 lib/services/<域>_api.dart 新增 <methodName>——
   走 ApiClient 唯一出口；错误收敛为 ApiException；禁止把 Map 泄露给 UI
4. Test：成功路径 + 失败路径（mock HTTP，用真实响应示例做 fixture）
5. 完成后跑 flutter analyze（零 error）与 flutter test（全绿）

约束：不改生成文件；不动 android/ios；不新增依赖。
```

> 单文件多接口：把第 2/3/4 步按接口逐条列出即可，顺序仍按 model → service → test。

## ④ 人工 review 检查清单（Agent 交付后逐项过）

- [ ] 每个字段的可空性与文档表格**逐字段核对**（最高频出错点）
- [ ] number 字段类型：文档写 int 的没生成 double；金额/ID 没用 double
- [ ] 备注区的坑都被处理（二次解码、默认值、截断限制）
- [ ] service 走唯一客户端、有超时、错误是 ApiException（不是裸 rethrow）
- [ ] model 有 `==`/`hashCode`/`copyWith`；测试含 round-trip
- [ ] 测试 fixture 用的是文档里的真实响应示例（不是 Agent 自己编的）
- [ ] 没有顺手改无关代码 / 没加依赖

## ⑤ DoD

同 `PLAYBOOK-NEW-FEATURE.md` 第 4 步（analyze / test / format / 红线 / 冒烟），
另加：**真实环境调通一次**（文档示例 ↔ 真实响应 diff 无差异；有差异先改文档再改代码）。

## ⑥ 提交

`feat(api): add <methodName> for <域>`；**文档与代码同一 PR**。

---

## 进阶：有 OpenAPI/Swagger 时

| 方案 | 适用 | 说明 |
|---|---|---|
| 仅当文档源 | 推荐 | 用 swagger 转 Markdown 填入 `docs/api/`，仍按本 SOP 手写薄 service——风格与既有规则一致 |
| openapi_generator 全量生成 | 接口多且后端规范稳定 | 生成物放独立目录并整体加入"禁止手改"红线；团队需明确二选一，禁止混用 |

## 常见坑（踩过才留）

- 文档示例是编的 → 生成即错；**宁可晚一天也要真实抓包**
- 后端悄悄加/删字段 → 联调用真实响应 diff 一次文档
- 错误格式各接口不一致 → 文件头先写通用错误结构，例外接口在备注注明
- `result` 类字段是"字符串套 JSON" → 在 model 层集中二次解码，别散在 UI

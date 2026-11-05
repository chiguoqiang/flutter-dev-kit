# API 文档标准模板

> 目的：一份**人和 Agent 都能读**的接口契约。Agent 据此生成 Dart Model + Service 方法 + 测试
> （流程见 `PLAYBOOK-NEW-API.md`）。
> 组织方式：**一个接口域一个文件**，放 `docs/api/<域名>.md`（如 `docs/api/quiz.md`），
> 新增接口往对应文件追加小节——禁止一个巨型文件装所有接口（索引式原则）。
> 来源优先级：后端 OpenAPI/Swagger 导出 > Apifox/Postman 整理 > 按本模板手写。

---

## 一、文件头（每个域一份，只写一次）

```markdown
# <域名> 接口文档 · <系统名>

- Base URL: <https://api.example.com>（环境差异见 lib/config.dart）
- 鉴权: <Authorization: Bearer <token> | 无>；token 获取方式: <…>
- 通用 Header: <Content-Type: application/json 等>
- 通用错误格式: <{"code": int, "message": string}；HTTP 200 也可能带业务错误码>
- 分页约定: <page/pageSize，返回 total | 无>
- 字段风格: 后端 <snake_case> → Dart <camelCase>，由 model 层集中转换
```

## 二、接口小节模板（每个接口复制一份）

```markdown
### <序号>. <中文接口名> · <英文方法名>

- **请求**: `<METHOD> /path/to/api`
- **用途一句话**: <…>

#### Headers（通用之外的增量）
| 名称 | 值 | 说明 |
|---|---|---|

#### 请求参数
| 参数 | 位置 | 类型 | 必填 | 默认 | 说明 |
|---|---|---|---|---|---|
| <name> | body / query / path | string / int / double / bool / array / object | 是/否 | <…> | <…> |

请求示例:
```json
{ "…" : "…" }
```

#### 响应
响应示例（**必须真实抓包，禁止手编**）:
```json
{ "…" : "…" }
```

| 字段 | 类型 | 可空 | 说明 |
|---|---|---|---|
| <a.b.c 路径> | <string/int/double/bool/array/object> | 是/否 | <…> |

#### 错误码
| code / HTTP | 含义 | UI 处理建议 |
|---|---|---|

#### 备注（坑）
- <如：某字段是"JSON 字符串"需二次解码；某接口 400 上限 256 字符等>
```

## 三、写文档的规则（写的人必须遵守）

1. **示例必须真实**：用 Apifox / curl 抓真实响应贴进来；编造的示例会让 Agent 生成错误 model
2. **可空性显式标注**：`可空=是` 直接映射 Dart `String?`——这列错，线上就崩
3. **类型写 JSON 实际类型**：`number` 必须注明 int 还是 double；**金额/ID 一律 int 或 string**
4. **时间字段注明格式**：ISO8601 字符串 / int 时间戳（秒/毫秒）
5. **接口变更必须同步改文档**：字段增删的 PR 必须包含本文档改动，否则文档即刻作废
6. 联调时若真实响应与文档不符：**以真实响应为准改文档**，再让 Agent 重新 diff 生成

---

## 四、填好的示例（节选自 quiz 域）

```markdown
### 1. 生成练习题 · generateQuiz

- **请求**: `POST /v1/apps/quiz/workflows/run`
- **用途一句话**: 按年级/知识点生成一组练习题

#### 请求参数
| 参数 | 位置 | 类型 | 必填 | 默认 | 说明 |
|---|---|---|---|---|---|
| inputs.grade | body | string | 是 | - | 年级+册别，如"八年级上册" |
| inputs.knowledge_point | body | string | 否 | 随机 | 知识点 |
| response_mode | body | string | 是 | blocking | 固定值 |
| user | body | string | 是 | - | 用户标识 |

#### 响应示例（真实抓包）
```json
{
  "data": {
    "outputs": { "result": "[{\"id\":\"q1\",\"type\":\"single\",\"stem\":\"3+5=?\",\"answer\":\"8\"}]" },
    "status": "succeeded"
  }
}
```

| 字段 | 类型 | 可空 | 说明 |
|---|---|---|---|
| data.outputs.result | string | 否 | 题目数组的 **JSON 字符串**，需二次 jsonDecode |
| data.status | string | 否 | 失败时为 failed，result 为空 |

#### 错误码
| HTTP | 含义 | UI 处理建议 |
|---|---|---|
| 400 | 参数超限/类型错 | 提示重试，日志记录原文 |
| 401 | token 失效 | 跳登录 |

#### 备注（坑）
- result 是"字符串套 JSON"，解析顺序：jsonDecode(外层) → 取 result → 再 jsonDecode
- inputs 里长文本参数若类型选错会被截断为 256 字符
```

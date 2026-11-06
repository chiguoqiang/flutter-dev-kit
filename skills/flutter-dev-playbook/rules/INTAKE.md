# 材料交接清单（INTAKE）

> 用法：把下面四类材料按"给法"放入项目或直接发给 Agent，然后说"开始开发"。
> Agent 按 `.github/skills/flutter-dev-playbook/rules/flutter/` 的 Playbook 自主实现，完成后一次性汇报：
> 交付清单 / 验证结果（analyze+test）/ 待确认决策 / 遗留项。

## 必需材料

| # | 材料 | 给法（任选其一） | 状态 |
|---|---|---|---|
| 1 | 产品规划 | 写入 `docs/product.md`：给谁用、解决什么、模块清单+优先级、MVP 边界（糙稿即可，Agent 整理） | ☐ |
| 2 | 接口文档 | ① Apifox/Postman 分享或导出 ② OpenAPI/Swagger URL 或 JSON ③ 后端仓库路径 → Agent 整理为 `docs/api/<域>.md` | ☐ |
| 3 | Figma | 贴链接（**尽量带 node-id**：Figma 选中页面/Frame 后复制链接）；逐页给出更精准 | ☐ |
| 4 | 技术选型 | 已固化在根 `AGENTS.md` 时**不需要**；新工程或选型有出入才提供 | ☐ |

## 可缺省与降级策略

> 原则：缺材料时 Agent **替你推演草稿（标记[推演]，供确认/替换）**，不是要求你补齐；
> 推演前会在 chat 里声明，你随时可用真实文档覆盖。

| 缺什么 | 降级方案 |
|---|---|
| 无接口文档（后端未就绪） | Agent 推演契约草稿入 `docs/api/`（标记[推演]），mock 驱动开发；后端就绪后走 PLAYBOOK-NEW-API ⑤ 真实 diff 一次 |
| 无 Figma | 走 PLAYBOOK-UI-PAGE 通道 C（设计基线生成：8pt 网格 / 60-30-10 / 四态 / 44pt 热区），后续可替换为 Figma 实现 |
| 无产品规划 | Agent 出 MVP 模块草案 + 实现顺序，**等你确认一次**再开工 |
| 业务规则有歧义 | 列入「待确认」小节，采取保守默认并在汇报中逐条标注 |

## 红线提醒（提供材料时）

- **不要**在材料中包含真实密码/token/API Key——真实值由你本地 `--dart-define` 注入
- 响应示例请用真实抓包（编造示例 = 生成的 model 就是错的）

# Flutter 专用 · 三级 Rules + 工作流 Playbook

通用方法论见上级 [`../GUIDE.md`](../GUIDE.md)。本目录 = **规则模板**（三层，预填 Flutter 经验）
+ **工作流 SOP**（新工程 / 新需求两条主线）。

## 按场景入口

| 你的场景 | 入口 |
|---|---|
| 🆕 新建一个 Flutter 工程 | [`PLAYBOOK-NEW-PROJECT.md`](PLAYBOOK-NEW-PROJECT.md)：选型 → 骨架 → 基础设施 → 规则落地 → 验证（约 60 min） |
| ✨ 新增一个需求 | [`PLAYBOOK-NEW-FEATURE.md`](PLAYBOOK-NEW-FEATURE.md) + [`FEATURE-CARD.md`](FEATURE-CARD.md)：归类 → 需求卡 → 按层补齐 → DoD → 提交 |
| 🔌 对接新接口（文档→代码） | [`PLAYBOOK-NEW-API.md`](PLAYBOOK-NEW-API.md) + [`API-DOC-TEMPLATE.md`](API-DOC-TEMPLATE.md)：文档落位 → 路由登记 → Agent 生成 model/service/test → review |
| 📐 业务逻辑（规则→代码） | [`PLAYBOOK-BIZ-LOGIC.md`](PLAYBOOK-BIZ-LOGIC.md) + [`BIZ-DOC-TEMPLATE.md`](BIZ-DOC-TEMPLATE.md)：规则表/状态机/边界算例 → 分层实现 + 逐条测试 |
| 🎨 设计稿→页面（Figma / UI 文档） | [`PLAYBOOK-UI-PAGE.md`](PLAYBOOK-UI-PAGE.md) + [`UI-DOC-TEMPLATE.md`](UI-DOC-TEMPLATE.md)：Figma MCP 拉 token/资源 → 四态 + 事件表接线 → 还原度走查 |
| 📦 验收交付 | [`DELIVERY-TEMPLATE.md`](DELIVERY-TEMPLATE.md)：实现/检查/建议三段交付报告 → `docs/delivery/` |
| 🏛️ 架构：新项目设计 / 存量反哺 / ADR | [`PLAYBOOK-ARCHITECTURE.md`](PLAYBOOK-ARCHITECTURE.md) + [`ARCH-TEMPLATE.md`](ARCH-TEMPLATE.md) + [`ADR-TEMPLATE.md`](ADR-TEMPLATE.md)：架构先于代码，唯一事实源 |
| 🏢 公司/项目规范覆盖 & 第三方库规范 | [`libs/README.md`](libs/README.md)：默认规范可被项目 `docs/rules/` 整体替换；Bloc/GetX 等库级规范按选型加载 |
| 🧩 已有工程补规则 | 本文下方「规则文件与去向」+「已有工程补规则 · 15 分钟」 |
| 🔍 日常审计与调优 | [`../CHECKLIST.md`](../CHECKLIST.md) + [`../GUIDE.md`](../GUIDE.md) §7 §8 |

## 规则文件与去向

| 文件 | 层级 | 放哪 |
|---|---|---|
| `L1-flutter-global.md` | L1 | 追加到 `~/.claude/CLAUDE.md`（或对应工具的全局文件） |
| `L2-AGENTS-FLUTTER.md` | L2 | 复制到目标仓库根，改名 `AGENTS.md`，填 `<占位符>` |
| `L3-services-network.md` | L3 | `lib/services/AGENTS.md`（或配 globs） |
| `L3-models.md` | L3 | `lib/models/AGENTS.md` |
| `L3-ui-pages-widgets.md` | L3 | `lib/pages/` 与 `lib/widgets/` 共用 |
| `L3-state-management.md` | L3 | `lib/AGENTS.md`（覆盖全部 Dart 代码） |
| `L3-testing.md` | L3 | `test/AGENTS.md` |
| `libs/<库名>.md` | 库级 | 选型确定后按需读取；项目可用 `docs/rules/<库名>.md` 覆盖（见 `libs/README.md`） |

## 已有工程补规则 · 15 分钟

1. 复制 L2 → 仓库根 `AGENTS.md`：删掉用不到的命令/目录行，路由表指向真实 `docs/`，状态管理方案写死
2. 按需取 2–3 个 L3（新项目优先 services + models + ui）
3. 建多工具适配薄层（`CLAUDE.md` 写 `@AGENTS.md` 等，见 `../GUIDE.md` §5）
4. 跑一个小任务实测遵循情况，不遵循按 `../GUIDE.md` §8 调优

## 行数预算

L1 ≤50 · L2 ≤150 · 每个 L3 ≤55；超了就砍，或下沉 `docs/` 后在路由表登记。

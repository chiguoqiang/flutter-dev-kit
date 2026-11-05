# AI Coding 规则工程 · 三级 Rules + 索引式 AGENTS.md

一套**可移植**的 Agent 规则体系，适用于任何语言/框架/团队：
让 Claude Code、Codex、Cursor、GitHub Copilot、Gemini CLI 在同一仓库行为一致、稳定、可维护。

## 文件清单

| 文件 | 用途 |
|---|---|
| `GUIDE.md` | 完整方法论：架构 / 索引设计 / 工具适配 / 落地 SOP / 维护机制 / 调优 / 反模式 / 度量 |
| `CHECKLIST.md` | 初始化清单、季度审计清单、单条规则质量检查、失效排查 |
| `templates/L1-global-rules.md` | L1 个人全局规则模板（放 `~/.claude/` 等） |
| `templates/L2-AGENTS.md` | L2 项目索引式 `AGENTS.md` 模板（放仓库根） |
| `templates/L3-module-rules.md` | L3 模块级规则模板（放子目录或条件规则） |
| `flutter/` | **Flutter 专用全套**：三层规则（L1/L2/L3×5，预填经验）+ 两条工作流 SOP（新工程搭建 / 新需求实现）+ 需求卡模板 |

## 快速开始

1. **新建 Flutter 工程** → `flutter/PLAYBOOK-NEW-PROJECT.md`
2. **Flutter 新增需求** → `flutter/PLAYBOOK-NEW-FEATURE.md`（配 `flutter/FEATURE-CARD.md` 需求卡）
3. **对接新接口** → `flutter/PLAYBOOK-NEW-API.md` + `flutter/API-DOC-TEMPLATE.md`（文档标准：接口名/方式/参数/Header/响应示例）
4. **业务逻辑落地** → `flutter/PLAYBOOK-BIZ-LOGIC.md` + `flutter/BIZ-DOC-TEMPLATE.md`（规则表/状态机/边界算例，一行规则一条测试）
5. **设计稿转页面** → `flutter/PLAYBOOK-UI-PAGE.md` + `flutter/UI-DOC-TEMPLATE.md`（支持 Figma MCP 直连：token 映射 → 四态 + 事件接线）
6. 其他项目 → 复制 `templates/` 三份模板，按 `GUIDE.md` §6 的 30 分钟 SOP 落地
7. 之后每季度过一遍 `CHECKLIST.md` 的 B 部分

## 三条铁律（记住这个就够了）

1. **越近优先**：子目录 > 仓库根 > 全局；L1 永不覆盖 L2/L3
2. **越薄越好**：L1 ≤50 行 / L2 ≤150 行 / L3 ≤50 行，同一条规则只出现在一层
3. **按需加载**：常驻的只有索引，细节路由到 `docs/` 用到再读

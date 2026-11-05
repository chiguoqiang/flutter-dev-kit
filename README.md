# Flutter Dev Kit · AI 规范开发体系（三级 Rules + AGENTS.md）

一套可安装的 AI Coding 规则体系：让 GitHub Copilot（以及 Claude Code / Codex / Cursor）
在任何 Flutter 项目里**按同一套规范自主开发**——新建工程、对接接口、落地业务逻辑、Figma 转页面。

你只需要做两件事：**安装一次**，然后**把产品文档放进来，对 Agent 说"开始开发"**。

---

## 快速开始（任何人，3 步）

```bash
# 1. 下载
git clone https://github.com/<你>/flutter-dev-kit.git && cd flutter-dev-kit

# 2. 安装（注册 Skill 到 ~/.agents/skills + Agent 到 VS Code 用户级 prompts）
./install.sh

# 3. 使用：在任意目录对 Copilot 说——
#    「新建一个 Flutter 工程，按 flutter-dev-playbook 规范」
#    或在已有项目里放入产品文档后说「开始开发」
```

> 需要 VS Code + GitHub Copilot（Agent 模式）。也兼容 Claude Code / Codex / Cursor（见 FAQ）。

## 三种使用方式

| 场景 | 你说 | Agent 做 |
|---|---|---|
| 🆕 从零新建工程 | 「新建 Flutter 工程：xxx，状态管理用 Riverpod…」 | 按选型搭骨架 → 基础设施 → 规则落位（AGENTS.md + L3）→ 验证 → Git |
| 📦 已有项目规范化 | 「按 flutter-dev-playbook 规范化本项目」 | 拷规则库进 `docs/` → 生成根 AGENTS.md + 模块 L3 |
| 📄 拿着文档直接开发 | 放入材料后说「开始开发」 | 见下 |

## 文档驱动开发（第三种，最省心）

把以下材料放进项目 `docs/`（清单见 `ai-coding-rules/INTAKE.md`）：

| 材料 | 放哪 | 缺省降级 |
|---|---|---|
| 产品规划（给谁用/模块/优先级/MVP） | `docs/product.md` | Agent 出 MVP 草案，找你确认一次 |
| 接口文档（Apifox/OpenAPI/后端仓库） | 发给 Agent 即可，整理进 `docs/api/` | 按产品文档推演契约，mock 先行 |
| Figma 链接（选中页面复制，带 node-id） | 发给 Agent | 按 UI 基线（8pt 网格/四态）生成 |

然后切到 **「Flutter 规范开发」Agent**（或在聊天里触发 flutter-dev-playbook），说「开始开发」。
它自主跑完整条管线，最后**一次性汇报**：交付清单 / 验证结果（analyze+test）/ 待确认决策 / 遗留项。

⚠️ 永远不要把真实密钥放进文档或发给 Agent——真实值用 `--dart-define` 本地注入。

## 体系结构

```text
flutter-dev-kit/
├── install.sh                  # 一键安装（把模板里的路径占位符替换为你的 clone 路径）
├── copilot/
│   ├── skill-template/SKILL.md     # Skill 模板（含 __CANONICAL_PATH__ 占位符）
│   └── agent-template/flutter-dev.agent.md  # 自定义 Agent 模板
└── ai-coding-rules/            # ★ 规则唯一源（canonical 库）
    ├── GUIDE.md                # 方法论：三级 Rules + 索引式 AGENTS.md
    ├── CHECKLIST.md            # 初始化/季度审计清单
    ├── INTAKE.md               # 材料交接清单（文档驱动开发入口）
    ├── templates/              # 通用三层规则模板（L1/L2/L3）
    └── flutter/                # Flutter 全套
        ├── L1/L2/L3 规则（全局/项目/网络·模型·UI·状态·测试）
        └── PLAYBOOK×5：新工程 / 新需求 / 新接口 / 业务逻辑 / Figma→页面
```

**分层原理**（详见 `ai-coding-rules/GUIDE.md`）：

| 层 | 形态 | 加载 |
|---|---|---|
| 宪法 | 各仓库 `AGENTS.md`（根 + 模块 L3） | 自动常驻 |
| 流程 | 5 条 Playbook（文档，非代码） | 按需读取 |
| 调度 | Skill `flutter-dev-playbook`（~/.agents/skills） | 关键词触发 / 斜杠 |
| 执行 | Agent「Flutter 规范开发」（VS Code 用户级） | Agent 选择器 |

规则只在 `ai-coding-rules/` 维护一份；Skill/Agent 是薄壳，新项目由 Agent 自动把规则库拷进
项目 `docs/`（项目内优先于 canonical）。

## FAQ

- **团队共享？** 不装个人 Skill，改为把 kit 中 `copilot/skill-template` 改名放进仓库
  `.github/skills/flutter-dev-playbook/SKILL.md`（正文引用 `docs/ai-coding-rules/` 相对路径），
  随仓库推送，同事零配置。
- **Claude Code / Codex / Cursor？** 体系生成的每个项目自带 `CLAUDE.md`(@AGENTS.md) 与
  `.cursor/rules`、`.github/copilot-instructions.md` 适配薄层，见 GUIDE §5。
- **更新版本？** `git pull && ./install.sh`（重装即覆盖，规则库以 canonical 为准同步到项目）。
- **卸载？** 删除 `~/.agents/skills/flutter-dev-playbook/` 与 VSCode prompts 下的
  `flutter-dev.agent.md`。

## License

MIT

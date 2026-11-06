# Flutter Dev Kit · 文档驱动的 AI Coding 全流程体系

> Spec → Code → Delivery：三级规则 × 六大 Playbook × 架构/选型事实源 × CI 门禁 × Skill/Agent 随仓库分发

一套可安装的 AI Coding 工作流体系：让 GitHub Copilot（以及 Claude Code / Codex / Cursor）
把你的**产品文档变成可验收的交付**——规范打底（AGENTS.md + L3）、架构与选型先行
（architecture.md / tech-stack.yaml）、按 Playbook 逐模块实现（model→service→state→UI→test）、
CI 门禁机器验收、交付报告三段式汇报。新建工程、存量规范化、对接接口、业务规则、Figma 转页面全覆盖。

你只需要做两件事：**安装一次**，然后**把产品文档放进来，对 Agent 说"开始开发"**。

---

## 快速开始（任何人，3 步）

> 完整流程图与每步的用户/Agent 分工，见 `skills/flutter-dev-playbook/rules/WORKFLOW.md`。

**方式一 · 一键初始化新工程（最常用）**——空文件夹 → 配齐一切的完整工程：

```bash
mkdir myapp && cd myapp                                  # ① 建个空文件夹
git clone https://github.com/chiguoqiang/flutter-dev-kit.git
./flutter-dev-kit/install.sh "一句话：给谁用、解决什么"    # ② 一键配齐（描述可省略）
# ③ 打开 VS Code → 填 docs/product.md → 对 Copilot 说「开始开发」
```

一条命令完成后你会得到：Flutter 工程（默认选型 Riverpod+dio+go_router+json_serializable+mocktail）
+ 基础设施代码（ApiClient/主题/路由）+ 全部规则（AGENTS.md×6 + Playbook×5）
+ `.github/` 内 Skill/Agent（clone 即共享）+ **`docs/` 文档区（含 product.md 模板）**。
脚本还会自动 `git init` + 首次提交，并**自动删除 flutter-dev-kit/ 目录**——工程自包含，无嵌套仓库冲突。

**方式二 · 注入已有工程（团队共享）**：

```bash
./flutter-dev-kit/install.sh --project /path/to/你的工程   # Skill/Agent→.github/，规则库→docs/
```

**方式三 · 个人级**——本机装一次，所有项目可用：

```bash
cd flutter-dev-kit && ./install.sh          # Skill→~/.agents/skills + Agent→VS Code 用户级
```

> 需要 VS Code + GitHub Copilot（Agent 模式）+ Flutter SDK。也兼容 Claude Code / Codex / Cursor（见 FAQ）。

## 三种使用方式

| 场景 | 你说 | Agent 做 |
|---|---|---|
| 🆕 从零新建工程 | 「新建 Flutter 工程：xxx，状态管理用 Riverpod…」 | 按选型搭骨架 → 基础设施 → 规则落位（AGENTS.md + L3）→ 验证 → Git |
| 📦 已有项目规范化 | 「按 flutter-dev-playbook 规范化本项目」 | 拷规则库进 `docs/` → 生成根 AGENTS.md + 模块 L3 |
| 📄 拿着文档直接开发 | 放入材料后说「开始开发」 | 见下 |

## 装完之后，你可以调整/更新/补充什么（用户可编辑点地图）

工程初始化后，**这些都是留给你的旋钮**——改完在 chat 里说对应黑话即可生效：

| 你想调整什么 | 编辑哪个文件 | 然后说什么 | 生效范围 |
|---|---|---|---|
| **技术选型/版本**（换 bloc/getx、锁版本） | `docs/tech-stack.yaml` | 「按 tech-stack 调整」 | pubspec + AGENTS 技术栈行 + 加载对应库规范 + 迁移代码 |
| **公司/项目规范**（编码/架构/UI 约定） | `docs/rules/*.md`（同名覆盖默认层） | 无需指令，Agent 自动优先执行 | 同名层整体以你的为准（如 `state-management.md`、`architecture.md`） |
| **产品方向**（模块/优先级/MVP 边界） | `docs/product.md` | 「按最新 product 继续」 | 后续模块拆解与排期 |
| **接口契约** | `docs/api/<域>.md`（真实抓包替换[推演]稿） | 「按最新 API 文档调整」 | model/service/test 重生成 |
| **业务规则**（状态机/公式） | `docs/biz/<域>.md` | 「按最新 biz 调整」 | 规则实现+逐条测试同步 |
| **UI 规格/Figma** | `docs/ui/<页>.md` 或直接贴 Figma 链接 | 「按最新 UI 文档调整」 | 页面四态/事件接线 |
| **架构**（分层/依赖/加层） | `docs/architecture/architecture.md` + `adr/NNNN-*.md` | 提出变更，Agent 先出 ADR | 全项目结构与依赖规则 |
| **红线/命令/命名** | 根 `AGENTS.md`（宪法） | 无需指令，常驻生效 | Agent 全部行为 |
| **模块级细则** | `lib/services/AGENTS.md` 等 L3 文件 | 无需指令，就近生效 | 对应目录 |
| **CI 门禁** | `.github/workflows/ci.yml` | —（推送自动跑） | analyze/format/test 强制 |
| **缺文档时的推演稿** | 任何标 `[推演]` 的文档可直接改 | — | 下次实现即按改后版本 |

> 原则：**事实源文件 > 口头描述**。想长期生效的调整都落到上面这些文件；
> 一次性的口头要求适合小修，Agent 做完会建议是否回写文档。

## 文档驱动开发（第三种，最省心）

把以下材料放进项目 `docs/`（清单见 `docs/INTAKE.md`，init 时自动生成）：

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
├── install.sh                          # 一键安装（无参=初始化工程 / --project / --personal）
├── skills/flutter-dev-playbook/        # ★ Skill 与规则库一体分发
│   ├── SKILL.md                        #   调度入口（场景分派）
│   └── rules/                          #   规则唯一源
│       ├── WORKFLOW.md                 #   ★ AI Coding 完整流程总纲（新建项目/新增业务）
│       ├── GUIDE.md                    #   方法论：三级 Rules + 索引式 AGENTS.md
│       ├── CHECKLIST.md                #   初始化/季度审计清单
│       ├── INTAKE.md                   #   材料交接清单（文档驱动开发入口）
│       ├── templates/                  #   通用三层规则模板（L1/L2/L3）
│       └── flutter/                    #   Flutter 全套（L1/L2/L3 + PLAYBOOK×5）
├── agents/flutter-dev.agent.md         # 自定义 Agent（引用 Skill 内 rules/）
└── preset/                             # 工程预设（AGENTS.md×6 占位符版 + 基础设施代码 + CI 门禁）
```

注入工程后的形态（全部随仓库 Git 分发，同事 clone 零配置）：

```text
你的工程/
├── .github/
│   ├── skills/flutter-dev-playbook/{SKILL.md, rules/}   ← 一体拷贝
│   ├── agents/flutter-dev.agent.md
│   └── copilot-instructions.md
└── docs/                                ← 产品文档区（product.md 模板 + INTAKE + api/biz/ui）
```

**分层原理**（详见 `skills/flutter-dev-playbook/rules/GUIDE.md`）：

| 层 | 形态 | 加载 |
|---|---|---|
| 宪法 | 各仓库 `AGENTS.md`（根 + 模块 L3） | 自动常驻 |
| 流程 | 5 条 Playbook（Skill 内 rules/） | 按需读取 |
| 调度 | Skill `flutter-dev-playbook`（.github/skills 或 ~/.agents/skills） | 关键词触发 / 斜杠 |
| 执行 | Agent「Flutter 规范开发」 | Agent 选择器 |

规则只在 `skills/flutter-dev-playbook/rules/` 维护一份，随 Skill 整体分发到工程或个人目录。

## FAQ

- **团队共享？** 默认就是：`install.sh`（无参）或 `--project` 把 Skill+规则库整体放进工程
  `.github/skills/flutter-dev-playbook/`，随仓库推送，同事 clone 零配置。
- **Claude Code / Codex / Cursor？** 体系生成的每个项目自带 `CLAUDE.md`(@AGENTS.md) 与
  `.cursor/rules`、`.github/copilot-instructions.md` 适配薄层，见 GUIDE §5。
- **CI 门禁？** init 生成的工程自带 `.github/workflows/ci.yml`（analyze + format 检查 + test），
  推送 GitHub 后自动生效；建议 Settings → Branches 设为 required check。未推送的本地项目无 CI，
  靠本地 DoD 兑底。
- **更新版本？** 上游 `git pull` 后对老工程重跑 `--project`（或删除工程内 skill 目录后重跑）。
- **卸载？** 删除 `~/.agents/skills/flutter-dev-playbook/` 与 VSCode prompts 下的
  `flutter-dev.agent.md`。

## License

MIT

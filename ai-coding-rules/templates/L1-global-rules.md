# 个人全局规则（L1）· 模板

<!-- 放置位置（按所用工具，任选其一）：
  Claude Code : ~/.claude/CLAUDE.md
  Codex       : ~/.codex/AGENTS.md
  Gemini CLI  : ~/.gemini/GEMINI.md
  GitHub Copilot : 用户级 instructions
-->
<!-- 预算：全文件 ≤50 行。判断标准：换 10 个项目这条依然成立，才留在这里。 -->

## 语言与沟通

- 默认用中文回复；代码、标识符、commit message 用英文
- 回答简洁：直接给结论和改动，少铺垫
- 需求不明确时，先列出你的理解让我确认，不要猜

## 通用工程习惯

- 改动最小化：只做被要求的事，不顺手重构、不擅自升级依赖
- 动手前先读当前仓库根目录的 `AGENTS.md`，遵循其中的命令与红线
- 提交前运行该仓库声明的测试与 lint 命令，失败先修复
- 不确定用哪个 API/写法时，先查工作区内已有代码的惯例，保持一致

## Git

- Conventional Commits：`feat:` / `fix:` / `docs:` / `refactor:` / `test:` / `chore:`
- 一次提交只做一件事

## 安全红线（所有项目生效）

- 永不 force push、永不改写 main 历史
- 不主动修改 CI/CD 配置，除非明确要求
- 不把密钥/密码/token 写进代码、配置或日志
- 删除文件、重置分支等破坏性操作，先说明影响并等确认

#!/usr/bin/env bash
# flutter-dev-kit 安装器（两种模式）
#   项目级（推荐·随仓库共享）: ./install.sh --project <工程路径>
#   个人级（本机一次·全项目可用）: ./install.sh [--skill|--agent]
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$KIT_ROOT/copilot/skill-template/SKILL.md"
AGENT_SRC="$KIT_ROOT/copilot/agent-template/flutter-dev.agent.md"
PROJ_SKILL_SRC="$KIT_ROOT/copilot/project-skill-template/SKILL.md"
PROJ_AGENT_SRC="$KIT_ROOT/copilot/project-agent-template/flutter-dev.agent.md"
SKILL_DST_DIR="$HOME/.agents/skills/flutter-dev-playbook"

detect_prompts_dir() {
  case "${OSTYPE:-}" in
    darwin*) echo "$HOME/Library/Application Support/Code/User/prompts" ;;
    *)       echo "$HOME/.config/Code/User/prompts" ;;
  esac
}

install_skill() {
  mkdir -p "$SKILL_DST_DIR"
  sed "s|__CANONICAL_PATH__|$KIT_ROOT|g" "$SKILL_SRC" > "$SKILL_DST_DIR/SKILL.md"
  echo "✅ Skill 已安装: $SKILL_DST_DIR/SKILL.md"
  echo "   canonical 规则库已指向: $KIT_ROOT/ai-coding-rules"
}

install_agent() {
  local dir; dir="$(detect_prompts_dir)"
  mkdir -p "$dir"
  sed "s|__CANONICAL_PATH__|$KIT_ROOT|g" "$AGENT_SRC" > "$dir/flutter-dev.agent.md"
  echo "✅ Agent 已安装: $dir/flutter-dev.agent.md（VS Code Agent 选择器：Flutter 规范开发）"
}

# ---------- 项目级（团队共享：Skill/Agent + 规则库全部进工程，随 Git 分发） ----------

install_project() {
  local proj="$1"
  if [ ! -d "$proj" ]; then echo "❌ 目录不存在: $proj"; exit 1; fi

  # 1) 规则库与材料清单（已存在则不覆盖）
  if [ ! -d "$proj/docs/ai-coding-rules" ]; then
    mkdir -p "$proj/docs"
    cp -R "$KIT_ROOT/ai-coding-rules" "$proj/docs/"
    echo "✅ 规则库: $proj/docs/ai-coding-rules"
  else
    echo "⏭️  docs/ai-coding-rules 已存在，未覆盖（升级请删后重跑）"
  fi
  [ -f "$proj/docs/INTAKE.md" ] || cp "$KIT_ROOT/ai-coding-rules/INTAKE.md" "$proj/docs/INTAKE.md"

  # 2) 工作区级 Skill + Agent（引用仓库内相对路径，同事 clone 即生效，零安装）
  mkdir -p "$proj/.github/skills/flutter-dev-playbook" "$proj/.github/agents"
  cp "$PROJ_SKILL_SRC" "$proj/.github/skills/flutter-dev-playbook/SKILL.md"
  cp "$PROJ_AGENT_SRC" "$proj/.github/agents/flutter-dev.agent.md"
  echo "✅ 项目级 Skill: $proj/.github/skills/flutter-dev-playbook/SKILL.md"
  echo "✅ 项目级 Agent: $proj/.github/agents/flutter-dev.agent.md"
  echo
  echo "📌 全部落在工程内：git add . && git commit 后随仓库分发，同事 clone 即自动生效（工作区级优先于个人级）。"
  echo "📌 之后在工程里放产品文档（见 docs/INTAKE.md），对 Copilot 说「开始开发」即可。"
}

case "${1:-all}" in
  --skill) install_skill ;;
  --agent) install_agent ;;
  --project)
    [ $# -ge 2 ] || { echo "用法: ./install.sh --project <工程路径>"; exit 1; }
    install_project "$2" ;;
  all)
    install_skill; install_agent
    echo
    echo "提示：团队共享请改用  ./install.sh --project <工程路径>（Skill/Agent 进工程 .github/，随仓库分发）"
    echo
    echo "下一步："
    echo "  1) 重启 VS Code（或 Reload Window）使 Skill/Agent 生效"
    echo "  2) 新建工程：对 Copilot 说「新建一个 Flutter 工程，按 flutter-dev-playbook 规范」"
    echo "  3) 文档开发：把产品文档按 ai-coding-rules/INTAKE.md 放入项目 docs/，切到「Flutter 规范开发」Agent 说「开始开发」" ;;
  *) echo "用法: ./install.sh [--skill | --agent | --project <工程路径>]"; exit 1 ;;
esac

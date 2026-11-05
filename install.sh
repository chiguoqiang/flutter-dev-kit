#!/usr/bin/env bash
# flutter-dev-kit 一键安装：注册个人 Skill + 用户级 Agent（路径无关，自动写入本 clone 位置）
# 用法: ./install.sh [--skill|--agent]   默认两个都装
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$KIT_ROOT/copilot/skill-template/SKILL.md"
AGENT_SRC="$KIT_ROOT/copilot/agent-template/flutter-dev.agent.md"
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

case "${1:-all}" in
  --skill) install_skill ;;
  --agent) install_agent ;;
  all)     install_skill; install_agent ;;
  *) echo "用法: ./install.sh [--skill|--agent]"; exit 1 ;;
esac

echo
echo "下一步："
echo "  1) 重启 VS Code（或 Reload Window）使 Skill/Agent 生效"
echo "  2) 新建工程：对 Copilot 说「新建一个 Flutter 工程，按 flutter-dev-playbook 规范」"
echo "  3) 文档开发：把产品文档按 ai-coding-rules/INTAKE.md 放入项目 docs/，切到「Flutter 规范开发」Agent 说「开始开发」"

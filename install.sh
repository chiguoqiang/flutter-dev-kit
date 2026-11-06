#!/usr/bin/env bash
# flutter-dev-kit 安装器
#   初始化新工程（最常用·无参数）: cd 空目录后 ./flutter-dev-kit/install.sh ["一句话描述"]
#   注入已有工程（团队共享）    : ./install.sh --project <工程路径>
#   个人级（本机一次）        : ./install.sh --personal [--skill|--agent 可单选]
#
# 核心设计：Skill 与规则库一体分发——
#   kit 内 skills/flutter-dev-playbook/{SKILL.md, rules/} 整体拷贝到：
#     项目级 .github/skills/flutter-dev-playbook/（随仓库 Git 分发）
#     个人级 ~/.agents/skills/flutter-dev-playbook/
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR_SRC="$KIT_ROOT/skills/flutter-dev-playbook"
AGENT_SRC="$KIT_ROOT/agents/flutter-dev.agent.md"
PRESET="$KIT_ROOT/preset"
SKILL_DST_DIR="$HOME/.agents/skills/flutter-dev-playbook"

detect_prompts_dir() {
  case "${OSTYPE:-}" in
    darwin*) echo "$HOME/Library/Application Support/Code/User/prompts" ;;
    *)       echo "$HOME/.config/Code/User/prompts" ;;
  esac
}

# ---------- 个人级（本机一次，全项目可用） ----------

install_skill() {
  rm -rf "$SKILL_DST_DIR"
  cp -R "$SKILL_DIR_SRC" "$SKILL_DST_DIR"
  echo "✅ Skill 已安装: ${SKILL_DST_DIR}（SKILL.md + rules/ 规则库一体）"
}

install_agent() {
  local dir; dir="$(detect_prompts_dir)"
  mkdir -p "$dir"
  cp "$AGENT_SRC" "$dir/flutter-dev.agent.md"
  echo "✅ Agent 已安装: $dir/flutter-dev.agent.md（VS Code Agent 选择器：Flutter 规范开发）"
}

# ---------- 项目级注入：Skill(含规则库) + Agent 写入已有工程 ----------

inject_project() {
  local proj="$1"
  if [ ! -d "$proj" ]; then echo "❌ 目录不存在: $proj"; exit 1; fi

  if [ -d "$proj/.github/skills/flutter-dev-playbook" ]; then
    echo "⏭️  .github/skills/flutter-dev-playbook 已存在，未覆盖（升级请先删除该目录再重跑）"
  else
    mkdir -p "$proj/.github/skills"
    cp -R "$SKILL_DIR_SRC" "$proj/.github/skills/flutter-dev-playbook"
    echo "✅ Skill+规则库: $proj/.github/skills/flutter-dev-playbook/（SKILL.md + rules/）"
  fi
  mkdir -p "$proj/.github/agents"
  cp "$AGENT_SRC" "$proj/.github/agents/flutter-dev.agent.md"
  echo "✅ Agent: $proj/.github/agents/flutter-dev.agent.md"
  if [ ! -f "$proj/docs/INTAKE.md" ]; then
    mkdir -p "$proj/docs"
    cp "$SKILL_DIR_SRC/rules/INTAKE.md" "$proj/docs/INTAKE.md"
  fi

  echo
  echo "📌 全部落在工程内：git commit 后随仓库分发，同事 clone 即自动生效（无需安装）。"
  echo "📌 产品文档放 docs/（见 docs/INTAKE.md），对 Copilot 说「开始开发」即可。"
}

# ---------- 初始化新工程：当前空目录一键配齐 ----------

init_project() {
  local dir="$PWD" raw title desc name
  raw="$(basename "$dir")"
  name="$(echo "$raw" | tr '-' '_')"
  title="${1:-$raw}"
  desc="${2:-一句话定位：给谁用、解决什么（可编辑根 AGENTS.md 修改）}"

  command -v flutter >/dev/null || { echo "❌ 未找到 flutter，请先安装 Flutter SDK"; exit 1; }
  if [ -f "$dir/pubspec.yaml" ]; then echo "❌ 当前目录已有 Flutter 工程（pubspec.yaml 存在），新建工程请换空目录"; exit 1; fi
  echo "$name" | grep -Eq '^[a-z_][a-z0-9_]*$' || { echo "❌ 目录名 \"$raw\" 不能作为 Dart 包名（需小写字母/数字/下划线），请重命名目录"; exit 1; }

  echo "▶ 1/6 flutter create（org=com.example，可稍后改）…"
  flutter create --org com.example --project-name "$name" --platforms android,ios . >/dev/null

  echo "▶ 2/6 安装默认选型依赖（Riverpod + dio + go_router + json_serializable + mocktail）…"
  flutter pub add dio go_router flutter_riverpod json_annotation >/dev/null 2>&1 \
    && flutter pub add --dev json_serializable build_runner mocktail >/dev/null 2>&1 \
    || echo "   ⚠️ 依赖安装失败（网络?），请稍后手动: flutter pub add dio go_router flutter_riverpod json_annotation"

  echo "▶ 3/6 目录骨架 + 文档区…"
  mkdir -p lib/theme lib/models lib/services lib/pages lib/widgets \
           test/models test/services test/pages docs/api docs/biz docs/ui docs/features
  cp "$SKILL_DIR_SRC/rules/INTAKE.md" docs/INTAKE.md
  cat > docs/product.md <<'EOF'
# 产品规划（把你的产品信息填到这里，然后对 Copilot 说「开始开发」）

## 给谁用
<目标用户>

## 解决什么问题
<一句话>

## 模块清单（按优先级）
1. <模块A：例如客户搜索> — MVP
2. <模块B> — MVP
3. <模块C> — 后续

## MVP 边界
<第一期做什么、不做什么>
EOF

  echo "▶ 4/6 Skill+规则库+Agent+基础设施代码…"
  mkdir -p .github/skills .github/agents
  cp -R "$SKILL_DIR_SRC" .github/skills/flutter-dev-playbook
  cp "$AGENT_SRC" .github/agents/flutter-dev.agent.md
  cp "$PRESET/.github/copilot-instructions.md" .github/copilot-instructions.md
  mkdir -p .github/workflows
  cp "$PRESET/.github/workflows/ci.yml" .github/workflows/ci.yml
  sed -e "s|__APP_TITLE__|$title|g" -e "s|__APP_DESC__|$desc|g" "$PRESET/AGENTS.md" > AGENTS.md
  cp "$PRESET/CLAUDE.md" CLAUDE.md
  mkdir -p .cursor/rules && cp "$PRESET/.cursor/rules/00-agents.mdc" .cursor/rules/00-agents.mdc
  sed "s|__APP_TITLE__|$title|g" "$PRESET/lib/main.dart" > lib/main.dart
  cp "$PRESET/lib/AGENTS.md" "$PRESET/lib/config.dart" "$PRESET/lib/router.dart" lib/
  cp "$PRESET/lib/theme/app_theme.dart" lib/theme/
  cp "$PRESET/lib/services/AGENTS.md" "$PRESET/lib/services/api_client.dart" lib/services/
  cp "$PRESET/lib/models/AGENTS.md" lib/models/
  cp "$PRESET/lib/pages/AGENTS.md" "$PRESET/lib/pages/home_page.dart" lib/pages/
  cp "$PRESET/test/AGENTS.md" test/AGENTS.md
  sed "s|__APP_NAME__|$name|g" "$PRESET/test/widget_test.dart" > test/widget_test.dart
  dart format lib test >/dev/null 2>&1 || true   # 规范化 + 保障 CI format 检查首绿

  echo "▶ 5/6 清理脚手架…"
  local kit_gone=0
  case "$KIT_ROOT" in
    "$dir"/*) rm -rf "$KIT_ROOT" && kit_gone=1 ;;
  esac
  if [ "$kit_gone" = 1 ]; then
    echo "   🧹 已自动删除 flutter-dev-kit/（工程自包含，无嵌套仓库）"
  else
    echo "   ℹ️  kit 位于工程外，未删除"
  fi

  echo "▶ 6/6 验证 + Git 初始化…"
  flutter analyze >/dev/null 2>&1 && echo "   ✅ flutter analyze 零 error" || echo "   ⚠️ analyze 有告警，可稍后处理"
  if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "   ⏭️  已是 git 仓库，跳过 init"
  else
    git init -q
  fi
  git add -A
  if git commit -qm "chore: bootstrap with flutter-dev-kit (rules & infra)" 2>/dev/null; then
    echo "   ✅ 首次提交完成"
  else
    echo "   ⚠️ 提交失败（git user 未配置?）：请 git config user.name/email 后重新 commit"
  fi

  echo
  echo "🎉 工程已配齐：$dir"
  echo "   📁 产品文档 → docs/product.md（模板已生成）；接口/Figma 给法见 docs/INTAKE.md"
  echo "   📚 规则库   → .github/skills/flutter-dev-playbook/rules/（随仓库分发）"
  echo "   ▶ 下一步：把产品信息填进 docs/product.md → 对 Copilot 说「开始开发」"
}

case "${1:-}" in
  "")
    if [ "$PWD" = "$KIT_ROOT" ]; then echo "❌ 请在目标空文件夹里运行（可先 cd 到目标目录），在 kit 目录内请用 --personal"; exit 1; fi
    init_project ;;
  --init)
    shift; init_project "$@" ;;
  --skill) install_skill ;;
  --agent) install_agent ;;
  --personal)
    install_skill; install_agent
    echo
    echo "下一步：重启 VS Code 后，对 Copilot 说「新建一个 Flutter 工程，按 flutter-dev-playbook 规范」" ;;
  --project)
    [ $# -ge 2 ] || { echo "用法: ./install.sh --project <工程路径>"; exit 1; }
    inject_project "$2" ;;
  -*) echo "用法: ./install.sh [\"一句话描述\"] | --project <工程路径> | --personal | --skill | --agent"; exit 1 ;;
  *)
    init_project "$@" ;;
esac

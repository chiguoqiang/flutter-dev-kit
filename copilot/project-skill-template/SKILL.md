---
name: flutter-dev-playbook
description: '按三级 Rules 规范体系开发 Flutter：新建 Flutter 工程、新增需求/业务模块、对接 API 接口、业务逻辑落地、Figma/UI 文档转页面、按 AGENTS.md 规范开发。Use when: 新建flutter项目、搭工程、新需求、对接接口、接API、写业务逻辑、Figma转页面、按规范开发、继续开发。'
argument-hint: '[场景：新工程|新需求|接口|业务|UI] 或直接描述任务'
---

# Flutter 规范开发 Playbook 调度（项目级 · 随仓库分发）

三级 Rules + 索引式 AGENTS.md 体系的流程入口（flutter-dev-kit 项目模式）。

## 规则库定位

- 唯一来源：**本仓库** `docs/ai-coding-rules/`（随本 Skill 一起分发，进 Git）
- 若缺失（仓库被裁剪）：请维护者从上游 flutter-dev-kit 拷入后再开工

## 启动判定（每次先做）

1. 当前仓库根有 `AGENTS.md`？
   - **有** → 它是本项目宪法，先完整读它（命令/目录/路由表/红线）
   - **没有** → 按 `docs/ai-coding-rules/flutter/PLAYBOOK-NEW-PROJECT.md` 补齐（选型先问用户）
2. 有 `docs/INTAKE.md`？→ 核对 product/api/figma 材料是否就位，缺项按降级策略推进

## 场景分派

| 用户意图 | 执行文件（docs/ai-coding-rules/flutter/） |
|---|---|
| 新建 Flutter 工程 / 搭项目 | `PLAYBOOK-NEW-PROJECT.md`（选型→骨架→基础设施→规则落地→验证→Git） |
| 新需求 / 新模块（未指明类型） | `PLAYBOOK-NEW-FEATURE.md` 先归类 A~E，再进对应详细流程 |
| 对接接口 / 提供 API 文档 | `PLAYBOOK-NEW-API.md` + `API-DOC-TEMPLATE.md`（文档→model+service+test） |
| 业务规则 / 计算逻辑 / 状态流转 | `PLAYBOOK-BIZ-LOGIC.md` + `BIZ-DOC-TEMPLATE.md`（规则表→逐条测试） |
| Figma 链接 / UI 稿 / 新页面 | `PLAYBOOK-UI-PAGE.md` + `UI-DOC-TEMPLATE.md`（token 映射→四态→事件接线） |

## 硬纪律（所有场景通用）

- 红线以当前仓库 `AGENTS.md` 为准（生成文件禁改、原生工程只读、禁擅自加依赖、禁真实密钥、禁 `!` 强解）
- 业务歧义不猜：记「待确认」，保守默认推进，汇报时逐条标注
- 每场景 DoD：`flutter analyze` 零 error + `flutter test` 全绿 + format + 红线自查
- 完成后一次性汇报：交付清单 / 验证结果 / 待确认决策 / 遗留项

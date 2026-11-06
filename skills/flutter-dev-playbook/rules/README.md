# 规则库索引（Flutter 专用）

> 本文件只做索引，不重复导航——场景入口看 [`flutter/README.md`](flutter/README.md)，
> 全流程图看 [`WORKFLOW.md`](WORKFLOW.md)，安装与可调旋钮看 kit 根 `README.md`。

## 一页地图

| 你要找 | 去 |
|---|---|
| AI Coding 全流程（两条主线+流程图） | `WORKFLOW.md` |
| 按场景选 Playbook（新工程/需求/接口/业务/UI/架构） | `flutter/README.md` |
| 方法论（三级 Rules/索引式 AGENTS/多工具适配/调优/反模式） | `GUIDE.md` |
| 初始化与季度审计清单 | `CHECKLIST.md` |
| 材料交接（product/api/figma 放哪、缺省降级） | `INTAKE.md` |
| 三层规则本体（L1 全局/L2 项目/L3×5 模块 + libs 库级） | `flutter/L*.md`、`flutter/libs/` |
| 输入/输出模板（API/BIZ/UI/ARCH/ADR/DELIVERY/需求卡） | `flutter/*-TEMPLATE.md` |
| 基础设施封装（网络/路由/存储/日志/主题） | `flutter/INFRA-STANDARD.md` |

## 三条铁律（记住这个就够了）

1. **越近优先**：项目 `docs/rules/` > `libs/` > 默认 L*；子目录 > 仓库根 > 全局
2. **越薄越好**：L1 ≤50 行 / L2 ≤150 行 / L3 ≤50 行，同一条规则只出现在一层
3. **按需加载**：常驻的只有索引，细节路由到文档用到再读

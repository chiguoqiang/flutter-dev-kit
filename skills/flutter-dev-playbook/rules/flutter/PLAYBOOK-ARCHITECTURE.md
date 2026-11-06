# Playbook F · 架构：设计（新项目）与反哺（存量项目）SOP

> 触发场景：① 新项目进入模块开发**之前**（架构先于代码）；② 存量项目首次接入本体系时
> （把隐性架构显性化）；③ 日常开发中发生"架构级变更"时（走 ADR）。
> 产出物：`docs/architecture/architecture.md`（唯一事实源）+ `adr/NNNN-*.md`（决策记录）。
> 模板：`ARCH-TEMPLATE.md` / `ADR-TEMPLATE.md`。

---

## 通道 A · 绿地：新项目架构设计（[Agent] 起草 → [你] 确认）

1. **输入**：product.md 模块清单 + 技术选型（L2 头部）+ `docs/rules/`（若公司有架构规范）
2. **Agent 起草** `docs/architecture/architecture.md`：
   - 默认从 kit 预设架构出发（四层单向依赖：UI→状态→服务→模型，见模板 §2-3）
   - 按模块清单填 §4 模块划分与依赖；为关键选型各写一份 ADR（0001 起：状态方案/序列化/路由）
   - 超出默认分层（加 domain/repository/多 package）必须 ADR 说明，禁止默默加层
3. **[你] 确认一次**：看分层图 + 模块依赖表 + ADR 决策——这是架构的"需求卡验收"
4. 确认后才进入模块开发循环（WORKFLOW A-6）；`architecture.md` 登记进 L2 路由表

## 通道 B · 棕地：存量项目架构反哺（[Agent] 读码 → 草稿 → [你] 校对）

适用于 `--project` 注入的已有工程 / 任何"没有架构文档"的维护项目：

1. **Agent 扫描**：入口与路由表 → import 关系图（可 `dart run dependency_validator` 或
   grep import 人工归纳）→ 分层归属 → 三方依赖 → 找出**违规点与灰色地带**
2. **生成草稿**（如实记录现状，不美化）：`docs/architecture/architecture.md`
   - §8「已知技术债」如实列出发现的违规（UI 直连网络、循环依赖、上帝类…）
3. **[你] 校对**：确认"这就是现状"；对违规项逐条决策：修复（生成需求卡）/ 接受（记入
   技术债）/ 排期
4. 之后每次触碰架构边界，先更新本文档再改码（§7 ADR 触发清单）

## 默认架构原则（kit 立场，项目可用 docs/rules/architecture.md 覆盖）

0. **默认架构模式 = MVVM**（换 MVC/Clean/MVI 需 ADR + `docs/rules/architecture.md` 覆盖）：

| MVVM | 本项目落位 | 规范 |
|---|---|---|
| View | `lib/pages`（*_page.dart）+ `lib/widgets` | 只做布局/四态/事件接线，禁业务规则 |
| ViewModel | `*_providers.dart`（Riverpod）/ `*_view_model.dart` | 持状态+编排动作；禁 BuildContext/禁直连网络 |
| Model | `lib/models`（数据+纯规则）+ `lib/services`（数据访问） | 模型层纯 Dart |

  绑定方式 = Riverpod（`ref.watch` 单向数据流）；基础封装遵循 `INFRA-STANDARD.md`

1. **四层单向依赖**：UI → 状态 → 服务 → 模型；反向/跨层 import 违规
2. **模型层纯 Dart**：不 import Flutter/dio/任何 IO——保证可测性与可移植
3. **单一事实源**：网络出口=ApiClient，路由=router.dart，主题=theme/，架构=architecture.md
4. **模块高内聚低耦合**：跨模块只走公开 API（service/provider），禁止伸进私有文件
5. **加层需 ADR**：默认分层是下限；任何新层（domain/repository/multi-package）必须有决策记录
6. **架构文档与代码同步**：先改文档（+ADR）再改代码；文档过期 = 事故隐患

## 执行（怎么保证不只是纸）

| 机制 | 作用 |
|---|---|
| review 清单 | 交付报告「检查」段增加：本次变更是否触碰架构边界；触碰则 ADR 已附 |
| Agent 硬纪律 | 改分层/依赖方向前必须读 architecture.md 并出 ADR，否则拒绝动手 |
| CI/analyze | 部分依赖规则可沉淀为 `analysis_options.yaml` 自定义 lint（长期演进项） |
| 季度审计 | CHECKLIST B 部分增加：architecture.md 与实际代码是否一致（抽 3 个模块对 import） |

## 与其他 Playbook 的关系

- `PLAYBOOK-NEW-PROJECT.md` 阶段 3 之后**插入本 Playbook 通道 A**（架构先于业务代码）
- `PLAYBOOK-NEW-FEATURE.md` 类型判定新增 **F 架构级变更**：新层/换方案/跨模块重构 → 先 ADR
- 交付报告（DELIVERY-TEMPLATE §1.3 关键设计决策）引用本次相关 ADR 编号

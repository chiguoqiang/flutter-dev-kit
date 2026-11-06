# 库级规范 & 公司/项目规范覆盖机制

> 解决两类差异化需求：①不同团队用不同库（Bloc/GetX/Provider/Riverpod…）用法各异；
> ②公司有自己的编码规范，希望**整体替换** kit 默认规范。
> 原则与三级 Rules 一致：**越近的越优先**。

## 规范加载优先级（高 → 低）

```text
① 项目 docs/rules/*.md        ← 公司/项目自定义规范（用户上传/编写，最高优先）
② skill rules/flutter/libs/<库名>.md   ← kit 内置库级规范（按选型加载）
③ skill rules/flutter/L*.md    ← kit 默认三级规范（对标 Effective Dart + flutter_lints
                                  + 国内大厂公开实践，见下"默认规范来源"）
```

同名即覆盖：项目放了 `docs/rules/state-management.md`，则 kit 的 `L3-state-management.md`
中状态管理相关条目以项目文件为准（其余条目仍生效）。**Agent 启动时检查项目
`docs/rules/` 是否存在，存在则优先读并在汇报中声明"已按项目规范执行"。**

## 如何替换/补充（面向使用者）

| 你想做什么 | 操作 |
|---|---|
| 用公司规范替换某层默认 | 把公司规范改写为指令式条目，放 `docs/rules/<同名>.md`（如 `state-management.md`、`naming.md`） |
| 只补充几条特有约定 | 直接写进项目根 `AGENTS.md` 约定区或模块 L3（就近原则） |
| 某个库 kit 没收录 | 写 `docs/rules/<库名>.md`（建议参照 libs 内置文件的指令式格式） |
| 向 kit 反哺成为默认 | 提 PR 到 `skills/flutter-dev-playbook/rules/flutter/libs/` |

## kit 内置库级规范（随选型加载）

| 文件 | 适用选型 | 风格基调 |
|---|---|---|
| `bloc.md` | 状态管理选 Bloc | 强约束：事件命名/状态不可变/细粒度订阅 |
| `getx.md` | 状态管理选 GetX | 约束式：限定 GetX 的使用边界，抑制"魔法滥用" |

> 未收录的库（Provider/Riverpod/MobX/riverpod_generator 等）按上述"项目自定义"处理；
> Riverpod 已内建在 `L3-state-management.md` 的默认方案段。

## 默认规范来源（本地化说明）

kit 的 L1/L2/L3 默认规范综合：**Effective Dart 官方风格** + **flutter_lints（官方 lint 集）**
+ 国内大厂公开实践（字节/闲鱼/腾讯等 Flutter 团队博客与开源项目的通行约定：
如 const 优先、ListView.builder、mounted 检查、主题集中管理、日志脱敏、
`package:` 绝对导入、snake_case 文件名等）。若与你司规范冲突，用上面的覆盖机制替换。

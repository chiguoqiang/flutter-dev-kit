# Playbook B · 新增需求实现 SOP

> 任何新需求：**归类 → 建需求卡 → 按层补齐 → DoD → 提交**。
> 核心思想：一个需求 = 沿 `model → service → state → UI → test` 的垂直切片，
> 每层按对应 L3 规则补齐内容；顺序固定（自底向上），不跳步。

---

## 第 1 步 · 需求归类（1 min）

| 类型 | 例子 | 通常触碰的层 |
|---|---|---|
| **A 新页面/新功能** | 「加一个错题本页面」 | pages + widgets +（models + services 如需）+ test ——UI 部分见 `PLAYBOOK-UI-PAGE.md` |
| **B 对接新接口** | 「接判分 API」 | models + services + test ——**详细流程见 `PLAYBOOK-NEW-API.md`** |
| **C 数据模型变更** | 「题目加解析字段」 | models + 所有引用处 + test |
| **D 纯 UI 调整** | 「按钮换色、改间距」 | widgets / pages |
| **E 业务规则/逻辑** | 「不及格自动进错题本」 | models/services + test ——**详细流程见 `PLAYBOOK-BIZ-LOGIC.md`** |
| **F 架构级变更** | 「加一层 repository」「换状态方案」 | 先 ADR + 更新 architecture.md ——**见 `PLAYBOOK-ARCHITECTURE.md`** |

## 第 2 步 · 建需求卡（2 min）

复制 `FEATURE-CARD.md` → `docs/features/<YYYYMMDD>-<slug>.md`，勾选要补齐的层。

> 与 Agent 协作时，**把需求卡作为任务描述发给它**——它就拿到了完整上下文
> （要动哪些层、每层守什么规则、DoD 是什么）。

## 第 3 步 · 按层补齐（实现顺序固定）

### ⓪ 开工前对表（每次）
重读 `docs/tech-stack.yaml` 最新内容：选型/版本以**此刻文件**为准（用户可能刚改）；
与 pubspec 不一致先声明差异再同步，禁止按旧选型惯性实现；架构模式变更需先 ADR。

### ① models（若有）
- 新增/修改 model：`final` 字段 + `fromJson`/`toJson` + `==`/`hashCode` + `copyWith`
- 用了 json_serializable/freezed → 跑 `dart run build_runner build --delete-conflicting-outputs`
- 补 round-trip 测试
- 📕 规则：`L3-models.md`

### ② services（若有）
- 接口类改动：先按 `API-DOC-TEMPLATE.md` 把契约落到 `docs/api/`，再走 `PLAYBOOK-NEW-API.md` 的生成流程
- 新增 api / store 方法：走唯一客户端、带超时、错误收敛为 `ApiException`
- 补 1 成功 + 1 失败路径测试（mock 网络）
- 📕 规则：`L3-services-network.md`

### ③ state（若有）
- 按项目所选方案（L2 已写死）实现；状态不可变、重建范围最小化
- 📕 规则：`L3-state-management.md`

### ④ UI
- 新页面 `lib/pages/<name>_page.dart`；可复用部分下沉 `lib/widgets/`
- 超过 ~80 行或 4 层嵌套 → 拆 Widget；取色走 `Theme.of(context)`
- 接入路由；入口（按钮/菜单）补齐
- 📕 规则：`L3-ui-pages-widgets.md`

### ⑤ test
- 路径镜像 `lib/`；公开方法必须有测试；修 bug 先写复现用例
- 📕 规则：`L3-testing.md`

### ⑥ 规则回写（经常被忘，但最重要）
- 需求引入新专题文档 → 在 L2 路由表登记
- 过程中踩了新坑 / Agent 摔倒第 2 次 → 把教训写进**最近的层**（Rules-as-Code 闭环）

## 第 4 步 · DoD（全部满足才算完成）

- [ ] `flutter analyze` 零 error（warning 清零）
- [ ] `flutter test` 全绿，新逻辑有对应测试
- [ ] `dart format lib test` 已跑
- [ ] 红线自查：未手改生成文件 / 无真实密钥 / 无 `!` 强解 / 无硬编码颜色
- [ ] 手动冒烟：新功能主流程走通
- [ ] 需求卡全部勾完

## 第 5 步 · 提交

- Conventional Commits：`feat: <一句话>`；一次提交只做一件事
- 类型 B/C 的改动若影响接口契约 → 同步更新 `docs/` 对应协议文档

---

## 附 · 示例：需求「错题本页面」的需求卡（填好的样子）

```markdown
# 需求卡 · 错题本
## 背景：练习结束后自动收录错题，学生可集中重练
## 验收标准
- [ ] 答错的题进入错题本；可按日期查看
- [ ] 错题重做答对后从列表移除
## 层触碰清单
- [x] models：复用 Question/Record，新增 WrongQuestionEntry（题目id+错误答案+时间）
- [x] services：record_store 增加 loadWrong/removeWrong；判分回调处写入
- [x] state：wrong_questions_page 内 setState（列表联动字段≤3，符合 L3）
- [x] UI：lib/pages/wrong_questions_page.dart；入口=历史页顶部按钮
- [x] test：store 读写用例 ×2；页面渲染用例 ×1
- [ ] AGENTS.md：无新专题文档，路由表不变
```

按 ①model → ②service → ④UI → ⑤test 实现（本需求无独立 state 层），每步对照对应 L3 文件即可。

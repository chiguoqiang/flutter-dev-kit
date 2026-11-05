# test/ · 测试规则（L3）

> 仅当任务触碰 `test/`（或新增需要测试的代码）时生效；与根 `AGENTS.md` 冲突以本文件为准。预算 ≤50 行。

## 结构与命名

- `test/` 路径镜像 `lib/`：`lib/services/dify_api.dart` → `test/services/dify_api_test.dart`
- 文件名 `*_test.dart`；用例描述写完整句子（`'throws on timeout'`，不是 `'test1'`）

## 运行

- 全量：`flutter test`；单文件：`flutter test test/<path>`；可读输出：`flutter test --reporter expanded`

## 规范

- 单测禁止真实网络、真实系统时间（注入 / mock 时钟）；用例之间禁止依赖执行顺序
- mock 用 <mocktail | mockito + build_runner>；生成式 mock 禁止手改 `*.mocks.dart`
- Widget 测试三段式：`pumpWidget` → `await tester.pumpAndSettle()`（有动画必须 settle）→ `expect(find…)`
- 禁止提交 `skip` 的用例；断言必须验证具体值，"没抛异常就算过"不算测试
- 新增 `lib/services/`、`lib/models/` 的公开方法必须附带测试；页面改动至少保证现有测试全绿

## 边界

- 修 bug 流程：先写复现用例（红）→ 修复（绿）→ 提交，防止回归
- `flutter analyze` 的 info 不阻塞，warning 尽量清零

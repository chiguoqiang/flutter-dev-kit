# test/ · 测试规则（L3 · mocktail）

> 仅当任务触碰 `test/`（或新增需要测试的代码）时生效；与根 `AGENTS.md` 冲突以本文件为准。

## 结构与命名

- 路径镜像 `lib/`：`lib/services/customer_api.dart` → `test/services/customer_api_test.dart`
- 文件名 `*_test.dart`；用例描述完整句子（`'R1: 搜索返回空列表时不抛异常'`）

## 运行

- 全量 `flutter test`；单文件 `flutter test test/<path>`；可读输出 `--reporter expanded`

## 规范

- mock 用 mocktail（无 build_runner，禁止混入 mockito）；`registerFallbackValue` 别忘
- 单测禁止真实网络、真实系统时间；用例之间禁止依赖执行顺序
- Widget 测试：`pumpWidget`（外面包 `ProviderScope`，需要时 override 测试用 Provider）
  → `await tester.pumpAndSettle()`（有动画必须 settle）→ `expect(find…)`
- 断言验证具体值；"没抛异常就算过"不算测试
- `lib/services/`、`lib/models/` 公开方法必须附带测试；页面改动保证现有测试全绿
- 修 bug 流程：先写复现用例（红）→ 修复（绿）→ 提交

## 边界

- 不提交 `skip` 的用例；`flutter analyze` warning 尽量清零

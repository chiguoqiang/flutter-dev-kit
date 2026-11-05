# Flutter 个人全局规则（L1）

<!-- 用法：追加到 ~/.claude/CLAUDE.md（或 ~/.codex/AGENTS.md 等全局文件）末尾。
     只放"换任何 Flutter 项目都成立"的习惯；项目差异一律放 L2/L3。预算 ≤50 行。 -->

## 工程习惯

- 动手前先读仓库根 `AGENTS.md`，遵循其中的命令与红线
- 完成定义（DoD）：`flutter analyze` 零 error（warning 尽量清零）+ `flutter test` 全绿
- 遵循 Effective Dart；格式统一交给 `dart format`，不引入个人风格差异
- 新组件优先 StatelessWidget + const 构造函数；确需生命周期才用 StatefulWidget
- 不主动做：`flutter pub upgrade`、新增依赖、改 Flutter/Dart SDK 版本、`flutter clean`

## 空安全

- 禁止用 `!` 消除编译错误；确需使用必须有非空证据并加注释说明
- `late` 只用于构造后立刻初始化（如 initState）的字段
- 后端可空字段在 model 层就标 nullable 或给默认值，不在 UI 层到处 `??` 兜底

## 跨项目常见坑

- `await` 之后使用 `context` 前必须 `if (!mounted) return;`
- TextEditingController / AnimationController / FocusNode / StreamSubscription 必须 dispose
- 长列表必须 ListView.builder；item 能 const 就 const
- 拿不准的 Flutter API 先查官方文档或源码，不凭记忆写平台 API

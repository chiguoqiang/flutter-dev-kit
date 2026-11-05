# lib/models/ · 数据模型层规则（L3）

> 仅当任务触碰 `lib/models/` 时生效；与根 `AGENTS.md` 冲突以本文件为准。预算 ≤55 行。

## 不可变性

- 模型全部字段 `final`；需要"修改"时用 `copyWith` 生成新实例，禁止原地改
- 必须重写 `==` 与 `hashCode`（手写或 freezed 生成），否则列表去重 / Diff 失效

## 序列化

- 每个模型必须提供 `fromJson` / `toJson`；snake_case → camelCase 转换集中声明，不散落多处
- 使用 json_serializable / freezed 时：改完源文件必须执行
  `dart run build_runner build --delete-conflicting-outputs`
- 禁止手改 `*.g.dart` / `*.freezed.dart`（生成物，改了会被覆盖）

## 可空性与数值

- 可空性即后端契约：可能缺失的字段必须 nullable 或显式默认值，二选一并注释原因
- 金额 / 分数等精确值用 `int` 或 `String`，避免 `double` 运算误差（0.1 + 0.2 问题）
- 时间字段统一 <ISO8601 字符串 | int 时间戳>，解析只发生在 model 层

## 测试

- 每个模型至少一个 round-trip 用例：`fromJson(toJson(m)) == m`

# lib/models/ · 数据模型层规则（L3 · json_serializable）

> 仅当任务触碰 `lib/models/` 时生效；与根 `AGENTS.md` 冲突以本文件为准。

## 不可变性

- 字段全部 `final`；"修改"用 `copyWith` 生成新实例，禁止原地改
- 需要判等/去重/Diff 的模型必须重写 `==` 与 `hashCode`（json_serializable 不生成，需手写或混入）

## 序列化（本项目用 json_serializable）

- 模型写法：`@JsonSerializable()` + `fromJson`/`toJson` 手写一行转发：
  `factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);`
- snake_case → camelCase 用 `@JsonKey(name: 'xxx_snake')` 逐字段声明，禁止散落多处转换
- 改了任何标注文件后必跑：
  `dart run build_runner build --delete-conflicting-outputs`
- 禁止手改 `*.g.dart`（生成物，改了会被覆盖）

## 可空性与数值

- 可空性即后端契约：可能缺失的字段必须 `String?`/默认值二选一，并注释原因；
  以 `docs/api/` 文档字段表为准
- 金额/绩效数值：后端给分（int）或字符串就用原样，禁止 `double` 运算后再比较；
  ID 一律 `String` 或 `int`，禁 double
- 时间字段统一 ISO8601 字符串，解析只发生在 model 层

## 测试

- 每个模型至少一个 round-trip 用例：`fromJson(toJson(m)) == m`

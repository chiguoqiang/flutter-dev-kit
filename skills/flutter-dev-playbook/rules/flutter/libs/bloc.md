# Bloc 库级规范（选 Bloc 时加载）

> 项目 `docs/rules/bloc.md` 存在时以项目文件为准。基调：**强约束**——Bloc 的价值在纪律，
> 用法发散就失去可维护性。每条可验证。

## 命名与结构

- 事件命名 `<名词><动词>`：`CustomerLoaded` / `CustomerSearched`；禁止 `XxxEvent` 后缀
- 状态命名 `<聚合>State` 并以**不可变类**表达（freezed 或手写 final）；多状态用继承/sealed：
  `CustomerInitial/CustomerLoading/CustomerLoaded/CustomerError`
- 文件归属：`<域>_bloc.dart`（event+state+bloc 同文件，域小）或 `bloc/` 子目录（域大），二选一全项目一致
- 一个 Bloc 只管一个聚合根；跨聚合数据经 Repository 组装，禁止 Bloc 相互订阅

## 写法铁律

- 业务规则禁止写在 UI 与 event handler 之外：Bloc 只做「event → 调 repository/service → emit 状态」，
  计算与校验在 model/service 层
- event handler 用 `on<Xxx>(_onXxx, transformer: droppable()/restartable())` 显式声明并发策略；
  搜索类必须 `restartable()`（新请求取消旧的），提交类必须 `droppable()`（防双击）
- 禁止在 handler 内直接 `emit` 多次中间态绕过状态机；状态迁移必须与 `docs/biz/` 状态机一致
- `close()` 中必须取消所有 `streamSubscription` 与定时器
- 副作用（埋点/弹窗/导航）放 `BlocListener`，禁止塞进 Bloc 内

## UI 层

- 取状态用 `BlocBuilder` + **`buildWhen`** 精确过滤；列表项用 `BlocSelector` 只选需要的字段
- 触发事件统一 `context.read<T>().add(...)`，禁止在 `build` 内 add（构造即触发的初始化用
  `context.read<T>().add(XxxInit())` 放在 `State.initState` 之后首帧或 entry 事件）
- 全局唯一 Bloc（如主题/登录）才用 `MultiBlocProvider` 挂 App 根；页面级 Bloc 随页面创建销毁

## 测试（blocTest）

- 每个 Bloc 至少：初始状态断言 + 每类 event 一条 `blocTest`（seed → act → expect 精确状态序列）
- 状态机类：每个合法迁移一条 + 至少 1 个非法迁移不产生 emit
- repository 一律 mock；禁止真网络

## 反模式速查（review 时对照）

❌ UI 里写 if(bloc.state is X && ...) 业务分支 ❌ 状态类带可变字段 ❌ handler 里没并发策略
❌ Bloc 里 import dio ❌ 嵌套 BlocBuilder 超过 2 层不拆 widget

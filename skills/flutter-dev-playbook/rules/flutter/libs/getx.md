# GetX 库级规范（选 GetX 时加载）

> 项目 `docs/rules/getx.md` 存在时以项目文件为准。基调：**约束式**——GetX 自由度极高，
> 不设边界会迅速失控；本规范限定"GetX 只做什么"，其余回归分层。

## 使用边界（最重要）

- GetX 只承担三件事：**状态（GetxController/Rx）· 路由（Get.toNamed）· 依赖注入（Get.put/lazyPut）**
- 网络请求禁止写在 Controller 里直接用 Get.http/dio 混调：必须经 `lib/services/` 的
  `ApiClient`/`*_api.dart`（与其他选型同一红线）
- GetStorage 不与 shared_preferences 混用：持久化统一收敛到 `*_store.dart`，用哪个在 L2 写死
- 禁止 `Get.context` 在 Controller 中做导航/弹窗以外的 UI 操作；`Get.snackbar` 文案必须来自常量层

## Controller 规范

- 命名 `<域>Controller`，一页一 Controller；禁止"上帝 Controller"跨多页持有状态
- 生命周期：初始化放 `onInit()`、清理放 `onClose()`（订阅/timer/TextEditingController 必须清）
- 状态声明：`final list = <Customer>[].obs;` `final isLoading = false.obs;`
  禁止非 Rx 字段参与 UI 刷新后再手动 update()（要么 Rx 要么 update，二选一并注释）
- 防抖节流：搜索输入用 `debounce(ms)`；禁止在 onChange 里直接发请求
- 页面级 Controller 用 `Get.lazyPut(() => XController(), fenix: false)`；全局 Controller 才
  `Get.put`；**注册与获取必须同名成对出现**，禁止散落 `Get.find` 于非页面层

## 路由规范

- 全部命名路由：`GetPage(name: '/customer/:id', ...)` 集中在 `router.dart` 注册；
  跳转一律 `Get.toNamed('/customer/${c.id}')`，禁止 `Get.to(CustomerPage())` 匿名跳转
- 参数传递：简单 id 用路径参数；复杂对象禁止整包传参，传 id 由 Controller 加载

## UI 层

- 响应式用 `Obx(() => ...)` 且**内部只包真正依赖 Rx 的最小片段**；禁止整页套一个大 Obx
- 列表：`Obx` 内 `ListView.builder`；item 级刷新考虑拆子 Obx
- 业务规则禁止写在 View/Controller 之外散落（计算在 model/service）

## 测试

- Controller 用 `Get.testMode = true` + mocktail mock `*_api`；断言 Rx 值与 `obs` 变化
- Widget 测试用 `GetMaterialApp` 包裹；路由跳转断言 `Get.currentRoute`

## 反模式速查（review 时对照）

❌ Controller 里直接 dio/Get.http ❌ 整页一个 Obx ❌ Get.to 匿名跳转 ❌ onClose 忘清理
❌ View 里 if(ctr.isLoading.value) 之外的复杂业务分支 ❌ Get.find 出现在 service/model 层

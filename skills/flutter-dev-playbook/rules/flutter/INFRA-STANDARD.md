# 基础设施封装规范（INFRA-STANDARD）

> 基础功能 = 与业务无关、全项目共用的能力：网络 / 路由 / 存储 / 日志 / 主题 / 通用组件。
> 原则：**每个基础设施只有一个封装入口**；页面与业务代码只消费封装，不触碰底层插件。
> 本规范可被项目 `docs/rules/infra.md` 同名覆盖。

---

## 1. 网络封装（dio → ApiClient）

**唯一出口**：`lib/services/api_client.dart`（init 预置），全项目禁止第二处 `Dio(`。

| 方面 | 规范 |
|---|---|
| 实例 | 单例 `ApiClient.instance`；`BaseOptions(baseUrl: Config.apiBaseUrl)`，baseUrl 只从 Config 来（--dart-define 切环境） |
| 超时 | 统一在 BaseOptions（连接 10s / 接收 30s）；禁止单请求私自改超时绕过 |
| 拦截器 | 顺序固定：鉴权（附 token）→ 日志（**脱敏后**输出）→ 重试（仅幂等 GET，最多 1 次）；新拦截器必须注释用途 |
| 错误收敛 | 所有 DioException/业务错误码在 `_run` 内收敛为 `ApiException(message, {code})`；UI 只 catch 这一种 |
| 数据边界 | `Map<String,dynamic>` 不出 services 层；各 `*_api.dart` 解析为 Model 后返回 |
| 禁止 | UI import dio；在页面拼 URL/手写 jsonDecode；每个 api 文件自建 Dio 实例 |

## 2. 路由封装（go_router → router.dart）

| 方面 | 规范 |
|---|---|
| 唯一登记 | `lib/router.dart`；新页面必须先注册再跳转，页面内禁止 `Navigator.push` |
| 路由名 | 常量集中：`abstract final class Routes { static const customerDetail = 'customerDetail'; }`；跳转用 `context.pushNamed(Routes.customerDetail, ...)`，禁止裸字符串散落 |
| path 规范 | 资源详情用 path 参数 `/customer/:id`；list/filter 用 query 参数 |
| 传参 | 简单值走 path/query；复杂对象**禁止整包 extra 传递**——传 id 由目标页 ViewModel 加载（可恢复、可深链） |
| 守卫/深链 | 鉴权重定向、深链映射集中写在 router.dart（redirect），禁止散落页面 |
| 返回 | 需要回传结果的用 `context.push` + `pop(result)`；结果类型显式声明 |

## 3. 本地存储封装（→ *_store.dart）

- 持久化统一收敛到 `lib/services/*_store.dart`；选型（SharedPreferences/Hive）在 L2 写死，禁止混用
- 对外只暴露 Model 与 `Future<void>` 写入；键名集中在 `abstract final class StorageKeys`
- 禁止页面/ViewModel 直接 import 存储插件

## 4. 日志封装

- 统一经 Logger 封装（级别 debug/info/warning/error + Tag=文件名）；禁止 `print`/`debugPrint` 直用
- **脱敏红线**：token/手机号/身份证/密码必须掩码后输出；Release 构建关闭 debug 级

## 5. 主题封装

- `lib/theme/app_theme.dart` 唯一来源：语义色（success/warning/danger）、间距常量（8pt 网格 gap*）、字体
- 页面取值只用 `Theme.of(context)` / `AppTheme.*`；禁止 `Color(0xFF...)` 与裸 `TextStyle`

## 6. 通用组件入库标准（lib/widgets/）

- 复用 ≥2 处才入库；必须支持 `const` 构造；参数用 `required` 具名 + `onXxx` 回调
- 不 import 任何 service/store；数据由调用方注入（可测试）

## Review 速查（违反即打回）

❌ 页面里出现 dio/http/SharedPreferences/print ❌ 第二处 Dio( ❌ 裸字符串路由名
❌ extra 传整对象 ❌ 绕过 ApiClient 的 fetch ❌ 未脱敏日志

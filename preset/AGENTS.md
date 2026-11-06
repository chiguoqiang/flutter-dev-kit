# __APP_TITLE__ — __APP_DESC__

> Flutter (Dart 3, 空安全) · **架构模式：MVVM** · 状态管理：Riverpod · 网络：dio · 路由：go_router ·
> 序列化：json_serializable · mock：mocktail · import 风格：package: 导入 · 文案：中文写死 · 包管理：pub

## 常用命令（已验证）

```bash
flutter pub get                 # 安装依赖（禁止用 pub upgrade 代替）
flutter devices                 # 查看可用设备
flutter run                     # 本地运行
flutter analyze                 # 静态检查（改动后必跑，必须零 error）
dart format lib test            # 格式化
flutter test                    # 全量测试（改动后必跑）
flutter test test/<path>        # 单文件测试
dart run build_runner build --delete-conflicting-outputs   # 改了 @JsonSerializable 文件后必跑
flutter build apk --release     # Android 构建
flutter build ipa               # iOS 构建（需签名）
```

## 目录地图

| 路径 | 职责 | 改动注意 |
|---|---|---|
| `lib/main.dart` | 入口 | 保持薄：ProviderScope + 路由/主题装配 |
| `lib/router.dart` | go_router 路由唯一登记处 | 新页面必须先在此注册 |
| `lib/pages/` | 全部页面 | 一页一文件 `*_page.dart` |
| `lib/widgets/` | 复用组件 | 复用 ≥2 处才入库 |
| `lib/models/` | 数据模型 | json_serializable 生成，见模块规则 |
| `lib/services/` | 网络 / 本地存储 | UI 禁止 import dio，见模块规则 |
| `lib/theme/` | 主题与间距常量唯一来源 | 禁止在页面硬编码色值 |
| `lib/config.dart` | 环境配置 | 只放占位符，真实值 --dart-define 注入 |
| `test/` | 测试 | 路径镜像 `lib/` |
| `docs/` | 文档 | 只读；含完整规则体系 |
| `android/` `ios/` | 原生工程 | 默认只读（见红线） |

## 深入阅读 · 路由表

**触碰下列区域前，必须先读对应文档：**

| 触碰区域 | 先读 | 一句话原因 |
|---|---|---|
| 任何新需求 | `.github/skills/flutter-dev-playbook/rules/flutter/PLAYBOOK-NEW-FEATURE.md` | 需求卡 + 按层补齐流程 |
| 架构/分层/依赖方向 | `docs/architecture/architecture.md`（无则按 PLAYBOOK-ARCHITECTURE 反哺） | 唯一事实源；改分层先 ADR |
| 基础设施封装（网络/路由/存储/日志/主题） | `.github/skills/flutter-dev-playbook/rules/flutter/INFRA-STANDARD.md` | 唯一封装入口与禁止事项 |
| 接口对接 / 新增接口 | `docs/api/<域名>.md`（无则先按 `API-DOC-TEMPLATE.md` 建立） | 契约、字段可空性与坑 |
| 业务规则（绩效/任务/客户域） | `docs/biz/<域名>.md`（无则先按 `BIZ-DOC-TEMPLATE.md` 建立） | 规则表、状态机、边界算例 |
| 页面 UI 实现 | `docs/ui/<页面名>.md`（无则先按 `UI-DOC-TEMPLATE.md` 建立） | 四态、事件表、文案 |
| 新建工程级变更 | `.github/skills/flutter-dev-playbook/rules/flutter/PLAYBOOK-NEW-PROJECT.md` | 选型与结构基准 |
| 产品规划 / 模块优先级 | `docs/product.md`（材料交接见 `docs/INTAKE.md`） | 模块清单与 MVP 边界 |

> 以上四份模板都在 `.github/skills/flutter-dev-playbook/rules/flutter/`。

## 约定

### 命名规范（文件与标识符）

| 对象 | 规范 | 示例 |
|---|---|---|
| 页面文件/类 | `*_page.dart` / `XxxPage` | `customer_search_page.dart` |
| 通用组件 | `*_widget.dart`（或名词）/ `XxxWidget`，复用≥2 处才入 widgets/ | `tag_chip.dart` |
| ViewModel（状态层） | Riverpod：`*_providers.dart`（`xxxProvider`）；其他方案：`*_view_model.dart` / `XxxViewModel` | `customer_providers.dart` |
| 网络服务 | `*_api.dart` / `XxxApi`，每后端域一文件 | `customer_api.dart` |
| 本地存储 | `*_store.dart` / `XxxStore` | `user_store.dart` |
| 模型 | 名词单数 `.dart`；生成物 `*.g.dart` 禁改 | `customer.dart` |
| 路由名/路径 | 常量类 `Routes` 集中；名小驼峰，path 用 `/xxx/:id` | `Routes.customerDetail` |
| 测试 | 镜像 lib 路径 + `_test.dart`，用例名完整句 | `customer_api_test.dart` |
| 变量/函数/类 | 变量函数 lowerCamelCase；类/枚举 UpperCamelCase；常量与枚举值 lowerCamelCase；包名/文件 snake_case | — |
| 布尔 | `is/has/can/should` 前缀 | `isLoading` |

### 其他约定

- 命名细则见上方「命名规范」表；路由常量 `Routes` 集中管理
- import：一律 `package:shark_app/...` 绝对导入，`lib/` 内禁止相对导入
- 状态：一律 Riverpod（写法见 `lib/AGENTS.md`）；新 Provider 放对应域文件，不放 main.dart
- 样式：颜色/圆角/字体取自 `lib/theme/app_theme.dart` 或 `Theme.of(context)`；
  间距只用 `AppTheme.gap*` 常量；禁止硬编码 `Color(0xFF…)`
- 网络：全部经 `lib/services/api_client.dart`；错误只允许以 `ApiException` 冒泡到 UI
- 文案：用户可见文案统一中文写死（暂不做 intl）
- 资源：新图片/字体必须同步 `pubspec.yaml`；图片先压缩再入库
- 异步：`await` 后使用 `context` 前必须 `if (!context.mounted) return;`

## 红线（条条可判定）

- 禁止手改生成文件：`*.g.dart` / `*.freezed.dart` / `*.gr.dart` / `*.mocks.dart`
- 禁止改动 `android/` `ios/`（gradle、签名、minSdk、Info.plist 权限），除非明确要求
- 禁止 `flutter pub upgrade`、新增/升级依赖、改 SDK 版本，除非明确要求
  （首版依赖：dio / go_router / flutter_riverpod / json_annotation + dev: json_serializable / build_runner / mocktail）
- 禁止提交真实密钥；`lib/config.dart` 只允许占位符，真实值走 `--dart-define`
- 禁止用 `!` 强解可空来"消除"编译错误（有非空证据时须注释说明）

## CI 门禁（已内置 `.github/workflows/ci.yml`）

- push / PR 自动跑：`flutter analyze`（零 error）→ `dart format --set-exit-if-changed lib test` → `flutter test`（全绿）
- CI 绿勾是 DoD 的机器证明，红叉未修复不算完成；Agent 汇报必须附 CI 结果而非自述全绿
- 推送到 GitHub 后自动生效；建议 Settings → Branches 将 `CI` 设为 required check（红叉 PR 无法合并）

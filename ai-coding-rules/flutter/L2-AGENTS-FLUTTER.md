# <App 名> — <一句话定位：给谁用、解决什么问题>

> Flutter <3.x> / Dart <3.x>（空安全）· 状态管理：<setState | Provider | Riverpod | Bloc> · 网络：<dio | http> · 路由：<Navigator.push | 命名路由 | go_router> · 包管理：pub

<!-- 复制到目标仓库根目录，改名 AGENTS.md，填掉所有 <占位符>，删掉用不到的行。预算 ≤150 行。 -->

## 常用命令（每条已人工验证，跑不通的删掉）

```bash
flutter pub get                 # 安装依赖（禁止用 pub upgrade 代替）
flutter devices                 # 查看可用设备
flutter run                     # 本地运行
flutter analyze                 # 静态检查（改动后必跑，必须零 error）
dart format lib test            # 格式化
flutter test                    # 全量测试（改动后必跑）
flutter test test/<path>        # 单文件测试
dart run build_runner build --delete-conflicting-outputs   # 改了标注 @JsonSerializable / freezed 的文件后必跑
flutter build apk --release     # Android 构建
flutter build ipa               # iOS 构建（需签名）
dart fix --apply                # 自动修复 lint；之后必须人工 review + 重跑测试
```

## 目录地图

| 路径 | 职责 | 改动注意 |
|---|---|---|
| `lib/main.dart` | 入口 | 保持薄：只做初始化 + 首屏挂载 |
| `lib/pages/` | 全部页面 | 一页一文件，`*_page.dart` |
| `lib/widgets/` | 复用组件 | 不含业务逻辑 |
| `lib/models/` | 数据模型 | 不可变，见模块规则 |
| `lib/services/` | 网络 / 本地存储 | UI 禁止直接 HTTP，见模块规则 |
| `lib/theme/` | 主题 | 颜色 / 字体唯一来源 |
| `lib/config.dart` | 环境配置 | 只放占位符，不放真实密钥 |
| `test/` | 测试 | 路径镜像 `lib/` |
| `android/` `ios/` | 原生工程 | 默认只读（见红线） |

## 深入阅读 · 路由表

**触碰下列区域前，必须先读对应文档：**

| 触碰区域 | 先读 | 一句话原因 |
|---|---|---|
| 状态管理写法 | `docs/<STATE>.md` | 全项目统一模式 |
| 接口对接 / 新增接口 | `docs/api/<域名>.md`（按 `API-DOC-TEMPLATE.md` 标准维护，一域一文件） | 契约、字段可空性与坑；对接流程见 `PLAYBOOK-NEW-API.md` |
| <域>业务规则（判分/错题/…） | `docs/biz/<域名>.md`（按 `BIZ-DOC-TEMPLATE.md` 维护） | 规则表、状态机、边界算例；流程见 `PLAYBOOK-BIZ-LOGIC.md` |
| 页面 UI 实现 | `docs/ui/<页面名>.md`（按 `UI-DOC-TEMPLATE.md` 维护） | 四态、事件表、文案；Figma 流程见 `PLAYBOOK-UI-PAGE.md` |
| <…> | `docs/<…>.md` | <…> |

## 约定

- 命名：页面 `*_page.dart`、组件 `*_widget.dart`、服务 `*_api.dart` / `*_store.dart`
- 接口契约：文档放 `docs/api/<域名>.md`，接口变更必须同步文档；代码实现以文档为准
- import：`lib/` 内统一 <相对导入 | package: 导入>（二选一，全项目一致）
- 样式：颜色 / 圆角 / 字体一律取自 `lib/theme/` 或 `Theme.of(context)`，禁止硬编码 `Color(0xFF…)`（一次性 demo 除外）
- 异步：`await` 后使用 `context` 前必须 `if (!mounted) return;`
- 资源：新图片 / 字体必须同步声明进 `pubspec.yaml`；图片先压缩再入库
- 文案：用户可见文案 <统一中文写死 | 走 intl / arb 多语言>

## 红线（≤5 条，条条可判定）

- 禁止手改任何生成文件：`*.g.dart` / `*.freezed.dart` / `*.gr.dart` / `*.mocks.dart` / `*.gen.dart`
- 禁止改动 `android/` `ios/`（gradle、签名、minSdk、Info.plist 权限），除非明确要求
- 禁止 `flutter pub upgrade`、新增 / 升级依赖、改 SDK 版本，除非明确要求
- 禁止提交真实密钥；`lib/config.dart` 只允许占位符
- 禁止用 `!` 强解可空来"消除"编译错误（有非空证据时须注释说明）

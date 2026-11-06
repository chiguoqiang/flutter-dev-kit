# Playbook A · 新建 Flutter 工程 SOP

> 目标：从 `flutter create` 到一个「目录规范 + 基础设施 + 三级 Rules 齐备 + Agent 可直接正确干活」的工程。
> 预计 60 分钟。所有规则模板取自本目录，方法依据 `../GUIDE.md`。

---

## 阶段 0 · 技术选型（10 min，一次性写死，禁止"两可"）

> 本 kit 的 init 已自动生成 `docs/tech-stack.yaml`（预填默认选型+版本约束，sed 实例化项目名/日期）。
> **用户改这个文件即可完成选型定制**（版本约束、换库、约定），改后告知 Agent「按 tech-stack 调整」，
> 由 Agent 同步 pubspec / AGENTS.md 技术栈行 / 对应 libs 库规范——不直接手改 pubspec。

下方决策表是 tech-stack.yaml 各字段的选项与推荐默认：

| 决策项 | 可选项 | 推荐默认 |
|---|---|---|
| 状态管理 | setState / Provider / Riverpod / Bloc | 单人小 App：setState + service 层；中大型：Riverpod |
| 网络库 | http / dio | dio（超时/拦截器开箱即用） |
| 路由 | Navigator.push / 命名路由 / go_router | ≤10 页：命名路由；有深链接：go_router |
| 序列化 | 手写 fromJson / json_serializable / freezed | 模型 ≥5 个：json_serializable |
| 国际化 | 中文写死 / intl + arb | 只做国内：写死 |
| mock 库 | mocktail / mockito | mocktail（无需 build_runner） |
| import 风格 | 相对导入 / package: 导入 | package: 导入 |
| 最低版本 | Android minSdk / iOS deployment target | 按用户分布定，写进 L2 |

## 阶段 1 · 创建工程（5 min）

```bash
flutter create --org com.<org> --platforms android,ios <app_name>
cd <app_name>
flutter run        # 冒烟：能跑再继续
```

## 阶段 2 · 目录骨架（5 min）

```bash
mkdir -p lib/theme lib/models lib/services lib/pages lib/widgets \
         test/models test/services test/pages docs/api docs/biz docs/ui docs/features
```

规则库与 Skill 一体分发，由 flutter-dev-kit 的 `install.sh` 自动完成（手动等价操作）：

```text
kit: skills/flutter-dev-playbook/{SKILL.md, rules/} → 工程: .github/skills/flutter-dev-playbook/
kit: agents/flutter-dev.agent.md                  → 工程: .github/agents/
kit: skills/.../rules/INTAKE.md                   → 工程: docs/INTAKE.md（材料清单）
```

目标结构（后续所有代码都有唯一归处）：

```text
lib/
├── main.dart            # 入口，保持薄
├── config.dart          # 环境配置，只放占位符
├── theme/app_theme.dart # 颜色/字体唯一来源
├── models/              # 数据模型（不可变）
├── services/            # 网络 + 本地存储（唯一 HTTP 出口）
├── pages/               # 页面，一页一文件 *_page.dart
└── widgets/             # 复用组件
test/                    # 路径镜像 lib/
docs/                    # 专题文档（路由表的目的地）
```

## 阶段 3 · 基础设施（20 min，最小可运行集）

1. **`analysis_options.yaml`**：启用 `flutter_lints`（或团队自定义超集）
2. **`lib/theme/app_theme.dart`**：定义 `AppTheme`，色板/字体集中于此
3. **`lib/config.dart`**：`apiBaseUrl` 等全部占位符，不进真实值
4. **`lib/services/api_client.dart`**：唯一 HTTP 出口，骨架见文末附录
5. **`pubspec.yaml`**：只加最小依赖（选型表结论），每加一个写注释说明用途

## 阶段 4 · 规则落地（10 min，复制映射表）

| 从本目录复制 | 到目标工程 | 动作 |
|---|---|---|
| `L2-AGENTS-FLUTTER.md` | 根 `AGENTS.md` | 填全部 `<占位符>`，删用不到的行，路由表指向真实 `docs/` |
| `L3-services-network.md` | `lib/services/AGENTS.md` | 填客户端名与超时值 |
| `L3-models.md` | `lib/models/AGENTS.md` | 填序列化方案 |
| `L3-ui-pages-widgets.md` | `lib/pages/AGENTS.md` | 填路由方案 |
| `L3-state-management.md` | `lib/AGENTS.md` | **只保留所选方案那一段**，删其余 |
| `L3-testing.md` | `test/AGENTS.md` | 填 mock 库 |
| `L1-flutter-global.md` | `~/.claude/CLAUDE.md` | 追加（一次性，跨项目生效） |

**L2 占位符逐项核对**（填一个勾一个）：

- [ ] 技术栈行：状态管理 / 网络 / 路由 / 序列化
- [ ] 命令区：每条亲手跑通（跑不通的删）
- [ ] 目录地图：与实际骨架一致
- [ ] 路由表：至少登记 1–2 个 `docs/` 文档
- [ ] 约定区：import 风格、文案策略写死
- [ ] 红线：默认 5 条保留，按需增删

**适配薄层三件套**（一次建好，规则只维护 `AGENTS.md` 一份）：

```text
CLAUDE.md                          → 内容仅一行: @AGENTS.md
.cursor/rules/00-agents.mdc        → alwaysApply: true，正文一句"先读根 AGENTS.md"
.github/copilot-instructions.md    → 一句话"开工前先完整阅读根 AGENTS.md 并严格遵守"
```

## 阶段 5 · 验证（10 min）

- [ ] `flutter analyze` 零 error
- [ ] `flutter test` 全绿（哪怕只有模板测试）
- [ ] `flutter run` 冒烟通过
- [ ] **Agent 实测**：给一个小任务（如"首页加一个按钮跳转到新页面"），检查它是否：
  走了正确的目录 / 用了 theme 取色 / 遵守了红线。不遵循 → 按 `../GUIDE.md` §8 调优

## 阶段 6 · Git

```bash
git init && git add . && git commit -m "chore: bootstrap with rules & infra"
```

规则文件从此随代码一起进 Git、走 PR review（Rules-as-Code）。

---

## 附录 · `api_client.dart` 骨架

```dart
// lib/services/api_client.dart —— 全项目唯一 HTTP 出口；UI 层禁止 import dio/http
import 'package:dio/dio.dart';
import 'package:<app>/config.dart';

class ApiException implements Exception {
  final String message; // 面向用户的文案
  ApiException([this.message = '请求失败，请稍后重试']);
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio = Dio(BaseOptions(
    baseUrl: Config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<dynamic> post(String path, {Object? body}) async {
    try {
      final res = await _dio.post(path, data: body);
      return res.data; // Map/List 在本层解析为 Model 后再给 UI
    } on DioException {
      throw ApiException(); // 网络/超时/5xx 统一收敛，UI 只 catch ApiException
    }
  }
}
```

import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';

/// 路由名唯一常量：跳转一律 `context.pushNamed(Routes.xxx)`，禁止裸字符串
/// （规范见 rules/flutter/INFRA-STANDARD.md §2）
abstract final class Routes {
  static const home = 'home';
}

/// 路由唯一登记处：新页面必须在此注册后才能导航（规则见 lib/pages/AGENTS.md）。
/// 深链/鉴权重定向等需求扩展时，先读 docs/ui/ 对应页面文档再改这里。
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    // 新路由示例（name 用 Routes 常量登记）：
    // GoRoute(
    //   path: '/customer/:id',
    //   name: Routes.customerDetail,
    //   builder: (context, state) => CustomerDetailPage(id: state.pathParameters['id']!),
    // ),
  ],
);

/// 环境配置：只放占位符，禁止提交真实密钥（红线，见根 AGENTS.md）。
///
/// 真实值通过运行参数注入，例如：
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
abstract final class Config {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://REPLACE_ME', // TODO: 联调前替换为真实网关地址
  );

  /// 业务 token 获取方式待定（登录接口接入后在 user store 中管理，不写死在此）
  static const Duration networkConnectTimeout = Duration(seconds: 10);
  static const Duration networkReceiveTimeout = Duration(seconds: 30);
}

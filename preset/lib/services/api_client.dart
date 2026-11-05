import 'package:dio/dio.dart';

import '../config.dart';

/// 面向 UI 的统一异常：页面只允许 catch 这一种（规则见 lib/services/AGENTS.md）
class ApiException implements Exception {
  final String message; // 可直接展示给用户的文案
  final int? code; // 业务错误码（网络异常时为 null）
  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException($code): $message';
}

/// 全项目唯一 HTTP 出口：UI 层禁止 import dio、禁止拼 URL、禁止手写 JSON 编解码。
/// 新增接口流程见 .github/skills/flutter-dev-playbook/rules/flutter/PLAYBOOK-NEW-API.md。
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Config.apiBaseUrl,
      connectTimeout: Config.networkConnectTimeout,
      receiveTimeout: Config.networkReceiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _run(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? body}) =>
      _run(() => _dio.post(path, data: body));

  Future<dynamic> _run(Future<Response<dynamic>> Function() task) async {
    try {
      final res = await task();
      final data = res.data;
      // TODO(接口接入后): 按 docs/api/ 文件头的通用错误格式，
      // 在这里统一拦截业务错误码并抛 ApiException(code, message)
      return data; // Map/List 由各 *_api.dart 解析为 Model 后再给 UI
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      // 网络/超时/5xx 统一收敛为用户可读文案，细节只进日志
      throw ApiException(switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => '请求超时，请检查网络后重试',
        _ => '网络异常，请稍后重试',
      });
    }
  }
}

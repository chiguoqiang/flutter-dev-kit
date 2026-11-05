import 'package:flutter/material.dart';

/// 主题唯一来源：全项目禁止硬编码 Color(0xFF…) / 裸 TextStyle（规则见 lib/pages/AGENTS.md）
///
/// 语义色请一律使用 [ColorScheme] 与本文件定义的扩展语义，
/// 页面/组件通过 `Theme.of(context)` 取值。
abstract final class AppTheme {
  /// 主色：企业蓝（后续换品牌色只改这里）
  static const Color seed = Color(0xFF1E5AF0);

  /// 功能语义色（浅色主题）
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  /// 间距常量（8pt 网格，页面只允许从这里取值）
  static const double gap4 = 4;
  static const double gap8 = 8;
  static const double gap12 = 12;
  static const double gap16 = 16;
  static const double gap24 = 24;
  static const double gap32 = 32;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: const AppBarTheme(centerTitle: true),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48), // 热区 ≥ 44
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return ThemeData(colorScheme: scheme);
  }
}

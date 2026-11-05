import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 工作台首页（占位骨架：接入真实需求时按 docs/ui/home_page.md 替换，
/// 流程见 docs/ai-coding-rules/flutter/PLAYBOOK-UI-PAGE.md）
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('工作台')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dashboard_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.gap16),
            Text('业务模块待接入', style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppTheme.gap8),
            Text(
              '按 docs/ai-coding-rules 的 Playbook 逐模块补齐',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

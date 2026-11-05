
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:__APP_NAME__/main.dart';

void main() {
  testWidgets('首页渲染出工作台骨架', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('工作台'), findsOneWidget);
    expect(find.textContaining('待接入'), findsOneWidget);
  });
}

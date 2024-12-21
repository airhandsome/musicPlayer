// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:musicplayer/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 设置 SharedPreferences 的模拟实例
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // 构建我们的应用并触发一个frame
    await tester.pumpWidget(MyApp(prefs: prefs));

    // 验证
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 点击 '+' 图标并触发一个frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 验证计数器是否+1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

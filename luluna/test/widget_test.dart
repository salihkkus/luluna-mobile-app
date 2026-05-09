// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luluna/main.dart';

void main() {
  testWidgets('Luluna app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LulunaApp());

    // Verify that splash screen appears
    expect(find.text('Luluna'), findsOneWidget);
    expect(find.text('Hadi Keşfedelim'), findsOneWidget);

    // Tap the start button
    await tester.tap(find.text('Hadi Keşfedelim'));
    await tester.pumpAndSettle();

    // Verify that main navigation appears
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.show_chart), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });
}

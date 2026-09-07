// Basic smoke test: verifies the app builds and renders without crashing.

import 'package:ai_chatapp/app.dart';
import 'package:ai_chatapp/presentation/home/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MyApp(home:HomeScreen(),));

    // Just verify the app renders — no crash, no red error screen.
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
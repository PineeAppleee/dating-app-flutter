import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:serious_dating_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final router = GoRouter(routes: []);
    await tester.pumpWidget(SeriousDatingApp(router: router));

    // Verify that the app starts.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for the splash screen timer (3 seconds) and animations to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}

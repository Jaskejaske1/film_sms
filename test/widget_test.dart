// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:film_sms/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FilmSMSApp(), // Changed from MyApp to FilmSMSApp
      ),
    );

    // Verify that the app loads with a localized title (nl or en)
    final titleMatches =
        find.text('Berichten').evaluate().isNotEmpty ||
        find.text('Messages').evaluate().isNotEmpty;
    expect(titleMatches, true);

    // Open the app bar menu and check a localized item
    // Tap the overflow/menu button (PopupMenuButton is in actions)
    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    expect(find.text('Inject De Lijn'), findsOneWidget);
  });
}

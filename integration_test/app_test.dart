import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Restaurant App End-to-End', () {
    testWidgets('Launch app and verify home loads', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Switch to Favorites tab and back', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });
  });
}

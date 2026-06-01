import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/ui/widgets/favorite_button.dart';

import 'mocks/fake_favorite_provider.dart';

void main() {
  testWidgets('FavoriteButton shows outlined heart when not favorited', (
    tester,
  ) async {
    final restaurant = Restaurant(
      id: 'r1',
      name: 'Test',
      description: 'd',
      pictureId: 'p',
      city: 'Jakarta',
      rating: 4.0,
    );

    final fakeProvider = FakeFavoriteProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoriteProvider>.value(
        value: fakeProvider,
        child: MaterialApp(
          home: Scaffold(body: FavoriteButton(restaurant: restaurant)),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
  });

  testWidgets('FavoriteButton shows filled heart when favorited', (
    tester,
  ) async {
    final restaurant = Restaurant(
      id: 'r1',
      name: 'Test',
      description: 'd',
      pictureId: 'p',
      city: 'Jakarta',
      rating: 4.0,
    );

    final fakeProvider = FakeFavoriteProvider(initialFavorites: [restaurant]);

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoriteProvider>.value(
        value: fakeProvider,
        child: MaterialApp(
          home: Scaffold(body: FavoriteButton(restaurant: restaurant)),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });
}

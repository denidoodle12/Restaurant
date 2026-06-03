import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/repositories/favorite_repository.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

import 'favorite_provider_test.mocks.dart';

@GenerateMocks([FavoriteRepository])
void main() {
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
  });

  final testRestaurant = Restaurant(
    id: 'fav1',
    name: 'Favorite Place',
    description: 'Saved spot',
    pictureId: 'p1',
    city: 'Surabaya',
    rating: 4.7,
  );

  group('FavoriteProvider', () {
    test('initial state should load empty when no favorites stored', () async {
      when(mockRepository.getFavorites()).thenAnswer((_) async => []);

      final provider = FavoriteProvider(repository: mockRepository);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(provider.state, isA<ResultEmpty<List<Restaurant>>>());
      expect(provider.favorites, isEmpty);
    });

    test('should add a restaurant to favorites', () async {
      when(mockRepository.getFavorites())
          .thenAnswer((_) async => [testRestaurant]);
      when(mockRepository.addFavorite(any)).thenAnswer((_) async {});

      final provider = FavoriteProvider(repository: mockRepository);
      await provider.addFavorite(testRestaurant);

      verify(mockRepository.addFavorite(testRestaurant)).called(1);
      expect(provider.favorites.length, 1);
      expect(provider.favorites.first.id, 'fav1');
    });

    test('should remove a restaurant from favorites', () async {
      when(mockRepository.getFavorites()).thenAnswer((_) async => []);
      when(mockRepository.removeFavorite(any)).thenAnswer((_) async {});

      final provider = FavoriteProvider(repository: mockRepository);
      await provider.removeFavorite('fav1');

      verify(mockRepository.removeFavorite('fav1')).called(1);
      expect(provider.favorites, isEmpty);
    });
  });
}

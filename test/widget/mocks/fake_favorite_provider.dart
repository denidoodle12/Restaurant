import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/repositories/favorite_repository.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class FakeFavoriteProvider extends FavoriteProvider {
  FakeFavoriteProvider({List<Restaurant> initialFavorites = const []})
    : super(repository: _FakeRepo()) {
    _seed(initialFavorites);
  }

  void _seed(List<Restaurant> initialFavorites) {
    favorites
      ..clear()
      ..addAll(initialFavorites);
    notifyListeners();
  }

  @override
  Future<void> loadFavorites() async {}

  @override
  Future<void> addFavorite(Restaurant restaurant) async {
    favorites.add(restaurant);
    notifyListeners();
  }

  @override
  Future<void> removeFavorite(String id) async {
    favorites.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  @override
  bool isFavorite(String id) => favorites.any((r) => r.id == id);

  @override
  ResultState<List<Restaurant>> get state =>
      favorites.isEmpty ? const ResultEmpty() : ResultSuccess(favorites);
}

class _FakeRepo implements FavoriteRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

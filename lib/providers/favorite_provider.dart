import 'package:flutter/foundation.dart';
import '../data/models/restaurant.dart';
import '../data/repositories/favorite_repository.dart';
import '../utils/error_helper.dart';
import '../utils/result_state.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository repository;

  FavoriteProvider({required this.repository}) {
    loadFavorites();
  }

  ResultState<List<Restaurant>> _state = const ResultLoading();
  ResultState<List<Restaurant>> get state => _state;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final result = await repository.getFavorites();
      _favorites = result;
      _state = result.isEmpty
          ? const ResultEmpty()
          : ResultSuccess(result);
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
    }

    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await repository.addFavorite(restaurant);
      await loadFavorites();
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await repository.removeFavorite(id);
      await loadFavorites();
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
      notifyListeners();
    }
  }

  bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }
}

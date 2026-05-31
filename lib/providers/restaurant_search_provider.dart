import 'package:flutter/foundation.dart';
import '../data/models/restaurant.dart';
import '../data/repositories/restaurant_repository.dart';
import '../utils/error_helper.dart';
import '../utils/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantSearchProvider({required this.repository});

  ResultState<List<Restaurant>> _state = const ResultEmpty();
  ResultState<List<Restaurant>> get state => _state;

  String _query = '';
  String get query => _query;

  Future<void> searchRestaurants(String query) async {
    _query = query;

    if (query.isEmpty) {
      _state = const ResultEmpty();
      notifyListeners();
      return;
    }

    _state = const ResultLoading();
    notifyListeners();

    try {
      final restaurants = await repository.searchRestaurants(query);
      if (restaurants.isEmpty) {
        _state = const ResultEmpty();
      } else {
        _state = ResultSuccess(restaurants);
      }
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
    }

    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _state = const ResultEmpty();
    notifyListeners();
  }
}

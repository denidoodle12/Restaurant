import 'package:flutter/foundation.dart';
import '../data/models/restaurant.dart';
import '../data/repositories/restaurant_repository.dart';
import '../utils/error_helper.dart';
import '../utils/result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantListProvider({required this.repository}) {
    fetchRestaurantList();
  }

  ResultState<List<Restaurant>> _state = const ResultLoading();
  ResultState<List<Restaurant>> get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final restaurants = await repository.getRestaurantList();

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
}

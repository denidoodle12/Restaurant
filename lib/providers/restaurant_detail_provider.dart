import 'package:flutter/foundation.dart';
import '../data/models/customer_review.dart';
import '../data/models/restaurant_detail.dart';
import '../data/repositories/restaurant_repository.dart';
import '../utils/error_helper.dart';
import '../utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantDetailProvider({required this.repository});

  ResultState<RestaurantDetail> _state = const ResultLoading();
  ResultState<RestaurantDetail> get state => _state;

  RestaurantDetail? _restaurantDetail;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final detail = await repository.getRestaurantDetail(id);
      _restaurantDetail = detail;
      _state = ResultSuccess(detail);
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
    }

    notifyListeners();
  }

  void updateReviews(List<CustomerReview> reviews) {
    final current = _restaurantDetail;
    if (current == null) return;

    final updated = RestaurantDetail(
      id: current.id,
      name: current.name,
      description: current.description,
      city: current.city,
      address: current.address,
      pictureId: current.pictureId,
      rating: current.rating,
      categories: current.categories,
      menus: current.menus,
      customerReviews: reviews,
    );

    _restaurantDetail = updated;
    _state = ResultSuccess(updated);
    notifyListeners();
  }
}

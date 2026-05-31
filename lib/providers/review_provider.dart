import 'package:flutter/foundation.dart';
import '../data/models/customer_review.dart';
import '../data/repositories/restaurant_repository.dart';
import '../utils/error_helper.dart';
import '../utils/result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  ReviewProvider({required this.repository});

  ResultState<List<CustomerReview>> _state = const ResultEmpty();
  ResultState<List<CustomerReview>> get state => _state;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<CustomerReview>? _latestReviews;
  List<CustomerReview>? get latestReviews => _latestReviews;

  Future<bool> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _isSubmitting = true;
    _state = const ResultLoading();
    notifyListeners();

    try {
      final reviews = await repository.addReview(
        id: restaurantId,
        name: name,
        review: review,
      );
      _latestReviews = reviews;
      _state = ResultSuccess(reviews);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ResultError(ErrorHelper.getReadableError(e.toString()));
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}

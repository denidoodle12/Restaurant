import '../api/api_service.dart';
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';
import '../models/customer_review.dart';

class RestaurantRepository {
  final ApiService apiService;

  RestaurantRepository({required this.apiService});

  Future<List<Restaurant>> getRestaurantList() async {
    final response = await apiService.getRestaurantList();

    if (response.error) {
      throw Exception(response.message);
    }
    return response.restaurants;
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await apiService.getRestaurantDetail(id);

    if (response.error) {
      throw Exception(response.message);
    }
    return response.restaurant;
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await apiService.searchRestaurants(query);

    if (response.error) {
      throw Exception('Search failed');
    }
    return response.restaurants;
  }

  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await apiService.addReview(
      id: id,
      name: name,
      review: review,
    );

    if (response.error) {
      throw Exception(response.message);
    }
    return response.customerReviews;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/constants.dart';
import '../models/customer_review.dart';
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listEndpoint}'),
    );

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.detailEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?q=$query',
      ),
    );

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<AddReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviewEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }
}

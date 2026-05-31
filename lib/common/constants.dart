import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String listEndpoint = '/list';
  static const String detailEndpoint = '/detail';
  static const String searchEndpoint = '/search';
  static const String reviewEndpoint = '/review';
}

class AppColors {
  static const Color primaryColor = Color(0xFFFF5722);
  static const Color accentColor = Color(0xFFFF8A65);
  static const Color starColor = Color(0xFFFFB800);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
}

class AppStrings {
  static const String appName = 'MakanBang';
  static const String findFavorite = 'Find Your Favorite';
  static const String restaurant = 'Restaurant';
  static const String searchHint = 'Search restaurants...';
  static const String about = 'About';
  static const String menu = 'Menu';
  static const String foods = 'Foods';
  static const String drinks = 'Drinks';
  static const String reviews = 'Reviews';
  static const String writeReview = 'Write Review';
  static const String submitReview = 'Submit Review';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String noData = 'No restaurants found';
  static const String errorOccurred = 'Something went wrong';
  static const String yourName = 'Your name';
  static const String yourReview = 'Your review';
}

import '../db/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteRepository {
  final DatabaseHelper databaseHelper;

  FavoriteRepository({required this.databaseHelper});

  Future<List<Restaurant>> getFavorites() => databaseHelper.getFavorites();

  Future<void> addFavorite(Restaurant restaurant) =>
      databaseHelper.insertFavorite(restaurant);

  Future<void> removeFavorite(String id) => databaseHelper.removeFavorite(id);

  Future<bool> isFavorite(String id) => databaseHelper.isFavorite(id);
}

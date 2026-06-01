import '../data/models/restaurant.dart';

class DetailScreenArgs {
  final Restaurant restaurant;
  final String heroTagPrefix;

  const DetailScreenArgs({
    required this.restaurant,
    this.heroTagPrefix = 'home',
  });
}

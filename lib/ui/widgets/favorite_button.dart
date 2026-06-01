import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant.dart';
import '../../providers/favorite_provider.dart';

class FavoriteButton extends StatelessWidget {
  final Restaurant restaurant;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.restaurant,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        final isFavorite = provider.isFavorite(restaurant.id);
        return IconButton(
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite
                ? (activeColor ?? Colors.redAccent)
                : (inactiveColor ?? Colors.white),
          ),
          onPressed: () {
            if (isFavorite) {
              provider.removeFavorite(restaurant.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${restaurant.name} removed from favorites'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              provider.addFavorite(restaurant);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${restaurant.name} added to favorites'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }
}

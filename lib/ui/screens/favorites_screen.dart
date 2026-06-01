import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/detail_args.dart';
import '../../common/navigation.dart';
import '../../data/models/restaurant.dart';
import '../../providers/favorite_provider.dart';
import '../../utils/result_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/restaurant_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Favorites',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<FavoriteProvider>(
            builder: (context, provider, _) {
              final count = provider.favorites.length;
              return Text(
                count == 0
                    ? 'No favorites yet'
                    : '$count restaurant${count == 1 ? '' : 's'} saved',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        return switch (provider.state) {
          ResultLoading() => const Center(child: CircularProgressIndicator()),
          ResultSuccess<List<Restaurant>>(:final data) =>
            RefreshIndicator(
              onRefresh: () => provider.loadFavorites(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final restaurant = data[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    heroTagPrefix: 'fav',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: DetailScreenArgs(
                          restaurant: restaurant,
                          heroTagPrefix: 'fav',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ResultError(:final message) => ErrorDisplay(
            message: message,
            onRetry: () => provider.loadFavorites(),
          ),
          ResultEmpty() => _buildEmptyState(context),
        };
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any restaurant\nto save it here',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

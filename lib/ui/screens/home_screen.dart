import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/detail_args.dart';
import '../../common/navigation.dart';
import '../../data/models/restaurant.dart';
import '../../providers/restaurant_list_provider.dart';
import '../../utils/result_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildHeader(context),
            Expanded(child: _buildRestaurantList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
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
              Icons.restaurant_menu_rounded,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppStrings.appName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Search restaurants',
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${AppStrings.findFavorite}\n',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    height: 1.15,
                    letterSpacing: -0.6,
                  ),
                ),
                TextSpan(
                  text: '${AppStrings.restaurant} ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                    height: 1.15,
                    letterSpacing: -0.6,
                  ),
                ),
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text('🍽️', style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Consumer<RestaurantListProvider>(
            builder: (context, provider, child) {
              final count = switch (provider.state) {
                ResultSuccess<List<Restaurant>>(:final data) => data.length,
                _ => 0,
              };
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      count > 0 ? '$count restaurants' : 'Loading...',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'curated for you',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, provider, child) {
        return switch (provider.state) {
          ResultLoading() => const ShimmerLoading(),
          ResultSuccess<List<Restaurant>>(:final data) => RefreshIndicator(
            onRefresh: () => provider.fetchRestaurantList(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final restaurant = data[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  heroTagPrefix: 'home',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: DetailScreenArgs(
                        restaurant: restaurant,
                        heroTagPrefix: 'home',
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ResultError(:final message) => ErrorDisplay(
            message: message,
            onRetry: () => provider.fetchRestaurantList(),
          ),
          ResultEmpty() => const EmptyDisplay(),
        };
      },
    );
  }
}

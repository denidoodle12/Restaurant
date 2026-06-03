import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../data/models/restaurant.dart';
import '../../data/models/restaurant_detail.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../providers/restaurant_detail_provider.dart';
import '../../providers/review_provider.dart';
import '../../utils/result_state.dart';
import '../widgets/add_review_sheet.dart';
import '../widgets/error_widget.dart';
import '../widgets/favorite_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/menu_section.dart';
import '../widgets/review_card.dart';

class DetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantRepository repository;
  final String heroTagPrefix;

  const DetailScreen({
    super.key,
    required this.restaurant,
    required this.repository,
    this.heroTagPrefix = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantDetailProvider(repository: repository)
                ..fetchRestaurantDetail(restaurant.id),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewProvider(repository: repository),
        ),
      ],
      child: _DetailScreenContent(
        restaurant: restaurant,
        heroTagPrefix: heroTagPrefix,
      ),
    );
  }
}

class _DetailScreenContent extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTagPrefix;

  const _DetailScreenContent({
    required this.restaurant,
    required this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            ResultLoading() => _buildLoadingState(context),
            ResultSuccess<RestaurantDetail>(:final data) => _buildSuccessState(
              context,
              data,
            ),
            ResultError(:final message) => _buildErrorState(
              context,
              message,
              provider,
            ),
            ResultEmpty() => _buildErrorState(
              context,
              'No data found',
              provider,
            ),
          };
        },
      ),
      floatingActionButton: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          if (provider.state is ResultSuccess<RestaurantDetail>) {
            return FloatingActionButton.extended(
              onPressed: () => _showAddReviewSheet(context),
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text(AppStrings.writeReview),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, restaurant.imageUrl),
        const SliverFillRemaining(child: ShimmerDetailLoading()),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, RestaurantDetail detail) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, detail.imageUrl),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, detail),
                const SizedBox(height: 24),
                _buildAboutSection(context, detail),
                const SizedBox(height: 24),
                MenuSection(menu: detail.menus),
                const SizedBox(height: 24),
                ReviewSection(
                  reviews: detail.customerReviews,
                  onWriteReview: () => _showAddReviewSheet(context),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    RestaurantDetailProvider provider,
  ) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, restaurant.imageUrl),
        SliverFillRemaining(
          child: ErrorDisplay(
            message: message,
            onRetry: () => provider.fetchRestaurantDetail(restaurant.id),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, String imageUrl) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.black38,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.black38,
            child: FavoriteButton(restaurant: restaurant),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: '$heroTagPrefix-restaurant-image-${restaurant.id}',
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant, size: 80),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, RestaurantDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                detail.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.starColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        detail.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '(${detail.customerReviews.length}+)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${detail.address}, ${detail.city}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        if (detail.categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detail.categories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, RestaurantDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.about, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ReadMoreText(
          detail.description,
          trimLines: 4,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' Read more',
          trimExpandedText: ' Show less',
          style: Theme.of(context).textTheme.bodyMedium,
          moreStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
          lessStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showAddReviewSheet(BuildContext context) {
    final reviewProvider = context.read<ReviewProvider>();
    final detailProvider = context.read<RestaurantDetailProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: reviewProvider),
          ChangeNotifierProvider.value(value: detailProvider),
        ],
        child: AddReviewSheet(restaurantId: restaurant.id),
      ),
    );
  }
}

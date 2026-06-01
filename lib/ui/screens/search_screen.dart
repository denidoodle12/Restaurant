import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/detail_args.dart';
import '../../common/navigation.dart';
import '../../data/models/restaurant.dart';
import '../../providers/restaurant_search_provider.dart';
import '../../utils/result_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/restaurant_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<RestaurantSearchProvider>().searchRestaurants(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: _onSearchChanged,
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<RestaurantSearchProvider>().clearSearch();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantSearchProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            ResultLoading() => const ShimmerLoading(itemCount: 3),
            ResultSuccess<List<Restaurant>>(:final data) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final restaurant = data[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  heroTagPrefix: 'search',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: DetailScreenArgs(
                        restaurant: restaurant,
                        heroTagPrefix: 'search',
                      ),
                    );
                  },
                );
              },
            ),
            ResultError(:final message) => ErrorDisplay(
              message: message,
              onRetry: () => provider.searchRestaurants(provider.query),
            ),
            ResultEmpty() => _buildEmptyState(context, provider.query),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    if (query.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Search for restaurants',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter a restaurant name or city',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No restaurants found',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with different keywords',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/navigation.dart';
import 'common/styles.dart';
import 'data/api/api_service.dart';
import 'data/models/restaurant.dart';
import 'data/repositories/restaurant_repository.dart';
import 'providers/restaurant_list_provider.dart';
import 'providers/restaurant_search_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/search_screen.dart';

void main() {
  final apiService = ApiService();
  final repository = RestaurantRepository(apiService: apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(repository: repository),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(repository: repository),
        ),
      ],
      child: MyApp(repository: repository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RestaurantRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'RestaurantFinder',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.home:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
              case AppRoutes.detail:
                final restaurant = settings.arguments as Restaurant;
                return MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    restaurant: restaurant,
                    repository: repository,
                  ),
                );
              case AppRoutes.search:
                return MaterialPageRoute(builder: (_) => const SearchScreen());
              default:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
          },
        );
      },
    );
  }
}

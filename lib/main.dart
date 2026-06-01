import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/detail_args.dart';
import 'common/navigation.dart';
import 'common/styles.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/restaurant_repository.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/restaurant_list_provider.dart';
import 'providers/restaurant_search_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/detail_screen.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/search_screen.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final restaurantRepository = RestaurantRepository(apiService: apiService);
  final databaseHelper = DatabaseHelper();
  final favoriteRepository = FavoriteRepository(databaseHelper: databaseHelper);
  final preferencesHelper = PreferencesHelper(
    sharedPreferences: SharedPreferences.getInstance(),
  );

  final notificationHelper = NotificationHelper();
  final backgroundService = BackgroundService();
  await configureLocalTimezone();
  await notificationHelper.init();
  await backgroundService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(preferencesHelper: preferencesHelper),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantListProvider(repository: restaurantRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantSearchProvider(repository: restaurantRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(repository: favoriteRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            preferencesHelper: preferencesHelper,
            backgroundService: backgroundService,
            notificationHelper: notificationHelper,
          ),
        ),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ],
      child: MyApp(repository: restaurantRepository),
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
          title: 'Restaurant App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.home:
                return MaterialPageRoute(builder: (_) => const MainScreen());
              case AppRoutes.detail:
                final args = settings.arguments as DetailScreenArgs;
                return MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    restaurant: args.restaurant,
                    repository: repository,
                    heroTagPrefix: args.heroTagPrefix,
                  ),
                );
              case AppRoutes.search:
                return MaterialPageRoute(builder: (_) => const SearchScreen());
              default:
                return MaterialPageRoute(builder: (_) => const MainScreen());
            }
          },
        );
      },
    );
  }
}

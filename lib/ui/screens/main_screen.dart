import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../providers/bottom_nav_provider.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const _screens = [HomeScreen(), FavoritesScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          body: IndexedStack(
            index: navProvider.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: _buildBottomNav(context, navProvider),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, BottomNavProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    return NavigationBar(
      selectedIndex: provider.currentIndex,
      onDestinationSelected: provider.setIndex,
      backgroundColor: colorScheme.surface,
      indicatorColor: AppColors.primaryColor.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800
              : FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryColor
              : colorScheme.onSurface.withValues(alpha: 0.6),
        );
      }),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: AppColors.primaryColor,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          selectedIcon: Icon(
            Icons.favorite_rounded,
            color: AppColors.primaryColor,
          ),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(
            Icons.settings_rounded,
            color: AppColors.primaryColor,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}

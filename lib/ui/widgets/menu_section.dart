import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../data/models/menu.dart';
import '../../providers/menu_tab_provider.dart';

class MenuSection extends StatelessWidget {
  final Menu menu;

  const MenuSection({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuTabProvider(),
      child: _MenuSectionContent(menu: menu),
    );
  }
}

class _MenuSectionContent extends StatelessWidget {
  final Menu menu;

  const _MenuSectionContent({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.menu, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Consumer<MenuTabProvider>(
          builder: (context, provider, child) {
            return Row(
              children: [
                _MenuTab(
                  title: AppStrings.foods,
                  icon: Icons.restaurant,
                  isSelected: provider.showFoods,
                  onTap: () => provider.selectFoods(),
                ),
                const SizedBox(width: 12),
                _MenuTab(
                  title: AppStrings.drinks,
                  icon: Icons.local_cafe,
                  isSelected: !provider.showFoods,
                  onTap: () => provider.selectDrinks(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Consumer<MenuTabProvider>(
          builder: (context, provider, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: provider.showFoods
                  ? _MenuGrid(key: const ValueKey('foods'), items: menu.foods)
                  : _MenuGrid(
                      key: const ValueKey('drinks'),
                      items: menu.drinks,
                    ),
            );
          },
        ),
      ],
    );
  }
}

class _MenuTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuTab({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  final List<MenuItem> items;

  const _MenuGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No items available'),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _MenuItemChip(item: item)).toList(),
    );
  }
}

class _MenuItemChip extends StatelessWidget {
  final MenuItem item;

  const _MenuItemChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(item.name, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

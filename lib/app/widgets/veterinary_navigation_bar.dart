import 'package:flutter/material.dart';

class VeterinaryNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const VeterinaryNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const items = [
    (
      icon: Icons.pets_outlined,
      selectedIcon: Icons.pets_rounded,
      label: 'Home',
    ),
    (
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Pets',
    ),
    (
      icon: Icons.psychology_alt_outlined,
      selectedIcon: Icons.psychology_alt_rounded,
      label: 'Intake',
    ),
    (
      icon: Icons.description_outlined,
      selectedIcon: Icons.description_rounded,
      label: 'Records',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      height: 80,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      indicatorColor: colorScheme.secondaryContainer,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      destinations: items.map(
        (item) {
          return NavigationDestination(
            icon: Icon(
              item.icon,
              size: 24,
            ),
            selectedIcon: Icon(
              item.selectedIcon,
              size: 24,
            ),
            label: item.label,
          );
        },
      ).toList(),
    );
  }
}
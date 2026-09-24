import 'package:flutter/material.dart';

class PatientNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PatientNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const items = [
    (
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    (
      icon: Icons.medical_services_outlined,
      selectedIcon: Icons.medical_services_rounded,
      label: 'Case',
    ),
    (
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      label: 'Chat',
    ),
    (
      icon: Icons.description_outlined,
      selectedIcon: Icons.description_rounded,
      label: 'Records',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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


class PatientShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const PatientShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: selectedIndex,
        onSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                '/patient',
              );
              break;

            case 1:
              Navigator.pushReplacementNamed(
                context,
                '/patient/case',
              );
              break;

            case 2:
              Navigator.pushReplacementNamed(
                context,
                '/patient/doctor-chat',
              );
              break;

            case 3:
              Navigator.pushReplacementNamed(
                context,
                '/patient/records',
              );
              break;
          }
        },
      ),
    );
  }
}
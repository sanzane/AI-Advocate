import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Hosts the four tabs with a Material 3 bottom navigation bar.
/// The bar is hidden while the keyboard is open so composers stay usable.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      body: shell,
      bottomNavigationBar: keyboardOpen
          ? null
          : DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: NavigationBar(
                selectedIndex: shell.currentIndex,
                onDestinationSelected: (i) =>
                    shell.goBranch(i, initialLocation: i == shell.currentIndex),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline),
                    selectedIcon: Icon(Icons.chat_bubble),
                    label: 'Ask AI',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.folder_outlined),
                    selectedIcon: Icon(Icons.folder),
                    label: 'My Cases',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bookmark_border),
                    selectedIcon: Icon(Icons.bookmark),
                    label: 'Saved',
                  ),
                ],
              ),
            ),
    );
  }
}

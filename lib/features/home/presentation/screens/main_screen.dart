import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/custom_bottom_navigation.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _calculateSelectedIndex(context),
        onItemTapped: (index) => _onItemTapped(index, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/matches')) return 0;
    if (location.startsWith('/likes')) return 1;
    if (location.startsWith('/discover')) return 2;
    if (location.startsWith('/chats')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 2; // Default to Discover (Center)
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/matches');
        break;
      case 1:
        context.go('/likes');
        break;
      case 2:
        context.go('/discover');
        break;
      case 3:
        context.go('/chats');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}

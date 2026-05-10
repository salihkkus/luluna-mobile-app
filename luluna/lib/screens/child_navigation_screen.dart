import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'camera_screen.dart';
import 'games_screen.dart';
import 'profile_screen.dart';

class ChildNavigationScreen extends StatefulWidget {
  const ChildNavigationScreen({super.key});

  @override
  State<ChildNavigationScreen> createState() => _ChildNavigationScreenState();
}

class _ChildNavigationScreenState extends State<ChildNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const CameraScreen(),
    const GamesScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.camera_alt,
      activeIcon: Icons.camera_alt,
      label: 'Nesne Tespiti',
    ),
    NavigationItem(
      icon: Icons.games,
      activeIcon: Icons.games,
      label: 'Oyunlar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                _navigationItems[0].label,
                _navigationItems[0].icon,
                _currentIndex == 0,
                () => _navigateToTab(0),
              ),
              _buildBottomNavItem(
                _navigationItems[1].label,
                _navigationItems[1].icon,
                _currentIndex == 1,
                () => _navigateToTab(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTheme.bodySmall.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

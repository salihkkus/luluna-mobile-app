import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'camera_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const CameraScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
    const HelpScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.camera_alt,
      activeIcon: Icons.camera_alt,
      label: 'Kamera',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.bar_chart,
      activeIcon: Icons.bar_chart,
      label: 'Gelişim',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.settings,
      activeIcon: Icons.settings,
      label: 'Ayarlar',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.help_outline,
      activeIcon: Icons.help,
      label: 'Yardım',
      badge: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Ana İçerik
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          
          // Floating Navigation Bar
          _buildFloatingNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.containerMargin),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.sm,
            vertical: AppTheme.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = _currentIndex == index;
              
              return _buildNavigationItem(item, isActive, index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md,
          vertical: AppTheme.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 24,
                  color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
                ),
                if (item.badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              item.label,
              style: AppTheme.labelSmall.copyWith(
                color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
  });
}

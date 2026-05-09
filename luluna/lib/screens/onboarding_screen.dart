import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'consent_privacy_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': 'Luluna\'ya Başla',
      'subtitle': 'Gözlerinle keşfetmeye başla',
      'description': 'Otizmli çocuklar için tasarlanmış akıllı öğrenme asistanı',
      'icon': Icons.nightlight_round,
      'color': AppTheme.primary,
    },
    {
      'title': 'Güvenli Öğrenme',
      'subtitle': 'Sakinleştirici tasarım',
      'description': 'Duyusal dostu arayüz ile kaygısız öğrenme deneyimi',
      'icon': Icons.security,
      'color': AppTheme.secondary,
    },
    {
      'title': 'Akıllı Tespit',
      'subtitle': 'Yapay zeka destekli',
      'description': 'Nesneleri kolayca tanıyarak kelime dağarcığını genişlet',
      'icon': Icons.auto_awesome,
      'color': AppTheme.tertiary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ConsentPrivacyScreen(),
        ),
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ConsentPrivacyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Üst Kısım - Atla Butonu
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.lg),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Atla',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = _onboardingPages[index];
                  return _buildOnboardingPage(page);
                },
              ),
            ),
            
            // Alt Kısım - Sayfa Göstergesi ve Buton
            Padding(
              padding: const EdgeInsets.all(AppTheme.lg),
              child: Column(
                children: [
                  // Sayfa Göstergesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                            ? AppTheme.primary 
                            : AppTheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.xl),
                  
                  // Devam Et Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingPages.length - 1 
                          ? 'Başla' 
                          : 'Devam Et',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // İkon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (page['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              page['icon'] as IconData,
              size: 60,
              color: page['color'] as Color,
            ),
          ),
          
          const SizedBox(height: AppTheme.xl),
          
          // Başlık
          Text(
            page['title'] as String,
            style: AppTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.md),
          
          // Alt Başlık
          Text(
            page['subtitle'] as String,
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.lg),
          
          // Açıklama
          Text(
            page['description'] as String,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

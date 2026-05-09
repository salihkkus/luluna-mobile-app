import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                'Oyunlar 🎮',
                style: AppTheme.headlineLarge,
              ),
              const SizedBox(height: AppTheme.md),
              Text(
                'Yakında çok eğlenceli oyunlar eklenecek! 🎉',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.xl),
              
              // Geliştirme Mesajı
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // İkon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.construction,
                          size: 60,
                          color: AppTheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.lg),
                      
                      // Başlık
                      Text(
                        'Oyunlar Geliyor! 🚀',
                        style: AppTheme.headlineMedium.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.md),
                      
                      // Açıklama
                      Text(
                        'Çok yakında harika oyunlar ekleyeceğiz!\nBizi takip etmeye devam et! 🌟',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppTheme.xl),
                      
                      // Özellikler
                      Container(
                        padding: const EdgeInsets.all(AppTheme.lg),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.outline),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Sizin İçin Neler Var? 🎁',
                              style: AppTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppTheme.md),
                            _buildFeatureItem('🧩 Eşleştirme Oyunları'),
                            _buildFeatureItem('🎨 Boyama Aktiviteleri'),
                            _buildFeatureItem('🎵 Sesli Oyunlar'),
                            _buildFeatureItem('🧠 Zeka Geliştirme'),
                            _buildFeatureItem('📖 Hikaye Okuma'),
                            _buildFeatureItem('🎯 Hedef Odaklı Görevler'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppTheme.sm),
          Text(
            feature,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

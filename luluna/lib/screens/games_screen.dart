import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  // Oyun verileri
  final List<GameData> games = [
    GameData(
      title: '🧩 Eşleştirme Oyunu',
      description: 'Eşleştir ve kazan!',
      icon: Icons.extension,
      color: AppTheme.primary,
      isComingSoon: false,
    ),
    GameData(
      title: '🎨 Boyama Atölyesi',
      description: 'Renklerle oyna!',
      icon: Icons.palette,
      color: AppTheme.secondary,
      isComingSoon: false,
    ),
    GameData(
      title: '🎵 Müzik Dünyası',
      description: 'Notalarla dans et!',
      icon: Icons.music_note,
      color: AppTheme.tertiary,
      isComingSoon: false,
    ),
    GameData(
      title: '🧠 Zeka Oyunları',
      description: 'Bulmacaları çöz!',
      icon: Icons.psychology,
      color: AppTheme.primary,
      isComingSoon: false,
    ),
    GameData(
      title: '📖 Hikaye Zamanı',
      description: 'Masallara dal!',
      icon: Icons.auto_stories,
      color: AppTheme.secondary,
      isComingSoon: false,
    ),
    GameData(
      title: '🎯 Hedef Avı',
      description: 'Hedefleri tuttur!',
      icon: Icons.gps_fixed,
      color: AppTheme.tertiary,
      isComingSoon: false,
    ),
  ];

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
                'En sevdiğin oyunlar burada! �',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.xl),
              
              // Oyun Kartları Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.md,
                    mainAxisSpacing: AppTheme.md,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return _buildGameCard(games[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(GameData game) {
    return Container(
      decoration: BoxDecoration(
        color: game.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: game.color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: game.color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Hiçbir şey yapma - sadece görsel efekt
            HapticFeedback.lightImpact();
          },
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Oyun İkonu
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: game.color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: game.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    game.icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // Oyun Başlığı
                Flexible(
                  flex: 2,
                  child: Text(
                    game.title,
                    style: AppTheme.headlineSmall.copyWith(
                      color: game.color,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: AppTheme.sm),
                
                // Oyun Açıklaması
                Flexible(
                  flex: 1,
                  child: Text(
                    game.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                if (game.isComingSoon) ...[
                  const Spacer(),
                
                // "Çok Yakında" etiketi (gerekirse)
                if (game.isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Çok Yakında!',
                      style: AppTheme.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Oyun verisi modeli
class GameData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isComingSoon;

  GameData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isComingSoon = true,
  });
}

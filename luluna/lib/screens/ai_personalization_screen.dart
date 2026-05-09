import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'child_navigation_screen.dart';

class AiPersonalizationScreen extends StatefulWidget {
  const AiPersonalizationScreen({super.key});

  @override
  State<AiPersonalizationScreen> createState() => _AiPersonalizationScreenState();
}

class _AiPersonalizationScreenState extends State<AiPersonalizationScreen> {
  double _speechRate = 1.0;
  double _difficultyLevel = 0.5;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  String _selectedGoal = 'Temel Nesneler';

  final List<String> _learningGoals = [
    'Temel Nesneler',
    'Hayvanlar',
    'Renkler',
    'Sayılar',
    'Meyveler',
    'Yemekler',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'AI Kişiselleştirme',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğrenme Hedefleri',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.md),
              
              // Öğrenme Hedefleri
              Wrap(
                spacing: AppTheme.sm,
                runSpacing: AppTheme.sm,
                children: _learningGoals.map((goal) {
                  final isSelected = goal == _selectedGoal;
                  return FilterChip(
                    label: Text(goal),
                    selected: isSelected,
                    onSelected: (selected) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedGoal = goal;
                      });
                    },
                    backgroundColor: AppTheme.surfaceContainerLowest,
                    selectedColor: AppTheme.primaryContainer,
                    checkmarkColor: AppTheme.primary,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Konuşma Hızı
              Text(
                'Konuşma Hızı',
                style: AppTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.md),
              Slider(
                value: _speechRate,
                min: 0.5,
                max: 2.0,
                divisions: 3,
                label: '${(_speechRate * 100).round()}%',
                onChanged: (value) {
                  setState(() {
                    _speechRate = value;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Zorluk Seviyesi
              Text(
                'Zorluk Seviyesi',
                style: AppTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.md),
              Slider(
                value: _difficultyLevel,
                min: 0.0,
                max: 1.0,
                divisions: 2,
                label: _difficultyLevel == 0.0 ? 'Kolay' : 
                       _difficultyLevel == 0.5 ? 'Orta' : 'Zor',
                onChanged: (value) {
                  setState(() {
                    _difficultyLevel = value;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Ses ve Haptic Ayarları
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Sesler'),
                      subtitle: const Text('Uygulama sesleri'),
                      value: _soundEnabled,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Titreşim'),
                      subtitle: const Text('Haptic feedback'),
                      value: _hapticEnabled,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _hapticEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Başlat Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChildNavigationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    padding: const EdgeInsets.all(AppTheme.lg),
                  ),
                  child: const Text(
                    'Öğrenmeye Başla',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

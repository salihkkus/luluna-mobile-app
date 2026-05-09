import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import 'ai_personalization_screen.dart';

class ChildProfileCreationScreen extends StatefulWidget {
  const ChildProfileCreationScreen({super.key});

  @override
  State<ChildProfileCreationScreen> createState() => _ChildProfileCreationScreenState();
}

class _ChildProfileCreationScreenState extends State<ChildProfileCreationScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  int _currentStep = 0;
  String _selectedAvatar = '👦';
  String _selectedColor = '#2196F3';

  final List<String> _avatars = [
    '👦', '👧', '👶', '🧒',
    '👦🏻', '👧🏻', '👶🏻', '🧒🏻',
    '👦🏽', '👧🏽', '👶🏽', '🧒🏽',
    '👦🏾', '👧🏾', '👶🏾', '🧒🏾',
  ];

  final List<String> _colors = [
    '#2196F3', // Blue
    '#9C27B0', // Purple
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#F44336', // Red
    '#795548', // Brown
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
        _showError('Lütfen çocuğun adını girin');
        return;
      }
      if (_currentStep == 0 && _ageController.text.trim().isEmpty) {
        _showError('Lütfen çocuğun yaşını girin');
        return;
      }
      setState(() {
        _currentStep++;
      });
    } else {
      _createProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _createProfile() async {
    try {
      final profile = {
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'avatar': _selectedAvatar,
        'color': _selectedColor,
        'total_detections': 1,
        'weekly_growth': 1,
        'success_rate': 1,
      };

      await _databaseService.insertProfile(profile);
      
      HapticFeedback.mediumImpact();
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AiPersonalizationScreen(),
        ),
      );
    } catch (e) {
      _showError('Profil oluşturulurken bir hata oluştu');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Profil Oluştur',
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
            children: [
              // İlerleme Göstergesi
              _buildProgressIndicator(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Adım İçeriği
              Expanded(
                child: _buildStepContent(),
              ),
              
              // Navigasyon Butonları
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(0, 'Bilgiler'),
        _buildProgressLine(0),
        _buildProgressStep(1, 'Avatar'),
        _buildProgressLine(1),
        _buildProgressStep(2, 'Renk'),
      ],
    );
  }

  Widget _buildProgressStep(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: AppTheme.bodyMedium.copyWith(
                color: isActive ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.xs),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(int step) {
    final isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.sm),
        color: isActive ? AppTheme.primary : AppTheme.surfaceContainer,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildAvatarStep();
      case 2:
        return _buildColorStep();
      default:
        return _buildBasicInfoStep();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temel Bilgiler',
          style: AppTheme.headlineLarge,
        ),
        const SizedBox(height: AppTheme.md),
        Text(
          'Çocuğunuzun temel bilgilerini girin',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.xl),
        
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Ad',
            hintText: 'Çocuğun adı',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: AppTheme.bodyLarge,
        ),
        
        const SizedBox(height: AppTheme.lg),
        
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Yaş',
            hintText: 'Çocuğun yaşı',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: AppTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildAvatarStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avatar Seçimi',
          style: AppTheme.headlineLarge,
        ),
        const SizedBox(height: AppTheme.md),
        Text(
          'Çocuğunuza uygun avatarı seçin',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.xl),
        
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.md,
              mainAxisSpacing: AppTheme.md,
            ),
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final isSelected = avatar == _selectedAvatar;
              
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Renk Seçimi',
          style: AppTheme.headlineLarge,
        ),
        const SizedBox(height: AppTheme.md),
        Text(
          'Profil için tema rengi seçin',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.xl),
        
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppTheme.lg,
              mainAxisSpacing: AppTheme.lg,
            ),
            itemCount: _colors.length,
            itemBuilder: (context, index) {
              final color = _colors[index];
              final isSelected = color == _selectedColor;
              
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              child: const Text('Geri'),
            ),
          ),
        
        if (_currentStep > 0) const SizedBox(width: AppTheme.md),
        
        Expanded(
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.onPrimary,
            ),
            child: Text(_currentStep == 2 ? 'Oluştur' : 'İleri'),
          ),
        ),
      ],
    );
  }
}

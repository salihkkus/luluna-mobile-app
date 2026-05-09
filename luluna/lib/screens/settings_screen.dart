import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Ses ayarları
  double _speechRate = 0.8;
  double _volume = 1.0;
  String _selectedVoice = 'female';
  String _selectedLanguage = 'tr-TR';
  
  // Kamera ayarları
  String _cameraQuality = 'high';
  bool _flashEnabled = false;
  bool _useFrontCamera = false;
  
  // Ebeveyn kontrolü
  bool _parentalControlEnabled = false;
  String _screenTimeLimit = '30';
  String _reportFrequency = 'weekly';
  
  // Diğer ayarlar
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Ayarlar',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ses Ayarları Bölümü
            _buildSectionHeader('Ses Ayarları', Icons.volume_up),
            const SizedBox(height: AppTheme.md),
            _buildSettingsCard([
              _buildSliderSetting(
                'Ses Seviyesi',
                _volume,
                (value) => setState(() => _volume = value),
                Icons.volume_up,
              ),
              _buildSliderSetting(
                'Konuşma Hızı',
                _speechRate,
                (value) => setState(() => _speechRate = value),
                Icons.speed,
              ),
              _buildDropdownSetting(
                'Dil Seçimi',
                _selectedLanguage,
                ['tr-TR', 'en-US'],
                (value) => setState(() => _selectedLanguage = value!),
                Icons.language,
                {'tr-TR': 'Türkçe', 'en-US': 'English'},
              ),
              _buildDropdownSetting(
                'Ses Tipi',
                _selectedVoice,
                ['female', 'male'],
                (value) => setState(() => _selectedVoice = value!),
                Icons.record_voice_over,
                {'female': 'Kadın', 'male': 'Erkek'},
              ),
            ]),
            
            const SizedBox(height: AppTheme.xl),
            
            // Kamera Ayarları Bölümü
            _buildSectionHeader('Kamera Ayarları', Icons.camera_alt),
            const SizedBox(height: AppTheme.md),
            _buildSettingsCard([
              _buildDropdownSetting(
                'Kamera Kalitesi',
                _cameraQuality,
                ['low', 'medium', 'high'],
                (value) => setState(() => _cameraQuality = value!),
                Icons.high_quality,
                {'low': 'Düşük', 'medium': 'Orta', 'high': 'Yüksek'},
              ),
              _buildSwitchSetting(
                'Flash Kontrolü',
                _flashEnabled,
                (value) => setState(() => _flashEnabled = value),
                Icons.flash_on,
              ),
              _buildSwitchSetting(
                'Ön Kamera Kullan',
                _useFrontCamera,
                (value) => setState(() => _useFrontCamera = value),
                Icons.camera_front,
              ),
            ]),
            
            const SizedBox(height: AppTheme.xl),
            
            // Ebeveyn Kontrolü Bölümü
            _buildSectionHeader('Ebeveyn Kontrolü', Icons.family_restroom),
            const SizedBox(height: AppTheme.md),
            _buildSettingsCard([
              _buildSwitchSetting(
                'Ebeveyn Kontrolü',
                _parentalControlEnabled,
                (value) => setState(() => _parentalControlEnabled = value),
                Icons.lock,
              ),
              if (_parentalControlEnabled) ...[
                _buildDropdownSetting(
                  'Ekran Süresi Limiti',
                  _screenTimeLimit,
                  ['15', '30', '45', '60'],
                  (value) => setState(() => _screenTimeLimit = value!),
                  Icons.timer,
                  {'15': '15 dakika', '30': '30 dakika', '45': '45 dakika', '60': '60 dakika'},
                ),
                _buildDropdownSetting(
                  'Raporlama Sıklığı',
                  _reportFrequency,
                  ['daily', 'weekly', 'monthly'],
                  (value) => setState(() => _reportFrequency = value!),
                  Icons.assessment,
                  {'daily': 'Günlük', 'weekly': 'Haftalık', 'monthly': 'Aylık'},
                ),
              ],
            ]),
            
            const SizedBox(height: AppTheme.xl),
            
            // Diğer Ayarlar Bölümü
            _buildSectionHeader('Diğer Ayarlar', Icons.more_horiz),
            const SizedBox(height: AppTheme.md),
            _buildSettingsCard([
              _buildSwitchSetting(
                'Bildirimler',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
                Icons.notifications,
              ),
              _buildSwitchSetting(
                'Veri Yedekleme',
                _autoBackupEnabled,
                (value) => setState(() => _autoBackupEnabled = value),
                Icons.backup,
              ),
              _buildNavigationSetting(
                'Uygulama Hakkında',
                Icons.info,
                () => _showAboutDialog(),
              ),
            ]),
            
            const SizedBox(height: AppTheme.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.sm),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppTheme.sm),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppTheme.sm),
        Text(
          title,
          style: AppTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    Function(double) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.sm),
              Text(
                title,
                style: AppTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                '${(value * 100).toInt()}%',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Slider(
            value: value,
            onChanged: onChanged,
            min: 0.0,
            max: 1.0,
            divisions: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
    IconData icon,
    Map<String, String> displayNames,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.md),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppTheme.sm),
          Expanded(
            child: Text(
              title,
              style: AppTheme.labelLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.md,
              vertical: AppTheme.sm,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              underline: const SizedBox(),
              isDense: true,
              style: AppTheme.bodyMedium,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(displayNames[item] ?? item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.md),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppTheme.sm),
          Expanded(
            child: Text(
              title,
              style: AppTheme.labelLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSetting(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.sm),
            Expanded(
              child: Text(
                title,
                style: AppTheme.labelLarge,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Uygulama Hakkında',
          style: AppTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Luluna',
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              'Versiyon: 1.0.0',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              'Otizmli çocuklar için AI destekli sosyal iletişim asistanı.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              '© 2024 Luluna Team',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Kapat',
              style: AppTheme.labelLarge.copyWith(
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

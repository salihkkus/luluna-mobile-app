import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import 'profile_selection_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = await _databaseService.getAllProfiles();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Veli Paneli',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.background.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // İçerik Alanı
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: _buildContentArea(),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildContentArea() {
    switch (_selectedIndex) {
      case 0:
        return _buildReportsTab();
      case 1:
        return _buildSettingsTab();
      case 2:
        return _buildHelpTab();
      case 3:
        return _buildProfilesTab();
      default:
        return _buildReportsTab();
    }
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Öğrenme Raporları',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          
          // Özet Kartları - Tasarım Sistemi Uyumlu
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.0,
            children: [
              _buildModernReportCard(
                'Toplam Tespit',
                '156',
                Icons.analytics,
                AppTheme.primary,
                'Bu ay',
                '+12%'
              ),
              _buildModernReportCard(
                'Bu Hafta',
                '23',
                Icons.trending_up,
                AppTheme.secondary,
                'Son 7 gün',
                '+8%'
              ),
              _buildModernReportCard(
                'Başarı Oranı',
                '85%',
                Icons.emoji_events,
                Color(0xFFFFB74D),
                'Ortalama',
                '+5%'
              ),
              _buildModernReportCard(
                'Aktif Gün',
                '12',
                Icons.calendar_today,
                Color(0xFFBA68C8),
                'Bu ay',
                '3 gün'
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // İlerleme Grafiği
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFE9ECEF)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalık İlerleme',
                  style: AppTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                // Basit progress bar simulasyonu
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '75% Tamamlandı',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Hedef: 20 tespit',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Detaylı Raporlar - Modern Tasarım
          Text(
            'Detaylı Raporlar',
            style: AppTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          
          ...[
            {
              'title': 'Nesne Tespit Raporu',
              'subtitle': 'Bugün',
              'icon': Icons.bar_chart,
              'color': AppTheme.primary,
              'value': '15 tespit',
              'trend': '+3'
            },
            {
              'title': 'İlerleme Analizi',
              'subtitle': 'Dün',
              'icon': Icons.trending_up,
              'color': AppTheme.secondary,
              'value': '85% başarı',
              'trend': '+5%'
            },
            {
              'title': 'Haftalık Özet',
              'subtitle': '7 gün önce',
              'icon': Icons.assessment,
              'color': Color(0xFFFFB74D),
              'value': '23 tespit',
              'trend': '+12'
            },
            {
              'title': 'Aylık Değerlendirme',
              'subtitle': '30 gün önce',
              'icon': Icons.insert_chart,
              'color': Color(0xFFBA68C8),
              'value': '156 toplam',
              'trend': '+45'
            },
          ].map((report) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildModernReportItem(report),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        _buildSettingsItem('Ses Ayarları', 'Ses seviyesi ve dil', Icons.volume_up),
        _buildSettingsItem('Kamera Ayarları', 'Kalite ve izinler', Icons.camera_alt),
        _buildSettingsItem('Bildirimler', 'Uyarı ve hatırlatıcılar', Icons.notifications),
        _buildSettingsItem('Gizlilik', 'Veri güvenliği ve izinler', Icons.security),
        _buildSettingsItem('Ebeveyn Kontrolü', 'PIN ve kısıtlamalar', Icons.admin_panel_settings),
      ],
    );
  }

  Widget _buildHelpTab() {
    return ListView(
      children: [
        _buildHelpItem('Kullanım Kılavuzu', 'Uygulama nasıl kullanılır', Icons.book),
        _buildHelpItem('Sıkça Sorulan Sorular', 'SSS ve cevapları', Icons.help),
        _buildHelpItem('İletişim', 'Destek ekibi ile görüşün', Icons.contact_support),
        _buildHelpItem('Geri Bildirim', 'Görüşlerinizi paylaşın', Icons.feedback),
      ],
    );
  }

  Widget _buildProfilesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil Yönetimi',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: AppTheme.md),
        
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_profiles.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.lg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: AppTheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppTheme.md),
                Text(
                  'Henüz profil bulunmuyor',
                  style: AppTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.sm),
                Text(
                  'Yeni bir profil oluşturarak başlayın',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          Expanded(
            child: ListView(
              children: _profiles.map((profile) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.md),
                child: _buildProfileItem(
                  profile['name'],
                  profile['age'],
                  profile['avatar'],
                  Color(int.parse(profile['color'].replaceFirst('#', '0xFF'))),
                  profile['id'],
                ),
              )).toList(),
            ),
          ),
          
        const SizedBox(height: AppTheme.lg),
        
        // Yeni Profil Ekle
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSelectionScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Yeni Profil Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.onPrimary,
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.md),
        
        // Çıkış Yap
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Çıkış Yap'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.onError,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernReportCard(String title, String value, IconData icon, Color color, String period, String trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE9ECEF)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İkon ve trend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: AppTheme.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Başlık ve değer
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const Spacer(),
          
          // Periyot
          Text(
            period,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernReportItem(Map<String, dynamic> report) {
    return GestureDetector(
      onTap: () {
        // Rapor detayı
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFE9ECEF)),
          boxShadow: [
            BoxShadow(
              color: report['color'].withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // İkon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: report['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                report['icon'],
                color: report['color'],
                size: 28,
              ),
            ),
            
            const SizedBox(width: 20),
            
            // İçerik
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'],
                    style: AppTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report['subtitle'],
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Değer ve ok
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  report['value'],
                  style: AppTheme.bodyLarge.copyWith(
                    color: report['color'],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Rapor detayı
      },
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.secondary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Ayar detayı
      },
    );
  }

  Widget _buildHelpItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.tertiary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Yardım detayı
      },
    );
  }

  Widget _buildProfileItem(String name, int age, String avatar, Color color, int profileId) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        children: [
          Text(avatar, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.onSurface,
                  ),
                ),
                Text(
                  '$age yaş',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Profil düzenleme
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirmed = await _showDeleteConfirmation(name);
              if (confirmed) {
                await _databaseService.deleteProfile(profileId);
                _loadProfiles();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(String profileName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profili Sil'),
        content: Text('$profileName profilini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.onError,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg, vertical: AppTheme.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                'Raporlar',
                Icons.analytics,
                _selectedIndex == 0,
                () => _navigateToTab(0),
              ),
              _buildBottomNavItem(
                'Ayarlar',
                Icons.settings,
                _selectedIndex == 1,
                () => _navigateToTab(1),
              ),
              _buildBottomNavItem(
                'Rehber',
                Icons.help,
                _selectedIndex == 2,
                () => _navigateToTab(2),
              ),
              _buildBottomNavItem(
                'Profiller',
                Icons.people,
                _selectedIndex == 3,
                () => _navigateToTab(3),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
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
}

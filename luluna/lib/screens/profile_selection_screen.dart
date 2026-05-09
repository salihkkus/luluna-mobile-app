import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import 'parental_pin_screen.dart';
import 'child_profile_creation_screen.dart';
import 'ai_personalization_screen.dart';
import 'child_navigation_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Profil Seçimi',
          style: AppTheme.headlineSmall.copyWith(
            color: AppTheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                'Profil Seçimi',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.sm),
              Text(
                'Devam etmek için bir profil seçin',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.xl),

              // Profil Listesi
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _profiles.isEmpty
                        ? _buildNoProfilesView()
                        : _buildProfilesList(),
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
                        builder: (context) => const ChildProfileCreationScreen(),
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
            ],
          ),
        ),
      ),
    );
  }

  
  
  
  void _showParentLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ParentalPinScreen(),
      ),
    );
  }

  Widget _buildNoProfilesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 80,
            color: AppTheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppTheme.lg),
          Text(
            'Henüz profil bulunmuyor',
            style: AppTheme.headlineMedium,
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
    );
  }

  Widget _buildProfilesList() {
    return ListView.builder(
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return _buildProfileCard(profile);
      },
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return GestureDetector(
      onTap: () => _showUserTypeDialog(profile),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.md),
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.outline),
        ),
        child: Row(
          children: [
            Text(
              profile['avatar'],
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile['name'],
                    style: AppTheme.headlineSmall,
                  ),
                  Text(
                    '${profile['age']} yaş',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  
  void _showUserTypeDialog(Map<String, dynamic> profile) {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Kullanıcı Türü'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              profile['avatar'],
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              profile['name'],
              style: AppTheme.headlineMedium,
            ),
            Text(
              '${profile['age']} yaş',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.lg),
            Text(
              'Bu profil için hangi kullanıcı türü ile devam etmek istersiniz?',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
            child: Column(
              children: [
                // Çocuk Butonu
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChildNavigationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.child_care, size: 28),
                    label: const Text(
                      'Çocuk Girişi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.primary.withOpacity(0.3),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // Veli Butonu
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParentalPinScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings, size: 28),
                    label: const Text(
                      'Veli Girişi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      foregroundColor: AppTheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.secondary.withOpacity(0.3),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // İptal Butonu
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.outline, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'İptal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

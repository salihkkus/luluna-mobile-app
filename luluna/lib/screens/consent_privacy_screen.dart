import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'profile_selection_screen.dart';

class ConsentPrivacyScreen extends StatefulWidget {
  const ConsentPrivacyScreen({super.key});

  @override
  State<ConsentPrivacyScreen> createState() => _ConsentPrivacyScreenState();
}

class _ConsentPrivacyScreenState extends State<ConsentPrivacyScreen> {
  bool _cameraPermission = true;
  bool _microphonePermission = true;
  bool _storagePermission = true;
  bool _privacyAccepted = true;
  bool _kvkkAccepted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Gizlilik ve İzinler',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Container(
                padding: const EdgeInsets.all(AppTheme.lg),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 48,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(height: AppTheme.md),
                    Text(
                      'Güvenliğiniz Önceliğimiz',
                      style: AppTheme.headlineMedium.copyWith(
                        color: AppTheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppTheme.sm),
                    Text(
                      'Luluna\'nın çalışması için gerekli izinleri ve gizlilik politikasını inceleyin',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // İzinler
              Text(
                'Gerekli İzinler',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.md),
              
              _buildPermissionItem(
                'Kamera İzni',
                'Nesne tespiti ve fotoğraf çekimi için gereklidir',
                Icons.camera_alt,
                _cameraPermission,
                (value) => setState(() => _cameraPermission = value),
              ),
              
              _buildPermissionItem(
                'Mikrofon İzni',
                'Sesli komutlar ve konuşma analizi için gereklidir',
                Icons.mic,
                _microphonePermission,
                (value) => setState(() => _microphonePermission = value),
              ),
              
              _buildPermissionItem(
                'Depolama İzni',
                'Profil verileri ve öğrenme raporları için gereklidir',
                Icons.storage,
                _storagePermission,
                (value) => setState(() => _storagePermission = value),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Gizlilik Politikası
              Text(
                'Gizlilik Politikası',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.md),
              
              _buildPolicyItemWithDetails(
                'KVKK Aydınlatma Metni',
                'Kişisel verilerinizin korunması ve işlenmesi hakkında bilgi',
                _kvkkAccepted,
                (value) => setState(() => _kvkkAccepted = value),
                () => _showKvkkDetails(),
              ),
              
              _buildPolicyItemWithDetails(
                'Gizlilik Politikası',
                'Veri güvenliği ve kullanım koşulları',
                _privacyAccepted,
                (value) => setState(() => _privacyAccepted = value),
                () => _showPrivacyDetails(),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Onay Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _proceed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    padding: const EdgeInsets.all(AppTheme.lg),
                  ),
                  child: const Text(
                    'Devam Et',
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

  Widget _buildPermissionItem(
    String title,
    String description,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.secondary),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.headlineSmall,
                ),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description, color: AppTheme.tertiary),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.headlineSmall,
                ),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: value,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    return _cameraPermission && 
           _microphonePermission && 
           _storagePermission && 
           _privacyAccepted && 
           _kvkkAccepted;
  }

  void _proceed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileSelectionScreen(),
      ),
    );
  }

  Widget _buildPolicyItemWithDetails(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    VoidCallback onDetailsPressed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDetailsPressed,
                icon: Icon(
                  Icons.info_outline,
                  color: AppTheme.primary,
                ),
                tooltip: 'Detayları Gör',
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (value) => onChanged(value ?? false),
                activeColor: AppTheme.primary,
              ),
              Expanded(
                child: Text(
                  'Okudum ve kabul ediyorum',
                  style: AppTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showKvkkDetails() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: AppTheme.sm),
                    Text(
                      'KVKK Aydınlatma Metni',
                      style: AppTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.lg),
                
                _buildSectionTitle('Veri Sorumlusu'),
                _buildContentText(
                  'Luluna mobil uygulaması olarak, 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") kapsamında veri sorumlusu sıfatıyla, kişisel verilerinizi işlerken aşağıdaki ilkelere uygun davranmaktayız:',
                ),
                
                _buildSectionTitle('İşlenen Kişisel Veriler'),
                _buildContentText('Topladığımız veriler:'),
                _buildBulletPoint('Çocuk profili bilgileri (isim, yaş, avatar)'),
                _buildBulletPoint('Kullanım verileri (tespit sayısı, başarı oranları)'),
                _buildBulletPoint('Cihaz bilgileri (model, versiyon)'),
                _buildBulletPoint('Uygulama kullanım istatistikleri'),
                
                _buildSectionTitle('Veri İşleme Amaçları'),
                _buildContentText('Verilerinizi şu amaçlarla işliyoruz:'),
                _buildBulletPoint('Kişiselleştirilmiş öğrenme deneyimi sunmak'),
                _buildBulletPoint('Uygulama performansını iyileştirmek'),
                _buildBulletPoint('Gelişimsel raporlar hazırlamak'),
                _buildBulletPoint('Teknik destek sağlamak'),
                
                _buildSectionTitle('Veri Saklama Süresi'),
                _buildContentText(
                  'Kişisel verileriniz, ilgili amaçların gerçekleştirilmesi için gereken süre kadar saklanacak olup, bu süre geçtikten sonra ilgili mevzuat hükümlerine uygun olarak silinir veya anonim hale getirilir.',
                ),
                
                _buildSectionTitle('Haklarınız'),
                _buildContentText('KVKK kapsamında sahip olduğunuz haklar:'),
                _buildBulletPoint('Verilerinizin işlenip işlenmediğini öğrenme'),
                _buildBulletPoint('Verilerinize erişme'),
                _buildBulletPoint('Verilerinizi düzeltme'),
                _buildBulletPoint('Verilerinizin silinmesini isteme'),
                _buildBulletPoint('Verilerinizin işlenmesini kısıtlama'),
                
                _buildSectionTitle('İletişim'),
                _buildContentText(
                  'KVKK kapsamındaki taleplerinizi ve sorularınız için bizimle iletişime geçebilirsiniz:\n\nE-posta: gizlilik@luluna.com\nAdres: [Adres Bilgisi]',
                ),
                
                const SizedBox(height: AppTheme.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrivacyDetails() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: AppTheme.sm),
                    Text(
                      'Gizlilik Politikası',
                      style: AppTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.lg),
                
                _buildSectionTitle('Gizlilik Taahhüdümüz'),
                _buildContentText(
                  'Luluna olarak, çocukların gizliliğini korumak ve güvenli bir dijital ortam sağlamak en öncelikli hedefimizdir. Bu gizlilik politikası, uygulamamızın nasıl çalıştığını ve verilerinizi nasıl koruduğumuzu açıklar.',
                ),
                
                _buildSectionTitle('Bilgi Toplama'),
                _buildContentText('Aşağıdaki bilgileri toplarız:'),
                _buildBulletPoint('Profil bilgileri (çocuk ismi, yaşı)'),
                _buildBulletPoint('Uygulama kullanım verileri'),
                _buildBulletPoint('Cihaz teknik bilgileri'),
                _buildBulletPoint('Hata raporları ve performans verileri'),
                
                _buildSectionTitle('Bilgi Kullanımı'),
                _buildContentText('Topladığımız bilgileri:'),
                _buildBulletPoint('Uygulama deneyimini kişiselleştirmek için'),
                _buildBulletPoint('Öğrenme ilerlemesini takip etmek için'),
                _buildBulletPoint('Teknik sorunları çözmek için'),
                _buildBulletPoint('Uygulamayı geliştirmek için'),
                
                _buildSectionTitle('Bilgi Paylaşımı'),
                _buildContentText(
                  'Kişisel bilgilerinizi üçüncü taraflarla satmıyoruz, kiralıyoruz veya takas etmiyoruz. Sadece şu durumlarda paylaşım yapabiliriz:',
                ),
                _buildBulletPoint('Yasal zorunluluk olduğunda'),
                _buildBulletPoint('Çocuk güvenliği riski olduğunda'),
                _buildBulletPoint('Hizmet sağlayıcılarla (sadece teknik amaçla)'),
                
                _buildSectionTitle('Veri Güvenliği'),
                _buildContentText(
                  'Bilgilerinizi korumak için:\n• SSL şifreleme kullanıyoruz\n• Güvenli sunucular saklıyoruz\n• Regular güvenlik denetimleri yapıyoruz\n• Çocuk dostu tasarım ilkeleri uyguluyoruz',
                ),
                
                _buildSectionTitle('Ebeveyn Hakları'),
                _buildContentText('Ebeveyn olarak:'),
                _buildBulletPoint('Çocuğunuzun verilerini görme'),
                _buildBulletPoint('Verileri düzeltme veya silme'),
                _buildBulletPoint('Veri işlenmesini kısıtlama'),
                _buildBulletPoint('Uygulama kullanımını yönetme'),
                
                _buildSectionTitle('Çocukların Gizliliği'),
                _buildContentText(
                  '13 yaşından küçük çocuklardan kişisel bilgi toplamıyoruz. Ebeveyn onayı olmadan çocuk bilgilerini işlemiyoruz.',
                ),
                
                _buildSectionTitle('Politika Güncellemeleri'),
                _buildContentText(
                  'Bu gizlilik politikası zaman zaman güncellenebilir. Önemli değişikliklerde sizi bilgilendireceğiz.',
                ),
                
                const SizedBox(height: AppTheme.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.lg, bottom: AppTheme.sm),
      child: Text(
        title,
        style: AppTheme.headlineSmall.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.sm),
      child: Text(
        text,
        style: AppTheme.bodyMedium,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.md, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

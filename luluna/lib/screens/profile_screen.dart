import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'weekly';

  // Mock veri - gerçek uygulamada veritabanından gelecek
  final Map<String, dynamic> _mockData = {
    'totalDetections': 124,
    'weeklyGrowth': 15,
    'averageTime': 25,
    'mostDetected': 'elma',
    'mostDetectedCount': 12,
    'weeklyData': [
      {'day': 'Pzt', 'count': 18},
      {'day': 'Sal', 'count': 22},
      {'day': 'Çar', 'count': 15},
      {'day': 'Per', 'count': 28},
      {'day': 'Cum', 'count': 20},
      {'day': 'Cmt', 'count': 12},
      {'day': 'Paz', 'count': 9},
    ],
    'categoryData': {
      'meyve': 45,
      'sebze': 32,
      'eşya': 28,
      'hayvan': 19,
    },
    'successRate': 78,
    'monthlyData': [
      {'month': 'Oca', 'count': 85},
      {'month': 'Şub', 'count': 92},
      {'month': 'Mar', 'count': 124},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Gelişim Profili',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Header
            _buildProfileHeader(),
            
            const SizedBox(height: AppTheme.lg),
            
            // Özet Kartları
            _buildSummaryCards(),
            
            const SizedBox(height: AppTheme.lg),
            
            // Grafik Bölümü
            _buildGraphSection(),
            
            const SizedBox(height: AppTheme.lg),
            
            // Detaylı İstatistikler
            _buildDetailedStats(),
            
            const SizedBox(height: AppTheme.lg),
            
            // Raporlama Butonları
            _buildReportActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
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
      child: Row(
        children: [
          // Profil Fotoğrafı
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.child_care,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Çocuk Adı',
                  style: AppTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.xs),
                Text(
                  'Yaş: 6 yaş',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTheme.xs),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: AppTheme.xs),
                    Text(
                      'Katılım: 3 ay',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppTheme.md,
      crossAxisSpacing: AppTheme.md,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          '🎯\nToplam Tespit',
          '${_mockData['totalDetections']}',
          AppTheme.primaryContainer,
          AppTheme.primary,
        ),
        _buildSummaryCard(
          '📈\nHaftalık Artış',
          '+${_mockData['weeklyGrowth']}%',
          AppTheme.secondaryContainer,
          AppTheme.secondary,
        ),
        _buildSummaryCard(
          '⏰\nOrtalama Süre',
          '${_mockData['averageTime']} dk',
          AppTheme.tertiaryContainer,
          AppTheme.tertiary,
        ),
        _buildSummaryCard(
          '🏆\nEn Çok Tespit',
          '${_mockData['mostDetected']}',
          AppTheme.errorContainer,
          AppTheme.error,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.labelMedium.copyWith(
              color: textColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppTheme.xs),
          Text(
            value,
            style: AppTheme.headlineSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Periyot Seçimi
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = 'weekly'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.sm),
                    decoration: BoxDecoration(
                      color: _selectedPeriod == 'weekly'
                          ? AppTheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Haftalık',
                      textAlign: TextAlign.center,
                      style: AppTheme.labelLarge.copyWith(
                        color: _selectedPeriod == 'weekly'
                            ? AppTheme.primary
                            : AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = 'monthly'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.sm),
                    decoration: BoxDecoration(
                      color: _selectedPeriod == 'monthly'
                          ? AppTheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Aylık',
                      textAlign: TextAlign.center,
                      style: AppTheme.labelLarge.copyWith(
                        color: _selectedPeriod == 'monthly'
                            ? AppTheme.primary
                            : AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.lg),
          
          // Grafik
          SizedBox(
            height: 200,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final data = _selectedPeriod == 'weekly'
        ? _mockData['weeklyData'] as List<Map<String, dynamic>>
        : _mockData['monthlyData'] as List<Map<String, dynamic>>;
    
    final maxValue = data.map((item) => item['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) {
        final height = (item['count'] as int) / maxValue * 160;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              item['day'] ?? item['month'],
              style: AppTheme.labelSmall,
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              '${item['count']}',
              style: AppTheme.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detaylı İstatistikler',
            style: AppTheme.headlineSmall,
          ),
          
          const SizedBox(height: AppTheme.lg),
          
          // Kategori Dağılımı
          _buildCategoryDistribution(),
          
          const SizedBox(height: AppTheme.lg),
          
          // Başarı Oranı
          _buildSuccessRate(),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    final categoryData = _mockData['categoryData'] as Map<String, dynamic>;
    final total = categoryData.values.fold(0, (sum, count) => sum + count as int);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Bazında Dağılım',
          style: AppTheme.labelLarge,
        ),
        const SizedBox(height: AppTheme.md),
        ...categoryData.entries.map((entry) {
          final percentage = (entry.value as int) / total * 100;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.sm),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key.toUpperCase(),
                    style: AppTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: AppTheme.surfaceContainerLow,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
                const SizedBox(width: AppTheme.sm),
                Text(
                  '${percentage.toInt()}%',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSuccessRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Başarı Oranı',
          style: AppTheme.labelLarge,
        ),
        const SizedBox(height: AppTheme.md),
        Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doğru Cevap Oranı',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xs),
                  Text(
                    '${_mockData['successRate']}%',
                    style: AppTheme.headlineMedium.copyWith(
                      color: AppTheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Raporlama',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.md),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _downloadPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text('PDF İndir'),
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _emailReport,
                icon: const Icon(Icons.email),
                label: Text('E-posta Gönder'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _shareWithTherapist,
            icon: const Icon(Icons.share),
            label: Text('Terapist ile Paylaş'),
          ),
        ),
      ],
    );
  }

  void _shareReport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rapor paylaşılıyor...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _downloadReport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rapor indiriliyor...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _downloadPDF() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF oluşturuluyor...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _emailReport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('E-posta gönderiliyor...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _shareWithTherapist() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terapist ile paylaşılıyor...'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }
}

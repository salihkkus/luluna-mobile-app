import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _helpCategories = [
    {
      'title': '🚀 Başlangıç Kılavuzu',
      'description': 'Uygulamayı nasıl kullanmaya başlarsınız?',
      'icon': Icons.rocket_launch,
      'color': AppTheme.primaryContainer,
      'items': [
        {
          'title': 'İlk Adımlar',
          'content': 'Luluna\'yı kullanmaya başlamak için öncelikle kamera iznini vermeniz gerekmektedir. Ardından "Hadi Keşfedelim" butonuna basarak keşfe başlayabilirsiniz.',
          'type': 'text',
        },
        {
          'title': 'Profil Oluşturma',
          'content': 'Çocuğunuz için bir profil oluşturarak gelişimini takip edebilirsiniz. Profil ekranında isim, yaş ve diğer bilgileri girebilirsiniz.',
          'type': 'text',
        },
      ],
    },
    {
      'title': '🎮 Nasıl Kullanılır?',
      'description': 'Uygulamanın temel özellikleri ve kullanımı',
      'icon': Icons.videogame_asset,
      'color': AppTheme.secondaryContainer,
      'items': [
        {
          'title': 'Nesne Tespiti',
          'content': 'Kamera ekranında "Nesne Tespit Et" butonuna basarak çevrenizdeki nesneleri tanıyabilirsiniz. Uygulama tespit edilen nesneleri sesli olarak size bildirecektir.',
          'type': 'text',
        },
        {
          'title': 'Etkileşim Soruları',
          'content': 'Nesne tespit edildikten sonra uygulama size pedagojik sorular soracaktır. Bu sorular çocuğunuzun gelişimine yardımcı olmak için tasarlanmıştır.',
          'type': 'text',
        },
        {
          'title': 'Gelişim Takibi',
          'content': 'Profil ekranında çocuğunuzun gelişimini grafikler ve istatistikler üzerinden takip edebilirsiniz.',
          'type': 'text',
        },
      ],
    },
    {
      'title': '👨‍👩‍👧 Ebeveyn İçin İpuçları',
      'description': 'Ebeveynlere özel tavsiyeler ve öneriler',
      'icon': Icons.family_restroom,
      'color': AppTheme.tertiaryContainer,
      'items': [
        {
          'title': 'Günlük Kullanım',
          'content': 'Uygulamayı her gün 15-30 dakika arasında kullanmak en iyi sonuçları verir. Düzenli kullanım çocuğunuzun sosyal iletişim becerilerini geliştirmeye yardımcı olur.',
          'type': 'text',
        },
        {
          'title': 'Pozitif Destek',
          'content': 'Çocuğunuzun her başarısını övün ve teşvik edin. Pozitif pekiştirme öğrenme sürecini hızlandırır.',
          'type': 'text',
        },
        {
          'title': 'Sabır',
          'content': 'Her çocuğun öğrenme hızı farklıdır. Sabırlı olun ve çocuğunuzun kendi hızında ilerlemesine izin verin.',
          'type': 'text',
        },
      ],
    },
    {
      'title': '🧠 Pedagojik Bilgiler',
      'description': 'Otizm ve sosyal iletişim hakkında bilgiler',
      'icon': Icons.psychology,
      'color': AppTheme.errorContainer,
      'items': [
        {
          'title': 'Otizmde Sosyal İletişim',
          'content': 'Otizm spektrumundaki çocuklar genellikle sosyal ipuçlarını yorumlamada zorlanabilirler. Luluna bu ipuçlarını basit ve anlaşılır hale getirmeyi amaçlar.',
          'type': 'text',
        },
        {
          'title': 'Görsel Öğrenme',
          'content': 'Birçok otizmli çocuk görsel öğrenmeye daha yatkındır. Luluna, nesneleri görsel olarak tanıyarak bu öğrenme tarzını destekler.',
          'type': 'text',
        },
        {
          'title': 'Tekrar ve Rutin',
          'content': 'Otizmli çocuklar için rutinler önemlidir. Düzenli kullanım, çocuğun uygulama ile güvenli bir bağ kurmasına yardımcı olur.',
          'type': 'text',
        },
      ],
    },
    {
      'title': '❓ Sıkça Sorulan Sorular',
      'description': 'Kullanıcıların en çok sorduğu sorular',
      'icon': Icons.help_outline,
      'color': AppTheme.surfaceContainerLow,
      'items': [
        {
          'title': 'Uygulama ücretli mi?',
          'content': 'Luluna temel özellikleri ücretsiz sunmaktadır. Gelişmiş raporlama ve özel içerikler için premium üyelik seçenekleri mevcuttur.',
          'type': 'text',
        },
        {
          'title': 'İnternet gerekli mi?',
          'content': 'Nesne tespiti özelliği cihaz üzerinde çalıştığı için internet bağlantısı gerektirmez. Ancak raporları senkronize etmek için internet gerekli olabilir.',
          'type': 'text',
        },
        {
          'title': 'Veriler güvende mi?',
          'content': 'Evet, tüm verileriniz şifrelenerek saklanır ve üçüncü kişilerle paylaşılmaz. Çocuğunuzun gizliliği bizim için önemlidir.',
          'type': 'text',
        },
      ],
    },
    {
      'title': '📞 İletişim ve Destek',
      'description': 'Bize ulaşın ve destek alın',
      'icon': Icons.support_agent,
      'color': AppTheme.primaryContainer,
      'items': [
        {
          'title': 'Teknik Destek',
          'content': 'Teknik sorunlar için destek@luluna.com adresine e-posta gönderebilirsiniz.',
          'type': 'text',
        },
        {
          'title': 'Pedagojik Danışmanlık',
          'content': 'Uzman pedagoglarımızdan destek almak için pedagoji@luluna.com adresine ulaşabilirsiniz.',
          'type': 'text',
        },
        {
          'title': 'Geri Bildirim',
          'content': 'Uygulamayı geliştirmemize yardımcı olmak için geri bildirimlerinizi bizimle paylaşın.',
          'type': 'button',
          'action': 'Geri Bildirim Gönder',
        },
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Yardım ve Rehber',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.all(AppTheme.containerMargin),
            child: Container(
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
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Yardım konularında ara...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppTheme.lg),
                ),
              ),
            ),
          ),
          
          // Kategori Kartları
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                final category = _filteredCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _helpCategories;
    }
    
    return _helpCategories.where((category) {
      final titleMatch = category['title'].toString().toLowerCase().contains(_searchQuery);
      final descMatch = category['description'].toString().toLowerCase().contains(_searchQuery);
      final itemsMatch = (category['items'] as List).any((item) =>
          item['title'].toString().toLowerCase().contains(_searchQuery) ||
          item['content'].toString().toLowerCase().contains(_searchQuery));
      
      return titleMatch || descMatch || itemsMatch;
    }).toList();
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(AppTheme.lg),
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.sm),
          decoration: BoxDecoration(
            color: category['color'] as Color,
            borderRadius: BorderRadius.circular(AppTheme.sm),
          ),
          child: Icon(
            category['icon'] as IconData,
            color: _getIconColor(category['color'] as Color),
            size: 24,
          ),
        ),
        title: Text(
          category['title'] as String,
          style: AppTheme.labelLarge,
        ),
        subtitle: Text(
          category['description'] as String,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              children: (category['items'] as List).map((item) {
                return _buildHelpItem(item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'] as String,
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            item['content'] as String,
            style: AppTheme.bodyMedium,
          ),
          if (item['type'] == 'button') ...[
            const SizedBox(height: AppTheme.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _handleAction(item['action'] as String),
                child: Text(item['action'] as String),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getIconColor(Color bgColor) {
    if (bgColor == AppTheme.primaryContainer) return AppTheme.primary;
    if (bgColor == AppTheme.secondaryContainer) return AppTheme.secondary;
    if (bgColor == AppTheme.tertiaryContainer) return AppTheme.tertiary;
    if (bgColor == AppTheme.errorContainer) return AppTheme.error;
    return AppTheme.onSurface;
  }

  void _handleAction(String action) {
    switch (action) {
      case 'Geri Bildirim Gönder':
        _showFeedbackDialog();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$action işlemi gerçekleştiriliyor...'),
            backgroundColor: AppTheme.primary,
          ),
        );
    }
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Geri Bildirim Gönder',
          style: AppTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uygulamayı daha iyi hale getirmemize yardımcı olun!',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.md),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Geri bildiriminizi buraya yazın...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Geri bildiriminiz için teşekkürler!'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }
}

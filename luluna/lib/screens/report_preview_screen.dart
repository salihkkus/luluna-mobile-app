import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Raporun arkası gri/mavi tonunda olsun
      appBar: AppBar(
        title: const Text('Rapor Önizleme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Raporu Paylaş',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rapor paylaşım menüsü açılıyor...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'PDF Olarak İndir',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rapor PDF olarak cihazınıza kaydedildi.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4), // A4 kağıdı hissi için düşük radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rapor Başlığı (Header)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.child_care,
                          size: 32,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'LULUNA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'AYLIK GELİŞİM\nRAPORU',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1.5),
              const SizedBox(height: 20),
              
              // Öğrenci Bilgileri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow('Öğrenci', 'Ali Yılmaz'),
                  _buildInfoRow('Tarih', '10 Mayıs 2026'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow('Yaş Grubu', '4-6 Yaş'),
                  _buildInfoRow('Değerlendirme', 'Aylık Periyodik'),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // 1. Gelişim Özeti
              _buildSectionTitle('1. GENEL GELİŞİM ÖZETİ'),
              const Text(
                'Ali bu ayki etkileşimlerinde nesne tanıma ve renk eşleştirme konularında olağanüstü bir performans sergilemiştir. Luluna ile yaptığı sesli sohbetlerde kelime dağarcığını aktif olarak kullandığı gözlemlenmiştir. Komutlara yanıt verme hızı önceki aya göre %15 artış göstermiştir.',
                style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
              ),
              
              const SizedBox(height: 36),
              
              // 2. İstatistikler
              _buildSectionTitle('2. PERFORMANS İSTATİSTİKLERİ'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatBox('Tespit', '156', AppTheme.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatBox('Doğruluk', '%85', AppTheme.secondary)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatBox('Süre (Dk)', '340', const Color(0xFFFFB74D))),
                ],
              ),
              
              const SizedBox(height: 36),
              
              // 3. Güçlü Yönler & Gelişim Alanları
              _buildSectionTitle('3. BECERİ ANALİZİ'),
              const SizedBox(height: 16),
              _buildSkillRow('Görsel Algı ve Tanıma', 0.92),
              _buildSkillRow('Renk ve Şekil Eşleştirme', 0.85),
              _buildSkillRow('Sözel İfade ve İletişim', 0.70),
              _buildSkillRow('Odaklanma Süresi', 0.60),

              const SizedBox(height: 40),
              
              // 4. Luluna AI Notu
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.05),
                  border: const Border(left: BorderSide(color: AppTheme.primary, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: AppTheme.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Luluna AI Notu',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 15,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '"Ali, hayvanları tanıma konusunda çok yetenekli ve öğrenmeye oldukça hevesli! Sözel ifadelerini güçlendirmek ve odaklanma süresini artırmak için Müzik Dünyası ve Hikaye Zamanı aktivitelerine biraz daha fazla zaman ayırmanızı tavsiye ederim."',
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, height: 1.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // İmza / Alt Bilgi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text(
                      'Bu belge Luluna Yapay Zeka Motoru tarafından kullanım istatistikleri baz alınarak otomatik olarak oluşturulmuştur.',
                      style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.4),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified, color: Colors.green, size: 28),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Onaylı Sistem Raporu',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppTheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String skill, double percent) {
    Color progressColor = percent > 0.8 ? Colors.green : (percent > 0.6 ? Colors.orange : Colors.red);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              skill,
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: Colors.grey[200],
                      color: progressColor,
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 36,
                  child: Text(
                    '%${(percent * 100).toInt()}',
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                    textAlign: TextAlign.right,
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

<div align="center">
  <img src="luluna/assets/models/luluna.png" alt="Luluna Logo" width="150" height="150"/>
  <h1>🌙 Luluna</h1>
  <p><b>Gözleriyle Keşfeden Çocuklar İçin Yapay Zeka Destekli Sosyal İletişim Asistanı</b></p>
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google&logoColor=white" alt="Gemini AI" />
    <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
  </p>
</div>

<hr/>

## 🚀 Projenin Amacı ve Vizyonu

**Luluna**, otizm spektrumundaki çocukların günlük yaşamda karşılaştıkları sosyal iletişim bariyerlerini aşmalarına yardımcı olan, gerçek zamanlı nesne tespiti, yapay zeka destekli sesli sohbet ve etkileşimli oyunlaştırma sunan yenilikçi bir mobil uygulamadır.

- **Problem:** Günlük hayatta stres, kalabalık ve sosyal etkileşim problemleri nedeniyle çocukların çevreleriyle iletişim kurmakta zorlanması.
- **Çözüm:** Gerçek zamanlı çevre analizi yaparak çocuklara sesli ve görsel sosyal yönlendirmeler sunan, şefkatli bir dijital asistan sistemi.
- **Vizyon:** Gelecekte akıllı gözlük teknolojilerine entegre olabilecek, erişilebilir ve kapsayıcı bir sosyal asistan ekosistemi oluşturmak.

---

## ✨ Temel Özellikler

### 👧👦 Çocuk Dostu Arayüz (Child Mode)
- **Luluna Sesli Asistan (Voice Chat):** Gelişmiş Multimodal Yapay Zeka (Gemini Vision) sayesinde çocuk, kameradaki nesneler hakkında Luluna ile sesli olarak konuşabilir. Model, otizm dostu, sıcak, basit ve destekleyici pedagojik cevaplar üretir.
- **Gerçek Zamanlı Nesne Tespiti (Vision AI):** Cihaz kamerası kullanılarak çevre analiz edilir, çocuğun dünyayı keşfetmesi sağlanır.
- **Etkileşimli Oyunlaştırma:** Tespit edilen nesneler üzerinden "Bu ne renk?", "Bu nesne ne işe yarar?" gibi pedagojik sesli mini testler sunulur.
- **Duyusal Dostu Tasarım:** Otizmli çocukların odaklanmasını ve sakin kalmasını kolaylaştıran minimalist UI/UX, pastel renkler ve yumuşak geçişli lottie animasyonları.

### 👪 Ebeveyn Paneli (Parent Dashboard)
- **Güvenli Erişim:** PIN korumalı giriş sistemi sayesinde çocukların ayarlara erişimi engellenir.
- **Öğrenme ve Gelişim Raporları:** Çocuğun uygulamadaki etkileşim verilerine dayalı, yapay zeka destekli dinamik gelişim içgörüleri ve uyarı kartları.
- **Detaylı Rapor Önizleme:** Terapistlerle paylaşılabilecek resmi formatlı, indirilebilir/yazdırılabilir gelişim raporları.
- **Kapsamlı İzin Yönetimi (Consent Management):** Uluslararası veri transferi onayları ve gizlilik politikalarının tam kontrolü.

---

## 📸 Ekran Görüntüleri

Projemizin arayüzüne dair görselleri aşağıdan inceleyebilirsiniz:

<div align="center">
  <table style="border: none;">
    <tr>
      <td align="center"><b>Profil Seçimi</b></td>
      <td align="center"><b>Çocuk Paneli</b></td>
      <td align="center"><b>Kamera & Sohbet</b></td>
    </tr>
    <tr>
      <td><img src="luluna/foto/profil.jpeg" alt="Profil Seçimi" width="250"/></td>
      <td><img src="luluna/foto/velet.jpeg" alt="Çocuk Paneli" width="250"/></td>
      <td><img src="luluna/foto/foto%20çek.jpeg" alt="Kamera & Sohbet" width="250"/></td>
    </tr>
    <tr>
      <td align="center"><b>Eğitici Test</b></td>
      <td align="center"><b>Ebeveyn Raporu</b></td>
      <td align="center"><b>İzin ve Gizlilik</b></td>
    </tr>
    <tr>
      <td><img src="luluna/foto/test.jpeg" alt="Eğitici Test" width="250"/></td>
      <td><img src="luluna/foto/rapor.jpeg" alt="Ebeveyn Raporu" width="250"/></td>
      <td><img src="luluna/foto/izin.jpeg" alt="İzin ve Gizlilik" width="250"/></td>
    </tr>
  </table>
</div>

---

## 🛠 Teknoloji Yığını

| Katman | Teknoloji / Paket | Açıklama |
| :--- | :--- | :--- |
| **Mobil Uygulama** | Flutter & Dart | Çapraz platform, performanslı mobil arayüz geliştirme |
| **Yapay Zeka (AI)** | Google Gemini / Vision | Multimodal iletişim (Görüntü + Ses) ve içerik oluşturma |
| **Kamera & Görüş** | `camera`, `image_picker` | Canlı kamera akışı ve nesne tespiti |
| **Ses Mimarisi** | `flutter_tts`, `speech_to_text` | Ses tanıma ve metinden sese dönüştürme (şefkatli asistan sesi) |
| **Veri Depolama** | `sqflite`, `path_provider` | Uygulama içi yerel veritabanı, profil ve rapor yönetimi |
| **UI/UX & Animasyon** | `lottie`, `google_fonts` | Sakinleştirici animasyonlar ve modern tipografi |

---

## 🏗 Mimari ve Proje Yapısı

Proje modüler ve sürdürülebilir bir Flutter mimarisine sahiptir:
- `lib/screens/`: Uygulamanın tüm kullanıcı arayüzü sayfalarını içerir (Kamera, Veli Paneli, Oyunlar, Profil Seçimi vb.)
- `lib/services/`: İş mantığı, dış API bağlantıları ve veritabanı servislerini barındırır (`vision_service.dart`, `detection_service.dart`, `database_service.dart`).
- `lib/theme/`: Uygulamanın duyusal dostu (sensory-friendly) renk paletleri, fontları ve tasarım kurallarını merkezi olarak yönetir.
- `lib/config/`: Sabitler ve genel uygulama ayarları.

---

## 👥 Geliştirici Ekibi

- **Salih Karakuş:** Mobil Uygulama Geliştirme (Düzce Üniversitesi Bilgisayar Mühendisliği)

---

<div align="center">
  <p><i>Bu proje, otizmli bireylerin hayatına dokunmak ve sosyal engelleri teknolojinin gücüyle aşmak amacıyla sevgiyle geliştirilmiştir. 💙</i></p>
</div>

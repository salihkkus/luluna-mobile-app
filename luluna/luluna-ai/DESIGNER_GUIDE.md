# 🎨 Tasarımcı Rehberi

## Genel Bakış

Bu proje **3 katmandan** oluşuyor:
1. **Backend (AI Köprüsü)** - Taha'nın sorumluluğu ✅
2. **Servis Katmanı (Flutter)** - Hazır, kullanıma hazır ✅
3. **UI/Tasarım Katmanı (Flutter)** - Senin yapacağın kısım 🎨

---

## Senin Yapman Gerekenler

### ✅ Hazır Olanlar (Dokunma!)

- `lib/services/vision_service.dart` - AI ile iletişim servisi
- `lib/services/training_service.dart` - AI eğitim servisi
- `.env` dosyası - API ayarları
- `pubspec.yaml` - Paket bağımlılıkları

### 🎨 Senin Yapacağın Kısım

- **UI/UX Tasarımı** - Ekranlar, butonlar, renkler, animasyonlar
- **Kullanıcı Deneyimi** - Otizmli çocuklar için özel tasarım
- **Görsel Öğeler** - İkonlar, resimler, ses efektleri

---

## Servis Kullanımı (Çok Basit!)

### 1. Kameradan Fotoğraf Çek ve Analiz Et

```dart
import 'package:autism_vision_app/services/vision_service.dart';

final visionService = VisionService();

// Kameradan analiz
String result = await visionService.analyzeFromCamera();
print(result); // "Bu bir kedi. Kedi pencerede oturuyor."
```

### 2. Galeriden Fotoğraf Seç ve Analiz Et

```dart
// Galeriden analiz
String result = await visionService.analyzeFromGallery();
print(result); // "Bu bir köpek. Köpek parkta oynuyor."
```

### 3. Geliştirici Modunu Kontrol Et

```dart
// Geliştirici modu aktif mi?
bool isDev = VisionService.isDeveloperMode;

// Geliştirici kodunu kontrol et
bool activated = VisionService.checkDeveloperMode('//81//');
```

**O KADAR!** Backend ile iletişim, hata yönetimi, dil algılama, timeout, her şey hazır.

---

## Örnek Widget Yapısı

### Basit Örnek

```dart
import 'package:flutter/material.dart';
import 'package:autism_vision_app/services/vision_service.dart';

class MyCustomScreen extends StatefulWidget {
  @override
  State<MyCustomScreen> createState() => _MyCustomScreenState();
}

class _MyCustomScreenState extends State<MyCustomScreen> {
  final VisionService _visionService = VisionService();
  String _result = '';
  bool _isLoading = false;

  Future<void> _analyze() async {
    setState(() => _isLoading = true);
    
    // Servisi çağır - o kadar basit!
    final result = await _visionService.analyzeFromCamera();
    
    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Senin tasarımın buraya
          Text(_result),
          
          ElevatedButton(
            onPressed: _isLoading ? null : _analyze,
            child: Text('Fotoğraf Çek'),
          ),
        ],
      ),
    );
  }
}
```

---

## Tasarım Önerileri (Otizmli Çocuklar İçin)

### 🎨 Renkler
- ✅ Parlak, canlı renkler kullan
- ✅ Yüksek kontrast (kolay okunabilir)
- ❌ Pastel veya soluk renkler kullanma

### 🔘 Butonlar
- ✅ Büyük butonlar (kolay dokunma)
- ✅ Net ikonlar
- ✅ Görsel feedback (animasyon, ses)

### 📝 Yazılar
- ✅ Büyük fontlar (18px+)
- ✅ Basit, kısa cümleler
- ✅ Emoji kullanabilirsin 😊

### 🎵 Ses ve Animasyon
- ✅ Pozitif ses efektleri
- ✅ Yumuşak animasyonlar
- ❌ Ani, sert hareketler yapma

### 🖼️ Görseller
- ✅ Gerçek fotoğraflar kullan
- ✅ Basit, net görseller
- ❌ Karmaşık, kalabalık görseller

---

## Proje Yapısı

```
lib/
├── services/              # ✅ HAZIR - Dokunma!
│   ├── vision_service.dart
│   └── training_service.dart
│
├── screens/               # 🎨 Senin alanın
│   ├── home_screen.dart   # Örnek ekran (silebilirsin)
│   └── training_screen.dart # Geliştirici ekranı (silebilirsin)
│
├── widgets/               # 🎨 Senin oluşturacağın widgetlar
│   ├── custom_button.dart
│   ├── result_card.dart
│   └── ...
│
├── theme/                 # 🎨 Senin tema ayarların
│   ├── colors.dart
│   ├── text_styles.dart
│   └── ...
│
└── main.dart             # 🎨 Ana dosya - istediğin gibi düzenle
```

---

## Mevcut Örnek Ekranlar

### `lib/screens/home_screen.dart`
- Basit bir örnek ekran
- Kamera ve galeri butonları var
- İstersen kullan, istersen sil ve kendi tasarımını yap

### `lib/screens/training_screen.dart`
- Geliştirici modu ekranı
- AI eğitim paneli
- Müşteri görmeyecek, sadece geliştirme için

**İstersen ikisini de sil ve sıfırdan başla!**

---

## Hızlı Başlangıç

### 1. Paketleri Yükle
```bash
flutter pub get
```

### 2. Örnek Ekranı Çalıştır
```bash
flutter run
```

### 3. Kendi Tasarımını Yap
- `lib/screens/` klasöründe yeni ekranlar oluştur
- `lib/widgets/` klasöründe özel widgetlar yap
- `lib/main.dart` dosyasını düzenle

---

## API Testi

Backend hazır değilse, test için mock data kullanabilirsin:

```dart
// vision_service.dart içinde _sendToBackend fonksiyonunu geçici olarak değiştir:

Future<String> _sendToBackend(String base64Image, String language) async {
  // Test için mock data
  await Future.delayed(Duration(seconds: 2)); // Yapay gecikme
  return "Bu bir test yanıtı. Backend hazır olunca gerçek yanıt gelecek.";
}
```

---

## Sık Sorulan Sorular

### Backend hazır değilse ne yapmalıyım?
Mock data kullan (yukarıdaki örnek). Backend hazır olunca otomatik çalışacak.

### Servisleri nasıl test ederim?
```bash
flutter test
```

### Yeni bir ekran nasıl eklerim?
1. `lib/screens/my_screen.dart` oluştur
2. `VisionService()` kullan
3. `main.dart`'ta route ekle

### Hata alırsam ne yapmalıyım?
1. `flutter clean` çalıştır
2. `flutter pub get` çalıştır
3. Uygulamayı yeniden başlat

---

## İletişim

- Backend/API sorunları → Taha
- Tasarım/UI sorunları → Sen halledersin 🎨
- Flutter/Dart sorunları → Birlikte çözeriz

---

## Önemli Notlar

1. **Servislere dokunma!** Sadece kullan.
2. **`.env` dosyasını Git'e ekleme!** (Zaten .gitignore'da)
3. **Otizmli çocuklar için tasarla!** Basit, renkli, eğlenceli.
4. **Test et!** Gerçek cihazda test etmeyi unutma.

İyi çalışmalar! 🚀

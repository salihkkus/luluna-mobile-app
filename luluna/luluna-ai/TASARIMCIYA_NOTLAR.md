# 📝 Tasarımcıya Notlar

## 🎯 Proje Özeti

Bu proje **otizmli çocuklar** için görsel tanıma uygulaması. Backend hazır, sadece UI/UX tasarımı bekleniyor.

---

## 📁 Dosya Yapısı (Basit ve Temiz)

```
luluna/
├── lib/
│   ├── services/
│   │   ├── vision_service.dart      ✅ HAZIR - Dokunma!
│   │   └── training_service.dart    ✅ HAZIR - Dokunma!
│   └── main.dart                    🎨 Buradan başla
│
├── .env                             🔐 API ayarları (gizli)
├── .env.example                     📄 Örnek ayarlar
├── pubspec.yaml                     📦 Paketler
├── DESIGNER_GUIDE.md                📖 ÖNCE BUNU OKU!
└── README.md                        📖 Genel bilgi
```

---

## ✅ Hazır Olanlar (Dokunma!)

### 1. Vision Service (`lib/services/vision_service.dart`)
- Kameradan fotoğraf çekme
- Galeriden fotoğraf seçme
- Görseli AI'ya gönderme
- Sonucu alma

**Kullanımı:**
```dart
import 'package:autism_vision_app/services/vision_service.dart';

final visionService = VisionService();

// Kameradan
String result = await visionService.analyzeFromCamera();

// Galeriden
String result = await visionService.analyzeFromGallery();
```

### 2. Training Service (`lib/services/training_service.dart`)
- AI eğitim sistemi (opsiyonel)
- Geliştirici modu için

---

## 🎨 Senin Yapacakların

### 1. Ekranlar Oluştur
`lib/screens/` klasörü oluştur ve ekranlarını yap:
- Ana ekran
- Sonuç ekranı
- Ayarlar ekranı (opsiyonel)

### 2. Widgetlar Oluştur
`lib/widgets/` klasörü oluştur:
- Özel butonlar
- Kart widgetları
- vb.

### 3. Tema Oluştur
`lib/theme/` klasörü oluştur:
- Renkler
- Font stilleri
- vb.

---

## 🎨 Tasarım Kuralları (Otizm İçin)

### Renkler
- ✅ Parlak, canlı renkler
- ✅ Yüksek kontrast
- ❌ Pastel renkler

### Butonlar
- ✅ Büyük butonlar (kolay dokunma)
- ✅ Net ikonlar
- ✅ Görsel feedback

### Yazılar
- ✅ Büyük fontlar (18px+)
- ✅ Basit, kısa cümleler
- ✅ Emoji kullanabilirsin 😊

### Animasyonlar
- ✅ Yumuşak animasyonlar
- ❌ Ani, sert hareketler

---

## 🚀 Başlamak İçin

### 1. Paketleri Yükle
```bash
flutter pub get
```

### 2. DESIGNER_GUIDE.md'yi Oku
Tüm detaylar orada!

### 3. main.dart'ı Düzenle
Kendi ekranlarını ekle

### 4. Test Et
```bash
flutter run
```

---

## 📞 Sorular?

- **Backend/API sorunları:** Taha'ya sor
- **Servis kullanımı:** `DESIGNER_GUIDE.md`'ye bak
- **Flutter/Dart sorunları:** Birlikte çözeriz

---

## ⚠️ Önemli Notlar

1. **Servislere dokunma!** Sadece kullan.
2. **`.env` dosyasını Git'e ekleme!**
3. **Otizmli çocuklar için tasarla!**
4. **Gerçek cihazda test et!**

---

## 🎉 Başarılar!

Sorularını çekinmeden sor. İyi çalışmalar! 🚀

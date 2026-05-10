# 🧩 Otizm Görsel Tanıma Uygulaması

Flutter ile geliştirilmiş, otizmli çocuklar için görsel tanıma uygulaması.

---

## 📁 Proje Yapısı

```
luluna/
├── lib/
│   ├── services/          # ✅ HAZIR - Dokunma!
│   │   ├── vision_service.dart      # AI ile iletişim
│   │   └── training_service.dart    # AI eğitim (opsiyonel)
│   └── main.dart          # 🎨 Tasarımcı buradan başlayacak
│
├── .env                   # API ayarları (GİZLİ)
├── .env.example           # Örnek ayarlar
├── pubspec.yaml           # Paket bağımlılıkları
├── DESIGNER_GUIDE.md      # 🎨 TASARIMCI REHBERİ - ÖNEMLİ!
└── README.md              # Bu dosya
```

---

## 🚀 Hızlı Başlangıç

### 1. .env Dosyasını Oluştur

```bash
cp .env.example .env
```

`.env` dosyasını aç ve API bilgilerini gir:

```env
API_BASE_URL=http://192.168.1.100:8000
API_KEY=your_api_key_here
```

### 2. Paketleri Yükle

```bash
flutter pub get
```

### 3. Çalıştır

```bash
flutter run
```

---

## 👥 Roller

### Backend Geliştirici (Taha)
- ✅ AI servisi hazır
- ✅ Vision service hazır
- ✅ Training service hazır
- ✅ API entegrasyonu hazır

### Tasarımcı
- 🎨 UI/UX tasarımı yapacak
- 🎨 Ekranları oluşturacak
- 🎨 Widgetları tasarlayacak

**Tasarımcı için:** `DESIGNER_GUIDE.md` dosyasını oku!

---

## 📦 Kullanılan Paketler

- `image_picker` - Kamera ve galeri erişimi
- `http` - API istekleri
- `image` - Görsel işleme
- `flutter_dotenv` - Environment variables

---

## 🔐 Güvenlik

⚠️ `.env` dosyası hassas bilgiler içerir!
- ❌ Git'e ekleme
- ❌ Paylaşma
- ✅ `.gitignore`'da zaten var

---

## 📞 İletişim

- **Backend/API:** Taha
- **Tasarım/UI:** Tasarımcı
- **Sorular:** `DESIGNER_GUIDE.md` dosyasına bak

---

## 📄 Lisans

MIT License

# 🧩 Otizm Görsel Tanıma Uygulaması

Flutter ile geliştirilmiş, otizmli çocuklar için görsel tanıma uygulaması.

---

## 📁 Proje Yapısı

```
luluna/
├── lib/
│   ├── config/            # AI Prompt ayarları
│   ├── providers/         # AI API Providerları (Gemini, Claude vs.)
│   ├── services/          # ✅ HAZIR - Dokunma!
│   │   └── vision_service.dart      # AI ile iletişim
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

`.env` dosyasını aç ve AI sağlayıcısı ayarlarını gir:

```env
AI_PROVIDER=gemini
GEMINI_API_KEY=your_gemini_api_key_here
# Veya Claude, OpenAI, Cloudflare (LLaVA) keyleri...
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

### Backend Geliştirici
- ✅ Provider mimarisi hazır
- ✅ Vision service hazır
- ✅ AI entegrasyonu hazır

### UI/UX Tasarımcı
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

- **Backend/API:** Backend Ekibi
- **Tasarım/UI:** Tasarım Ekibi
- **Sorular:** `DESIGNER_GUIDE.md` dosyasına bak

---

## 📄 Lisans

MIT License

import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../providers/ai_provider.dart';
import '../providers/provider_factory.dart';

/// Otizmli çocuklar için görsel tanıma servisi.
/// Singleton pattern — uygulama boyunca tek instance çalışır.
///
/// Kullanım:
///   final result = await VisionService().analyzeFromCamera();
///   final result = await VisionService().analyzeFromGallery();
class VisionService {
  // Singleton
  static final VisionService _instance = VisionService._internal();
  factory VisionService() => _instance;
  VisionService._internal();

  // Geliştirici modu — .env'den başlangıç değeri, UI'dan toggle edilebilir
  static bool _isDeveloperMode =
      dotenv.env['DEVELOPER_MODE']?.toLowerCase() == 'true';

  static bool get isDeveloperMode => _isDeveloperMode;

  /// Geliştirici modunu aç
  static void enableDeveloperMode() => _isDeveloperMode = true;

  /// Geliştirici modunu kapat (çocuk güvenli moda dön)
  static void disableDeveloperMode() => _isDeveloperMode = false;

  // Görsel işleme parametreleri
  static const int maxImageWidth = 800;
  static const int jpegQuality = 70;

  // Desteklenen diller
  static const List<String> supportedLanguages = [
    'tr', 'en', 'de', 'fr', 'ar', 'es'
  ];

  final ImagePicker _picker = ImagePicker();

  // AI provider — .env'deki AI_PROVIDER'a göre otomatik seçilir
  final AIProvider _provider = ProviderFactory.create();

  // ----------------------------------------------------------------
  // PUBLIC API
  // ----------------------------------------------------------------

  /// Kameradan fotoğraf çeker ve AI ile analiz eder.
  Future<String> analyzeFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo == null) return _getLocalizedError('cancelled');
      return await _processAndAnalyzeImage(photo.path);
    } catch (e) {
      return _getLocalizedError('camera_error');
    }
  }

  /// Galeriden fotoğraf seçer ve AI ile analiz eder.
  Future<String> analyzeFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) return _getLocalizedError('cancelled');
      return await _processAndAnalyzeImage(image.path);
    } catch (e) {
      return _getLocalizedError('gallery_error');
    }
  }

  // ----------------------------------------------------------------
  // PRIVATE — Görsel işleme
  // ----------------------------------------------------------------

  Future<String> _processAndAnalyzeImage(String imagePath) async {
    try {
      // Görseli oku
      final List<int> imageBytes = await File(imagePath).readAsBytes();

      // Decode et
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return _getLocalizedError('invalid_image');

      // Boyutlandır — max 800px genişlik
      if (image.width > maxImageWidth) {
        image = img.copyResize(image, width: maxImageWidth);
      }

      // JPEG'e çevir — %70 kalite
      final List<int> resizedBytes =
          img.encodeJpg(image, quality: jpegQuality);

      // Base64'e çevir
      final String base64Image = base64Encode(resizedBytes);

      // Cihaz dilini algıla
      final String language = _getDeviceLanguage();

      // AI provider'a gönder
      return await _provider.analyzeImage(
        base64Image: base64Image,
        language: language,
        isDeveloperMode: _isDeveloperMode,
      );
    } catch (e) {
      return _getLocalizedError('processing_error');
    }
  }

  // ----------------------------------------------------------------
  // PRIVATE — Yardımcı fonksiyonlar
  // ----------------------------------------------------------------

  String _getDeviceLanguage() {
    try {
      final String code =
          ui.PlatformDispatcher.instance.locale.languageCode;
      return supportedLanguages.contains(code) ? code : 'en';
    } catch (_) {
      return 'en';
    }
  }

  String _getLocalizedError(String errorType) {
    final String language = _getDeviceLanguage();

    const Map<String, Map<String, String>> errors = {
      'tr': {
        'cancelled': 'İşlem iptal edildi.',
        'camera_error':
            'Kamera açılamadı. Lütfen kamera izinlerini kontrol edin.',
        'gallery_error':
            'Galeri açılamadı. Lütfen galeri izinlerini kontrol edin.',
        'invalid_image': 'Geçersiz görsel formatı.',
        'processing_error': 'Görsel işlenirken hata oluştu.',
        'network_error':
            'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.',
        'timeout': 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.',
        'server_error':
            'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.',
        'unknown_error':
            'Şu an bu görseli göremiyorum. Lütfen tekrar dene. 🙈',
      },
      'en': {
        'cancelled': 'Operation cancelled.',
        'camera_error':
            'Cannot open camera. Please check camera permissions.',
        'gallery_error':
            'Cannot open gallery. Please check gallery permissions.',
        'invalid_image': 'Invalid image format.',
        'processing_error': 'Error occurred while processing image.',
        'network_error':
            'No internet connection. Please check your connection.',
        'timeout': 'Request timed out. Please try again.',
        'server_error': 'Server error. Please try again later.',
        'unknown_error':
            'I cannot see this picture right now. Please try again. 🙈',
      },
      'de': {
        'cancelled': 'Vorgang abgebrochen.',
        'camera_error':
            'Kamera kann nicht geöffnet werden. Bitte Kameraberechtigungen prüfen.',
        'gallery_error':
            'Galerie kann nicht geöffnet werden. Bitte Galerieberechtigungen prüfen.',
        'invalid_image': 'Ungültiges Bildformat.',
        'processing_error': 'Fehler beim Verarbeiten des Bildes.',
        'network_error':
            'Keine Internetverbindung. Bitte Verbindung prüfen.',
        'timeout': 'Zeitüberschreitung. Bitte erneut versuchen.',
        'server_error': 'Serverfehler. Bitte später erneut versuchen.',
        'unknown_error':
            'Ich kann dieses Bild gerade nicht sehen. Bitte erneut versuchen. 🙈',
      },
      'fr': {
        'cancelled': 'Opération annulée.',
        'camera_error':
            'Impossible d\'ouvrir la caméra. Vérifiez les autorisations.',
        'gallery_error':
            'Impossible d\'ouvrir la galerie. Vérifiez les autorisations.',
        'invalid_image': 'Format d\'image invalide.',
        'processing_error': 'Erreur lors du traitement de l\'image.',
        'network_error':
            'Pas de connexion Internet. Vérifiez votre connexion.',
        'timeout': 'Délai dépassé. Veuillez réessayer.',
        'server_error': 'Erreur serveur. Veuillez réessayer plus tard.',
        'unknown_error':
            'Je ne peux pas voir cette image pour le moment. 🙈',
      },
      'ar': {
        'cancelled': 'تم إلغاء العملية.',
        'camera_error': 'لا يمكن فتح الكاميرا. يرجى التحقق من الأذونات.',
        'gallery_error': 'لا يمكن فتح المعرض. يرجى التحقق من الأذونات.',
        'invalid_image': 'تنسيق صورة غير صالح.',
        'processing_error': 'حدث خطأ أثناء معالجة الصورة.',
        'network_error': 'لا يوجد اتصال بالإنترنت.',
        'timeout': 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.',
        'server_error': 'خطأ في الخادم. يرجى المحاولة لاحقاً.',
        'unknown_error': 'لا أستطيع رؤية هذه الصورة الآن. 🙈',
      },
      'es': {
        'cancelled': 'Operación cancelada.',
        'camera_error':
            'No se puede abrir la cámara. Verifica los permisos.',
        'gallery_error':
            'No se puede abrir la galería. Verifica los permisos.',
        'invalid_image': 'Formato de imagen no válido.',
        'processing_error': 'Error al procesar la imagen.',
        'network_error': 'Sin conexión a Internet.',
        'timeout': 'Tiempo de espera agotado. Inténtalo de nuevo.',
        'server_error': 'Error del servidor. Inténtalo más tarde.',
        'unknown_error': 'No puedo ver esta imagen ahora. 🙈',
      },
    };

    return errors[language]?[errorType] ??
        errors['en']![errorType] ??
        errors['en']!['unknown_error']!;
  }
}

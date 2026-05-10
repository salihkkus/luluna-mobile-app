import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import '../config/ai_prompts.dart';

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


  // ----------------------------------------------------------------
  // PUBLIC API
  // ----------------------------------------------------------------

  /// Kameradan fotoğraf çeker ve AI ile analiz eder.
  Future<String> analyzeFromCamera() async {
    print('📸 VisionService: Kameradan analiz başladı');
    try {
      print('📷 Kamera açılıyor...');
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo == null) {
        print('❌ Kamera: Fotoğraf çekilmedi');
        return _getLocalizedError('cancelled');
      }
      print('✅ Kamera: Fotoğraf çekildi - ${photo.path}');
      print('📁 Dosya boyutu: ${await File(photo.path).length()} bytes');
      return await _processAndAnalyzeImage(photo.path);
    } catch (e) {
      print('💥 Kamera hatası: $e');
      print('💥 Hata tipi: ${e.runtimeType}');
      return _getLocalizedError('camera_error');
    }
  }

  /// Galeriden fotoğraf seçer ve AI ile analiz eder.
  Future<String> analyzeFromGallery() async {
    print('🖼️ VisionService: Galeriden analiz başladı');
    try {
      print('📂 Galeri açılıyor...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) {
        print('❌ Galeri: Görsel seçilmedi');
        return _getLocalizedError('cancelled');
      }
      print('✅ Galeri: Görsel seçildi - ${image.path}');
      print('📁 Dosya boyutu: ${await File(image.path).length()} bytes');
      return await _processAndAnalyzeImage(image.path);
    } catch (e) {
      print('💥 Galeri hatası: $e');
      print('💥 Hata tipi: ${e.runtimeType}');
      return _getLocalizedError('gallery_error');
    }
  }

  // ----------------------------------------------------------------
  // PRIVATE — Görsel işleme
  // ----------------------------------------------------------------

  Future<String> _processAndAnalyzeImage(String imagePath) async {
    print('🔄 VisionService: Görsel işleme başladı - $imagePath');
    try {
      // Görseli oku
      print('📁 Görsel dosyası okunuyor...');
      final Uint8List imageBytes = await File(imagePath).readAsBytes();
      print('📁 Görsel okundu - ${imageBytes.length} bytes');

      // Decode et
      print('🖼️ Görsel decode ediliyor...');
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        print('❌ Görsel decode edilemedi');
        return _getLocalizedError('invalid_image');
      }
      print('✅ Görsel decode edildi - ${image.width}x${image.height}');

      // Boyutlandır — max 800px genişlik
      if (image.width > maxImageWidth) {
        print('📏 Görsel boyutlandırılıyor...');
        image = img.copyResize(image, width: maxImageWidth);
        print('📏 Görsel boyutlandırıldı - ${image.width}x${image.height}');
      }

      // JPEG'e çevir — %70 kalite
      print('🗜️ JPEG encode ediliyor...');
      final List<int> resizedBytes =
          img.encodeJpg(image, quality: jpegQuality);
      print('🗜️ JPEG encode edildi - ${resizedBytes.length} bytes');

      // Base64'e çevir
      print('🔤 Base64 encode ediliyor...');
      final String base64Image = base64Encode(resizedBytes);
      print('🔤 Base64 encode edildi - ${base64Image.length} karakter');

      // Cihaz dilini algıla
      final String language = _getDeviceLanguage();
      print('🌍 Cihaz dili: $language');
      print('👨‍💻 Developer mode: $_isDeveloperMode');

      // Gemini API'ye gönder
      print('🤖 Gemini API çağrılıyor...');
      final String result = await _analyzeWithGemini(
        base64Image: base64Image,
        language: language,
        isDeveloperMode: _isDeveloperMode,
      );
      print('✅ Gemini API tamamlandı - sonuç: "$result"');
      print('✅ Sonuç length: ${result.length}');
      return result;
    } catch (e) {
      print('💥 Görsel işleme hatası: $e');
      print('💥 Hata tipi: ${e.runtimeType}');
      print('💥 Stack trace: ${StackTrace.current}');
      return _getLocalizedError('processing_error');
    }
  }

  // ----------------------------------------------------------------
  // PRIVATE — Yardımcı fonksiyonlar
  // ----------------------------------------------------------------

  Future<String> _analyzeWithGemini({
    required String base64Image,
    required String language,
    required bool isDeveloperMode,
  }) async {
    final String apiKey = (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
    final String model = (dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash').trim();
    final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';
    
    if (apiKey.isEmpty) {
      print('❌ GEMINI_API_KEY boş!');
      return 'API anahtarı eksik. Lütfen .env dosyasına GEMINI_API_KEY ekleyin.';
    }

    final String systemPrompt = isDeveloperMode
        ? AIPrompts.developerSystemPrompt
        : AIPrompts.getAutismPrompt(language);
    final String userPrompt = AIPrompts.getUserPrompt(language);

    final Map<String, dynamic> requestBody = {
      'system_instruction': {
        'parts': [{'text': systemPrompt}],
      },
      'contents': [
        {
          'parts': [
            {'text': userPrompt},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Image,
              },
            },
          ],
        }
      ],
      'generationConfig': {
        'maxOutputTokens': isDeveloperMode ? 500 : 100,
        'temperature': 0.4,
      },
    };

    print('📤 Request body oluşturuldu');
    
    final Map<String, dynamic> loggableRequest = jsonDecode(jsonEncode(requestBody));
    loggableRequest['contents'][0]['parts'][1]['inline_data']['data'] = '[BASE64 IMAGE DATA HIDDEN - Length: ${base64Image.length}]';
    
    print('\n====== GEMINI REQUEST BODY ======');
    print(const JsonEncoder.withIndent('  ').convert(loggableRequest));
    print('=================================\n');

    try {
      print('🌐 Gemini HTTP isteği gönderiliyor...');
      final http.Response response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      print('📥 Response status: ${response.statusCode}');
      
      print('\n====== GEMINI RESPONSE BODY ======');
      try {
        final parsedJson = jsonDecode(response.body);
        print(const JsonEncoder.withIndent('  ').convert(parsedJson));
      } catch (e) {
        print(response.body);
      }
      print('==================================\n');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
        }
        return 'AI yanıt formatı beklenmiyor.';
      } else {
        return 'API Hatası: ${response.statusCode} - Lütfen tekrar deneyin.';
      }
    } catch (e) {
      print('💥 Gemini Bağlantı hatası: $e');
      return 'Bağlantı hatası: $e. Lütfen internet bağlantınızı kontrol edin.';
    }
  }

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

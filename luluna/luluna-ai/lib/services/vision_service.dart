import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

/// Otizmli çocuklar için görsel tanıma servisi
/// Singleton pattern kullanarak tek instance ile çalışır
class VisionService {
  // Singleton instance
  static final VisionService _instance = VisionService._internal();
  
  factory VisionService() {
    return _instance;
  }
  
  VisionService._internal();

  // Backend API base URL - .env dosyasından okunur
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000';
  
  // API Key/Token - .env dosyasından okunur
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Geliştirici modu aktivasyon kodu
  static String get developerCode => dotenv.env['DEVELOPER_CODE'] ?? '//81//';
  
  // Geliştirici modu durumu (runtime'da değişebilir)
  static bool _isDeveloperMode = false;
  
  // Geliştirici modu getter
  static bool get isDeveloperMode => _isDeveloperMode;
  
  // Timeout süresi
  static const Duration requestTimeout = Duration(seconds: 15);
  
  // Görsel işleme parametreleri
  static const int maxImageWidth = 800;
  static const int jpegQuality = 70;
  
  // Desteklenen diller
  static const List<String> supportedLanguages = ['tr', 'en', 'de', 'fr', 'ar', 'es'];
  
  final ImagePicker _picker = ImagePicker();

  /// Geliştirici modunu kontrol eder ve aktif eder
  /// Kullanıcı doğru kodu girerse geliştirici modu aktif olur
  static bool checkDeveloperMode(String input) {
    if (input.trim() == developerCode) {
      _isDeveloperMode = true;
      return true;
    }
    return false;
  }
  
  /// Geliştirici modunu devre dışı bırakır
  static void disableDeveloperMode() {
    _isDeveloperMode = false;
  }
  
  /// Geliştirici modunu toggle eder
  static void toggleDeveloperMode() {
    _isDeveloperMode = !_isDeveloperMode;
  }

  /// Kameradan fotoğraf çeker ve analiz eder
  Future<String> analyzeFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (photo == null) {
        return _getLocalizedError('cancelled');
      }
      
      return await _processAndAnalyzeImage(photo.path);
    } catch (e) {
      return _getLocalizedError('camera_error');
    }
  }

  /// Galeriden fotoğraf seçer ve analiz eder
  Future<String> analyzeFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (image == null) {
        return _getLocalizedError('cancelled');
      }
      
      return await _processAndAnalyzeImage(image.path);
    } catch (e) {
      return _getLocalizedError('gallery_error');
    }
  }

  /// Görseli işler ve backend'e gönderir
  Future<String> _processAndAnalyzeImage(String imagePath) async {
    try {
      // Görseli oku
      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      
      // Görseli decode et
      img.Image? image = img.decodeImage(imageBytes);
      
      if (image == null) {
        return _getLocalizedError('invalid_image');
      }
      
      // Görseli resize et (max 800px genişlik)
      if (image.width > maxImageWidth) {
        image = img.copyResize(
          image,
          width: maxImageWidth,
        );
      }
      
      // JPEG formatına çevir ve kaliteyi ayarla
      final List<int> resizedBytes = img.encodeJpg(image, quality: jpegQuality);
      
      // Base64'e çevir
      final String base64Image = base64Encode(resizedBytes);
      
      // Cihazın sistem dilini algıla
      final String deviceLanguage = _getDeviceLanguage();
      
      // Backend'e gönder
      return await _sendToBackend(base64Image, deviceLanguage);
      
    } catch (e) {
      return _getLocalizedError('processing_error');
    }
  }

  /// Cihazın sistem dilini algılar
  String _getDeviceLanguage() {
    try {
      final String languageCode = ui.PlatformDispatcher.instance.locale.languageCode;
      
      // Desteklenen diller arasında var mı kontrol et
      if (supportedLanguages.contains(languageCode)) {
        return languageCode;
      }
      
      // Varsayılan dil: İngilizce
      return 'en';
    } catch (e) {
      return 'en';
    }
  }

  /// Backend API'ye POST isteği gönderir
  Future<String> _sendToBackend(String base64Image, String language) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/analyze');
      
      final Map<String, dynamic> requestBody = {
        'image_base64': base64Image,
        'mime_type': 'image/jpeg',
        'language': language,
        'developer_mode': _isDeveloperMode, // Geliştirici modu bilgisini gönder
      };
      
      // Headers - API Key varsa Authorization header'ı ekle
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      // API Key varsa header'a ekle
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
        // Alternatif olarak bazı servisler için:
        // headers['X-API-Key'] = apiKey;
      }
      
      final http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(requestTimeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Description alanını döndür
        if (responseData.containsKey('description')) {
          return responseData['description'] as String;
        } else {
          return _getLocalizedError('invalid_response');
        }
      } else {
        return _getLocalizedError('server_error');
      }
      
    } on http.ClientException catch (_) {
      return _getLocalizedError('network_error');
    } on TimeoutException catch (_) {
      return _getLocalizedError('timeout');
    } catch (e) {
      return _getLocalizedError('unknown_error');
    }
  }

  /// Cihaz diline göre yerelleştirilmiş hata mesajı döndürür
  String _getLocalizedError(String errorType) {
    final String language = _getDeviceLanguage();
    
    final Map<String, Map<String, String>> errorMessages = {
      'tr': {
        'cancelled': 'İşlem iptal edildi.',
        'camera_error': 'Kamera açılamadı. Lütfen kamera izinlerini kontrol edin.',
        'gallery_error': 'Galeri açılamadı. Lütfen galeri izinlerini kontrol edin.',
        'invalid_image': 'Geçersiz görsel formatı.',
        'processing_error': 'Görsel işlenirken hata oluştu.',
        'network_error': 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.',
        'timeout': 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.',
        'server_error': 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.',
        'invalid_response': 'Sunucudan geçersiz yanıt alındı.',
        'unknown_error': 'Şu an bu görseli göremiyorum. Lütfen tekrar dene.',
      },
      'en': {
        'cancelled': 'Operation cancelled.',
        'camera_error': 'Cannot open camera. Please check camera permissions.',
        'gallery_error': 'Cannot open gallery. Please check gallery permissions.',
        'invalid_image': 'Invalid image format.',
        'processing_error': 'Error occurred while processing image.',
        'network_error': 'No internet connection. Please check your connection.',
        'timeout': 'Request timed out. Please try again.',
        'server_error': 'Server error occurred. Please try again later.',
        'invalid_response': 'Invalid response received from server.',
        'unknown_error': 'I cannot see this picture right now. Please try again.',
      },
      'de': {
        'cancelled': 'Vorgang abgebrochen.',
        'camera_error': 'Kamera kann nicht geöffnet werden. Bitte überprüfen Sie die Kameraberechtigungen.',
        'gallery_error': 'Galerie kann nicht geöffnet werden. Bitte überprüfen Sie die Galerieberechtigungen.',
        'invalid_image': 'Ungültiges Bildformat.',
        'processing_error': 'Fehler beim Verarbeiten des Bildes.',
        'network_error': 'Keine Internetverbindung. Bitte überprüfen Sie Ihre Verbindung.',
        'timeout': 'Zeitüberschreitung der Anfrage. Bitte versuchen Sie es erneut.',
        'server_error': 'Serverfehler aufgetreten. Bitte versuchen Sie es später erneut.',
        'invalid_response': 'Ungültige Antwort vom Server erhalten.',
        'unknown_error': 'Ich kann dieses Bild gerade nicht sehen. Bitte versuchen Sie es erneut.',
      },
      'fr': {
        'cancelled': 'Opération annulée.',
        'camera_error': 'Impossible d\'ouvrir la caméra. Veuillez vérifier les autorisations de la caméra.',
        'gallery_error': 'Impossible d\'ouvrir la galerie. Veuillez vérifier les autorisations de la galerie.',
        'invalid_image': 'Format d\'image invalide.',
        'processing_error': 'Erreur lors du traitement de l\'image.',
        'network_error': 'Pas de connexion Internet. Veuillez vérifier votre connexion.',
        'timeout': 'Délai d\'attente de la requête dépassé. Veuillez réessayer.',
        'server_error': 'Erreur du serveur. Veuillez réessayer plus tard.',
        'invalid_response': 'Réponse invalide reçue du serveur.',
        'unknown_error': 'Je ne peux pas voir cette image pour le moment. Veuillez réessayer.',
      },
      'ar': {
        'cancelled': 'تم إلغاء العملية.',
        'camera_error': 'لا يمكن فتح الكاميرا. يرجى التحقق من أذونات الكاميرا.',
        'gallery_error': 'لا يمكن فتح المعرض. يرجى التحقق من أذونات المعرض.',
        'invalid_image': 'تنسيق صورة غير صالح.',
        'processing_error': 'حدث خطأ أثناء معالجة الصورة.',
        'network_error': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.',
        'timeout': 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.',
        'server_error': 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.',
        'invalid_response': 'تم تلقي استجابة غير صالحة من الخادم.',
        'unknown_error': 'لا أستطيع رؤية هذه الصورة الآن. يرجى المحاولة مرة أخرى.',
      },
      'es': {
        'cancelled': 'Operación cancelada.',
        'camera_error': 'No se puede abrir la cámara. Por favor, verifica los permisos de la cámara.',
        'gallery_error': 'No se puede abrir la galería. Por favor, verifica los permisos de la galería.',
        'invalid_image': 'Formato de imagen no válido.',
        'processing_error': 'Error al procesar la imagen.',
        'network_error': 'Sin conexión a Internet. Por favor, verifica tu conexión.',
        'timeout': 'Tiempo de espera agotado. Por favor, inténtalo de nuevo.',
        'server_error': 'Error del servidor. Por favor, inténtalo más tarde.',
        'invalid_response': 'Respuesta no válida recibida del servidor.',
        'unknown_error': 'No puedo ver esta imagen ahora. Por favor, inténtalo de nuevo.',
      },
    };
    
    // Dil için hata mesajlarını al
    final Map<String, String>? languageErrors = errorMessages[language];
    
    if (languageErrors != null && languageErrors.containsKey(errorType)) {
      return languageErrors[errorType]!;
    }
    
    // Varsayılan olarak İngilizce döndür
    return errorMessages['en']![errorType] ?? errorMessages['en']!['unknown_error']!;
  }
}

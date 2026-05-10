import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AI Eğitim Servisi
/// Otizmli çocuklar için AI'yı eğitmek ve feedback toplamak için kullanılır
class TrainingService {
  // Singleton instance
  static final TrainingService _instance = TrainingService._internal();
  
  factory TrainingService() {
    return _instance;
  }
  
  TrainingService._internal();

  // Backend URL
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  static const Duration requestTimeout = Duration(seconds: 10);

  /// Feedback gönder - AI'nın yanıtı doğru mu yanlış mı?
  /// 
  /// [imageBase64] - Analiz edilen görsel
  /// [aiResponse] - AI'nın verdiği yanıt
  /// [isCorrect] - Yanıt doğru mu? (true/false)
  /// [correctAnswer] - Eğer yanlışsa, doğru cevap ne olmalıydı?
  /// [feedbackType] - Feedback tipi: 'correct', 'incorrect', 'partial'
  /// [userComment] - Kullanıcı yorumu (opsiyonel)
  Future<bool> sendFeedback({
    required String imageBase64,
    required String aiResponse,
    required bool isCorrect,
    String? correctAnswer,
    String feedbackType = 'correct',
    String? userComment,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/feedback');
      
      final Map<String, dynamic> requestBody = {
        'image_base64': imageBase64,
        'ai_response': aiResponse,
        'is_correct': isCorrect,
        'correct_answer': correctAnswer,
        'feedback_type': feedbackType,
        'user_comment': userComment,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(requestTimeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Eğitim verisi gönder - Yeni örnekler ekle
  /// 
  /// [imageBase64] - Eğitim görseli
  /// [correctDescription] - Doğru açıklama
  /// [category] - Kategori (örn: 'hayvan', 'nesne', 'duygular')
  /// [difficulty] - Zorluk seviyesi (1-5)
  /// [tags] - Etiketler (örn: ['kedi', 'hayvan', 'evcil'])
  Future<bool> addTrainingData({
    required String imageBase64,
    required String correctDescription,
    required String category,
    int difficulty = 1,
    List<String>? tags,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/add');
      
      final Map<String, dynamic> requestBody = {
        'image_base64': imageBase64,
        'correct_description': correctDescription,
        'category': category,
        'difficulty': difficulty,
        'tags': tags ?? [],
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(requestTimeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Fine-tuning başlat - Toplanan verilerle AI'yı yeniden eğit
  /// 
  /// [datasetName] - Veri seti adı
  /// [epochs] - Eğitim epoch sayısı
  /// [learningRate] - Öğrenme oranı
  Future<Map<String, dynamic>?> startFineTuning({
    String datasetName = 'autism_vision_dataset',
    int epochs = 3,
    double learningRate = 0.0001,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/fine-tune');
      
      final Map<String, dynamic> requestBody = {
        'dataset_name': datasetName,
        'epochs': epochs,
        'learning_rate': learningRate,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Eğitim istatistiklerini getir
  Future<Map<String, dynamic>?> getTrainingStats() async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/stats');
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .get(uri, headers: headers)
          .timeout(requestTimeout);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Prompt şablonunu güncelle - AI'nın nasıl konuşacağını ayarla
  /// 
  /// [promptTemplate] - Yeni prompt şablonu
  /// [language] - Dil kodu
  Future<bool> updatePromptTemplate({
    required String promptTemplate,
    required String language,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/prompt');
      
      final Map<String, dynamic> requestBody = {
        'prompt_template': promptTemplate,
        'language': language,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(requestTimeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Veri setini dışa aktar (JSON formatında)
  Future<Map<String, dynamic>?> exportDataset() async {
    try {
      final Uri uri = Uri.parse('$baseUrl/training/export');
      
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
      
      final http.Response response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

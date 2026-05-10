import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../config/ai_prompts.dart';
import 'ai_provider.dart';

/// Google Gemini API implementasyonu.
/// Model veya endpoint değiştirmek için sadece bu dosyayı düzenleyin.
class GeminiProvider implements AIProvider {
  // Kullanılacak Gemini modeli (.env'den değiştirilebilir)
  static String get _model =>
      dotenv.env['GEMINI_MODEL'] ?? 'gemini-1.5-flash';

  // API Key .env'den okunur
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // API endpoint
  static String get _apiUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';

  static const Duration _timeout = Duration(seconds: 15);

  @override
  Future<String> analyzeImage({
    required String base64Image,
    required String language,
    required bool isDeveloperMode,
  }) async {
    // Moda göre sistem promptunu seç
    final String systemPrompt = isDeveloperMode
        ? AIPrompts.developerSystemPrompt
        : AIPrompts.getAutismPrompt(language);

    final String userPrompt = AIPrompts.getUserPrompt(language);

    // Gemini API request body formatı
    final Map<String, dynamic> requestBody = {
      'system_instruction': {
        'parts': [
          {'text': systemPrompt}
        ],
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
        // Geliştirici modunda daha uzun yanıt, çocuk modunda kısa
        'maxOutputTokens': isDeveloperMode ? 500 : 100,
        'temperature': 0.4,
      },
    };

    final http.Response response = await http
        .post(
          Uri.parse(_apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final String text =
          data['candidates'][0]['content']['parts'][0]['text'] as String;
      return text.trim();
    }

    throw Exception('Gemini API hatası: ${response.statusCode} — ${response.body}');
  }
}

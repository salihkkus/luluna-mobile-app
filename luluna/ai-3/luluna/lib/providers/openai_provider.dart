import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../config/ai_prompts.dart';
import 'ai_provider.dart';

/// OpenAI GPT-4o / GPT-4 Vision implementasyonu.
/// .env ayarları:
///   OPENAI_API_KEY=sk-...
///   OPENAI_MODEL=gpt-4o          (opsiyonel, varsayılan: gpt-4o)
class OpenAIProvider implements AIProvider {
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get _model => dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const Duration _timeout = Duration(seconds: 30);

  @override
  Future<String> analyzeImage({
    required String base64Image,
    required String language,
    required bool isDeveloperMode,
  }) async {
    final String systemPrompt = isDeveloperMode
        ? AIPrompts.developerSystemPrompt
        : AIPrompts.getAutismPrompt(language);

    final String userPrompt = AIPrompts.getUserPrompt(language);

    final Map<String, dynamic> requestBody = {
      'model': _model,
      'max_tokens': isDeveloperMode ? 500 : 100,
      'messages': [
        {
          'role': 'system',
          'content': systemPrompt,
        },
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': userPrompt},
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:image/jpeg;base64,$base64Image',
                'detail': 'low', // Token tasarrufu için
              },
            },
          ],
        },
      ],
    };

    final http.Response response = await http
        .post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return (data['choices'][0]['message']['content'] as String).trim();
    }

    throw Exception('OpenAI API hatası: ${response.statusCode} — ${response.body}');
  }
}

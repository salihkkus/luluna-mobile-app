import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../config/ai_prompts.dart';
import 'ai_provider.dart';

/// Anthropic Claude implementasyonu.
/// .env ayarları:
///   ANTHROPIC_API_KEY=sk-ant-...
///   ANTHROPIC_MODEL=claude-3-5-haiku-20241022   (opsiyonel)
class ClaudeProvider implements AIProvider {
  static String get _apiKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';
  static String get _model =>
      dotenv.env['ANTHROPIC_MODEL'] ?? 'claude-3-5-haiku-20241022';
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
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

    // Claude: image önce, text sonra gelir
    final Map<String, dynamic> requestBody = {
      'model': _model,
      'max_tokens': isDeveloperMode ? 500 : 100,
      'system': systemPrompt,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': base64Image,
              },
            },
            {
              'type': 'text',
              'text': userPrompt,
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
            'x-api-key': _apiKey,
            'anthropic-version': '2023-06-01',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return (data['content'][0]['text'] as String).trim();
    }

    throw Exception('Claude API hatası: ${response.statusCode} — ${response.body}');
  }
}

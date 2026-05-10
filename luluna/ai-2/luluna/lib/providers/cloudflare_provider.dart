import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../config/ai_prompts.dart';
import 'ai_provider.dart';

/// Cloudflare Workers AI implementasyonu.
/// LLaVA ve diğer Cloudflare vision modellerini destekler.
/// .env ayarları:
///   CLOUDFLARE_ACCOUNT_ID=...
///   CLOUDFLARE_API_TOKEN=...
///   CLOUDFLARE_MODEL=@cf/llava-hf/llava-1.5-7b-hf   (opsiyonel)
///
/// Desteklenen Cloudflare vision modelleri:
///   @cf/llava-hf/llava-1.5-7b-hf
///   @cf/meta/llama-3.2-11b-vision-instruct
class CloudflareProvider implements AIProvider {
  static String get _accountId =>
      dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  static String get _apiToken =>
      dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';
  static String get _model =>
      dotenv.env['CLOUDFLARE_MODEL'] ?? '@cf/llava-hf/llava-1.5-7b-hf';

  static String get _apiUrl =>
      'https://api.cloudflare.com/client/v4/accounts/$_accountId/ai/run/$_model';

  static const Duration _timeout = Duration(seconds: 45);

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

    // Cloudflare LLaVA: image byte array (uint8) olarak gönderilir
    final List<int> imageBytes = base64Decode(base64Image);

    final Map<String, dynamic> requestBody = {
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'image': imageBytes,
    };

    final http.Response response = await http
        .post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiToken',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        return (data['result']['response'] as String).trim();
      }
    }

    throw Exception('Cloudflare API hatası: ${response.statusCode} — ${response.body}');
  }
}

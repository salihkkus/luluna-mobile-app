import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ai_provider.dart';
import 'gemini_provider.dart';
import 'openai_provider.dart';
import 'claude_provider.dart';
import 'cloudflare_provider.dart';

/// AI motor seçici.
///
/// Motor değiştirmek için sadece .env'de şunu değiştirin:
///   AI_PROVIDER=gemini       → Google Gemini (gemini-1.5-flash varsayılan)
///   AI_PROVIDER=openai       → OpenAI GPT-4o
///   AI_PROVIDER=claude       → Anthropic Claude
///   AI_PROVIDER=cloudflare   → Cloudflare Workers AI (LLaVA varsayılan)
///
/// Her motor için gerekli .env anahtarları:
///
///   [gemini]
///     GEMINI_API_KEY=...
///     GEMINI_MODEL=gemini-1.5-flash        (opsiyonel)
///
///   [openai]
///     OPENAI_API_KEY=sk-...
///     OPENAI_MODEL=gpt-4o                  (opsiyonel)
///
///   [claude]
///     ANTHROPIC_API_KEY=sk-ant-...
///     ANTHROPIC_MODEL=claude-3-5-haiku-20241022  (opsiyonel)
///
///   [cloudflare]
///     CLOUDFLARE_ACCOUNT_ID=...
///     CLOUDFLARE_API_TOKEN=...
///     CLOUDFLARE_MODEL=@cf/llava-hf/llava-1.5-7b-hf  (opsiyonel)
class ProviderFactory {
  static AIProvider create() {
    final String provider =
        dotenv.env['AI_PROVIDER']?.toLowerCase().trim() ?? 'gemini';

    switch (provider) {
      case 'gemini':
        return GeminiProvider();

      case 'openai':
        return OpenAIProvider();

      case 'claude':
        return ClaudeProvider();

      case 'cloudflare':
        return CloudflareProvider();

      default:
        // Tanınmayan değer → Gemini'ye düş, konsola uyarı yaz
        // ignore: avoid_print
        print('[ProviderFactory] Bilinmeyen AI_PROVIDER: "$provider". Gemini kullanılıyor.');
        return GeminiProvider();
    }
  }
}

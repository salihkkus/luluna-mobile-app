/// Abstract AI Provider arayüzü.
/// Yeni bir AI motoru eklemek için bu sınıfı implement edin.
abstract class AIProvider {
  /// Görseli analiz eder ve sonuç string döndürür.
  ///
  /// [base64Image] - JPEG formatında Base64 encoded görsel
  /// [language]    - Cihaz dili kodu ('tr', 'en', 'de', 'fr', 'ar', 'es')
  /// [isDeveloperMode] - true ise kısıtlamalar kaldırılır
  Future<String> analyzeImage({
    required String base64Image,
    required String language,
    required bool isDeveloperMode,
  });
}

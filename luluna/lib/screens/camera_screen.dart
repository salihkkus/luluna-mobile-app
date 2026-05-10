import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../services/detection_service.dart';
import '../services/vision_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  List<CameraDescription> _cameras = [];
  FlutterTts _flutterTts = FlutterTts();
  final DetectionService _detectionService = DetectionService.instance;
  final VisionService _visionService = VisionService();
  
  String? _detectedObject;
  String? _currentQuestion;
  bool _isProcessing = false;
  DetectionResult? _lastDetectionResult;
  String? _aiResult;
  bool _isAiProcessing = false;

  // Quiz için yeni değişkenler
  List<String> _options = [];
  String? _correctAnswer;
  String? _selectedAnswer;
  bool? _isAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTts();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flutterTts.stop();
    _detectionService.dispose();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('tr-TR');
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initializeCamera() async {
    // Kamera izinlerini kontrol et
    var cameraStatus = await Permission.camera.request();
    
    if (cameraStatus.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      
      // Mevcut kameraları al
      _cameras = await availableCameras();
      
      if (_cameras.isNotEmpty) {
        // Arka kamerayı kullan (genellikle ilk kamera arka kamerasıdır)
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _controller!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } else {
      // İzin verilmediyse kullanıcıyı bilgilendir
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Kamera İzni Gerekli',
          style: AppTheme.headlineSmall,
        ),
        content: Text(
          'Luluna\'nın çevrenizdeki nesneleri tanıyabilmesi için kamera izni gereklidir.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: AppTheme.labelLarge.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: Text(
              'Tekrar Dene',
              style: AppTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  // AI nesne tespiti - Gerçek AI entegrasyonu
  Future<void> _detectObject() async {
    if (_isProcessing || _controller == null) return;
    
    setState(() {
      _isProcessing = true;
      _detectedObject = null;
      _currentQuestion = null;
    });
    
    try {
      // Gerçek AI servisini kullanıyoruz
      print('🔄 Using real AI vision service');
      
      // AI ile kameradan analiz
      final result = await _visionService.analyzeFromCamera();
      
      // JSON parse et
      try {
        final Map<String, dynamic> data = jsonDecode(result);
        
        setState(() {
          _detectedObject = data['description'];
          _currentQuestion = data['question'];
          _options = List<String>.from(data['options']);
          _correctAnswer = data['correct_answer'];
          _selectedAnswer = null;
          _isAnswerCorrect = null;
        });
        
        // Önce sadece soruyu seslendir (yorumu gizli tutuyoruz)
        await _speakResult("Hadi bulalım! ${data['question']}");
      } catch (e) {
        print('❌ JSON Parse Error: $e');
        setState(() {
          _detectedObject = result;
          _currentQuestion = null;
          _options = [];
        });
        await _speakResult(result);
      }
      
    } catch (e) {
      print('❌ AI Detection Error: $e');
      
      // Hata durumunda mock detection'a geri dön
      await _fallbackToMockDetection();
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // AI ile galeriden analiz
  Future<void> _analyzeFromGallery() async {
    if (_isAiProcessing) return;
    
    setState(() {
      _isAiProcessing = true;
      _aiResult = null;
    });
    
    try {
      final result = await _visionService.analyzeFromGallery();
      
      // JSON parse et
      try {
        final Map<String, dynamic> data = jsonDecode(result);
        
        setState(() {
          _aiResult = data['description'];
          _currentQuestion = data['question'];
          _options = List<String>.from(data['options']);
          _correctAnswer = data['correct_answer'];
          _selectedAnswer = null;
          _isAnswerCorrect = null;
        });
        
        // Önce sadece soruyu seslendir
        await _speakResult("Bu görselde bir soru var! ${data['question']}");
      } catch (e) {
        print('❌ JSON Parse Error: $e');
        setState(() {
          _aiResult = result;
          _options = [];
        });
        await _speakResult(result);
      }
      
    } catch (e) {
      print('❌ Gallery Analysis Error: $e');
      setState(() {
        _aiResult = 'Görsel analiz edilemedi. Lütfen tekrar deneyin.';
      });
    } finally {
      setState(() {
        _isAiProcessing = false;
      });
    }
  }

  // Fallback mock detection
  Future<void> _fallbackToMockDetection() async {
    print('🔄 Falling back to mock detection');
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock nesnelerden rastgele seçim
    final mockObjects = ['salih', 'sümeyye', 'doğu', 'kerem', 'ceren'];
    final randomIndex = DateTime.now().millisecondsSinceEpoch % mockObjects.length;
    final detectedObject = mockObjects[randomIndex];
    final confidence = 0.75 + (DateTime.now().millisecondsSinceEpoch % 25) / 100.0;
      
    if (mounted) {
      setState(() {
        _detectedObject = detectedObject;
        _isProcessing = false;
      });
      
      // Tespit edilen nesneyi seslendir
      _speakObject(detectedObject, confidence);
      
      // 3 saniye sonra soru sor
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _askQuestion(detectedObject);
        }
      });
    }
  }

  // Mock detection fallback
  void _performMockDetection() {
    final mockObjects = ['salih', 'sümeyye', 'doğu', 'kerem', 'ceren'];
    final randomObject = mockObjects[
      (DateTime.now().millisecondsSinceEpoch % mockObjects.length)
    ];
    
    setState(() {
      _detectedObject = randomObject;
      _isProcessing = false;
    });
  }

  // AI sonuçlarını seslendirme
  Future<void> _speakResult(String result) async {
    try {
      await _flutterTts.speak(result);
    } catch (e) {
      print('❌ TTS Error: $e');
    }
  }

  // Basit CameraImage converter (gerçek uygulamada daha karmaşık olur)
  Future<CameraImage> _convertToCameraImage(Uint8List imageBytes) async {
    // Bu basitleştirilmiş bir versiyon
    // Gerçek uygulamada kamera stream'i doğrudan kullanılır
    // Şimdilik mock detection kullanacağımız için bu metoda ihtiyacımız yok
    throw UnimplementedError('CameraImage conversion not implemented - using mock detection');
  }

  Future<void> _speakObject(String object, double confidence) async {
    final confidenceText = (confidence * 100).toInt().toString();
    await _flutterTts.speak('Bak! Bu bir $object. Güven: %$confidenceText.');
  }

  Future<void> _speakNoDetection() async {
    await _flutterTts.speak('Hiçbir nesne tespit edilemedi. Tekrar deneyelim.');
  }

  void _askQuestion(String object) {
    String question;
    
    // Nesneye göre uygun soru seç
    switch (object) {
      case 'salih':
        question = 'Salih ile ne oyun oynayabiliriz?';
        break;
      case 'sümeyye':
        question = 'Sümeyne nasıl yardımcı olabiliriz?';
        break;
      case 'doğu':
        question = 'Doğu ile neler paylaşabiliriz?';
        break;
      case 'kerem':
        question = 'Kerem ne zaman mutlu olur?';
        break;
      case 'ceren':
        question = 'Ceren en çok neyi sever?';
        break;
      case 'elma':
        question = 'Bu elma hangi renk?';
        break;
      case 'kitap':
        question = 'Bu kitap ne işe yarar?';
        break;
      case 'telefon':
        question = 'Telefonla ne yapabiliriz?';
        break;
      case 'kalem':
        question = 'Kalemle ne yazabiliriz?';
        break;
      case 'bardak':
        question = 'Bardak ne için kullanılır?';
        break;
      default:
        question = 'Bu $object hakkında ne söyleyebiliriz?';
    }
    
    setState(() {
      _currentQuestion = question;
    });
    
    _flutterTts.speak(question);
  }

  void _handleOptionTap(String option) {
    if (_selectedAnswer != null) return;

    setState(() {
      _selectedAnswer = option;
      _isAnswerCorrect = option == _correctAnswer;
    });

    if (_isAnswerCorrect!) {
      _speakResult('Harika! Doğru cevap 😊. ${_detectedObject ?? _aiResult}');
    } else {
      _speakResult('Hadi bir daha deneyelim. Doğru cevap şuydu: $_correctAnswer 🙈');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Image.asset(
          'assets/models/luluna.png',
          height: 36,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Kamera görüntüsü alanı
              Container(
                height: 350,
                margin: const EdgeInsets.all(AppTheme.containerMargin),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildCameraWidget(),
                ),
              ),
              
              // Tespit ve soru alanı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                child: Column(
                  children: [
                    // Tespit edilen nesne (Sadece doğru cevap verildikten sonra gösterilir)
                    if ((_detectedObject != null || _aiResult != null) && _isAnswerCorrect == true)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.md),
                        margin: const EdgeInsets.only(bottom: AppTheme.md),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              _detectedObject ?? _aiResult!,
                              style: AppTheme.labelLarge.copyWith(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: AppTheme.md),
                    
                    // Soru ve Şıklar
                    if (_currentQuestion != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.md),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _currentQuestion!,
                              style: AppTheme.labelLarge.copyWith(
                                color: AppTheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.md),
                            
                            // Şıklar
                            if (_options.isNotEmpty)
                              Column(
                                children: _options.map((option) {
                                  bool isSelected = _selectedAnswer == option;
                                  bool isCorrect = option == _correctAnswer;
                                  
                                  Color buttonColor = Colors.white;
                                  if (isSelected) {
                                    buttonColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
                                  } else if (_selectedAnswer != null && isCorrect) {
                                    buttonColor = Colors.green.shade50;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: InkWell(
                                      onTap: () => _handleOptionTap(option),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: buttonColor,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected 
                                              ? (isCorrect ? Colors.green : Colors.red)
                                              : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              option,
                                              style: AppTheme.bodyLarge.copyWith(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(
                                                isCorrect ? Icons.check_circle : Icons.cancel,
                                                color: isCorrect ? Colors.green : Colors.red,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Kontrol butonları
              Padding(
                padding: const EdgeInsets.all(AppTheme.containerMargin),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isProcessing ? null : _detectObject,
                            icon: _isProcessing 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.camera_alt),
                            label: Text(_isProcessing ? 'Analiz Ediliyor...' : '📸 Çek ve Sor'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAiProcessing ? null : _analyzeFromGallery,
                            icon: _isAiProcessing 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.photo_library),
                            label: Text(_isAiProcessing ? 'İşleniyor...' : '🖼️ Galeri'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraWidget() {
    if (!_isPermissionGranted) {
      return Container(
        color: AppTheme.surfaceContainerLow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: AppTheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppTheme.md),
              Text(
                'Kamera izni gerekli',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (!_isCameraInitialized) {
      return Container(
        color: AppTheme.surface,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        ),
      );
    }
    
    return CameraPreview(_controller!);
  }
}

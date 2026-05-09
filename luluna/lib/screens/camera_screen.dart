import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import '../theme/app_theme.dart';
import '../services/detection_service.dart';

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
  
  String? _detectedObject;
  String? _currentQuestion;
  bool _isProcessing = false;
  DetectionResult? _lastDetectionResult;

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

  // Mock AI nesne tespiti (TensorFlow Lite geçici olarak devre dışı)
  Future<void> _detectObject() async {
    if (_isProcessing || _controller == null) return;
    
    setState(() {
      _isProcessing = true;
      _detectedObject = null;
      _currentQuestion = null;
    });
    
    try {
      // Şimdilik doğrudan mock detection kullanıyoruz
      // Doğu'nun modeli gelince gerçek AI entegrasyonu aktif edilecek
      print('🔄 Using mock detection (TensorFlow Lite temporarily disabled)');
      
      // Mock detection simülasyonu
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
      
    } catch (e) {
      print('❌ Detection error: $e');
      
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        // Hata durumunda mock kullan
        _performMockDetection();
      }
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
    
    // Tespit edilen nesneyi seslendir
    _speakObject(randomObject, 0.8);
    
    // 3 saniye sonra soru sor
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _askQuestion(randomObject);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Luluna',
          style: AppTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kamera görüntüsü alanı
            Expanded(
              flex: 3,
              child: Container(
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
            ),
            
            // Tespit ve soru alanı
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.containerMargin),
                child: Column(
                  children: [
                    // Tespit edilen nesne
                    if (_detectedObject != null)
                      Container(
                        padding: const EdgeInsets.all(AppTheme.md),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: AppTheme.onSecondaryContainer,
                              size: 24,
                            ),
                            const SizedBox(width: AppTheme.sm),
                            Expanded(
                              child: Text(
                                'Tespit edilen: $_detectedObject',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: AppTheme.md),
                    
                    // Soru
                    if (_currentQuestion != null)
                      Container(
                        padding: const EdgeInsets.all(AppTheme.md),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: AppTheme.onPrimaryContainer,
                              size: 24,
                            ),
                            const SizedBox(width: AppTheme.sm),
                            Expanded(
                              child: Text(
                                _currentQuestion!,
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Kontrol butonları
            Padding(
              padding: const EdgeInsets.all(AppTheme.containerMargin),
              child: Row(
                children: [
                  // Tespit butonu
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: _isProcessing 
                            ? AppTheme.surfaceContainerHigh
                            : AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _isProcessing ? null : _detectObject,
                          child: Center(
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.onPrimary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera,
                                        color: AppTheme.onPrimary,
                                        size: 24,
                                      ),
                                      const SizedBox(width: AppTheme.sm),
                                      Text(
                                        'Nesne Tespit Et',
                                        style: AppTheme.labelLarge.copyWith(
                                          color: AppTheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

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
  
  // Mock veri - daha sonra gerçek AI modeli ile değiştirilecek
  final List<String> _mockObjects = [
    'elma', 'kitap', 'telefon', 'kalem', 'bardak',
    'çanta', 'saat', 'anahtar', 'gözlük', 'çorap'
  ];
  
  String? _detectedObject;
  String? _currentQuestion;
  bool _isProcessing = false;

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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Luluna\'nın çevrenizdeki nesneleri tanıyabilmesi için kamera izni gereklidir.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFABC4FF),
            ),
            child: Text(
              'Tekrar Dene',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Mock nesne tespiti - gerçek AI yerine simülasyon
  void _detectObject() {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    // Simüle edilmiş tespit işlemi
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final randomObject = _mockObjects[
          (DateTime.now().millisecondsSinceEpoch % _mockObjects.length)
        ];
        
        setState(() {
          _detectedObject = randomObject;
          _isProcessing = false;
        });
        
        // Tespit edilen nesneyi seslendir
        _speakObject(randomObject);
        
        // 3 saniye sonra soru sor
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _askQuestion(randomObject);
          }
        });
      }
    });
  }

  Future<void> _speakObject(String object) async {
    await _flutterTts.speak('Bak! Bu bir $object.');
  }

  void _askQuestion(String object) {
    String question;
    
    // Nesneye göre uygun soru seç
    switch (object) {
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
        question = 'Bu $object ne işe yarar?';
    }
    
    setState(() {
      _currentQuestion = question;
    });
    
    _flutterTts.speak(question);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFABC4FF),
        elevation: 0,
        title: Text(
          'Luluna',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kamera görüntüsü alanı
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Tespit edilen nesne
                    if (_detectedObject != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBEE1E6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFF2C3E50),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tespit edilen: $_detectedObject',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // Soru
                    if (_currentQuestion != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFABC4FF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _currentQuestion!,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Tespit butonu
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: _isProcessing 
                            ? Colors.grey.shade300 
                            : const Color(0xFFABC4FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFABC4FF).withOpacity(0.3),
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
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nesne Tespit Et',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
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
        color: Colors.grey.shade200,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Kamera izni gerekli',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (!_isCameraInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFABC4FF),
          ),
        ),
      );
    }
    
    return CameraPreview(_controller!);
  }
}

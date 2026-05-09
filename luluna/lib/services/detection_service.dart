import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart'; // Geçici olarak kaldırıldı
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

// Detection result model
class DetectionResult {
  final List<Detection> detections;
  final int inferenceTime;
  final DateTime timestamp;

  DetectionResult({
    required this.detections,
    required this.inferenceTime,
    required this.timestamp,
  });
}

class Detection {
  final String label;
  final double confidence;
  final ui.Rect boundingBox;
  final int classId;

  Detection({
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.classId,
  });

  @override
  String toString() {
    return 'Detection(label: $label, confidence: ${confidence.toStringAsFixed(2)})';
  }
}

// Detection service for AI model
class DetectionService {
  static DetectionService? _instance;
  static DetectionService get instance => _instance ??= DetectionService._();
  
  DetectionService._();

  // Interpreter? _interpreter; // Geçici olarak kaldırıldı
  List<String>? _labels;
  bool _isInitialized = false;
  
  // Model parameters (will be updated when model is loaded)
  int _inputSize = 640; // Default YOLOv8 input size
  int _outputSize = 8400; // Default YOLOv8 output size
  double _confidenceThreshold = 0.5;
  double _iouThreshold = 0.4;

  // Initialize the AI model
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load model (will be updated when Doğu provides the model)
      // await _loadModel(); // Geçici olarak kaldırıldı
      
      // Load labels (will be updated when Doğu provides the labels)
      await _loadLabels();
      
      _isInitialized = true;
      print('✅ DetectionService initialized successfully (Mock mode)');
    } catch (e) {
      print('❌ Error initializing DetectionService: $e');
      rethrow;
    }
  }

  // Load TFLite model
  // Future<void> _loadModel() async {
  //   try {
  //     // For now, we'll use a placeholder
  //     // When Doğu provides the model, update this path
  //     final modelPath = 'assets/models/luluna_model.tflite';
      
  //     // Check if model file exists
  //     final file = File(modelPath);
  //     if (!await file.exists()) {
  //       print('⚠️ Model file not found: $modelPath');
  //       print('🔄 Using mock mode until model is provided');
  //       return;
  //     }

  //     // Load interpreter
  //     final options = InterpreterOptions();
  //     _interpreter = await Interpreter.fromAsset(modelPath, options: options);
      
  //     // Get input/output shapes
  //     final inputShape = _interpreter!.getInputTensors().first.shape;
  //     final outputShape = _interpreter!.getOutputTensors().first.shape;
      
  //     print('📊 Model loaded successfully');
  //     print('   Input shape: $inputShape');
  //     print('   Output shape: $outputShape');
      
  //     // Update parameters based on model
  //     _inputSize = inputShape[1];
  //     _outputSize = outputShape[1] * outputShape[2];
      
  //   } catch (e) {
  //     print('❌ Error loading model: $e');
  //     rethrow;
  //   }
  // }

  // Load labels
  Future<void> _loadLabels() async {
    try {
      // For now, we'll use mock labels
      // When Doğu provides the labels, update this path
      final labelsPath = 'assets/models/labels.txt';
      
      final file = File(labelsPath);
      if (!await file.exists()) {
        print('⚠️ Labels file not found: $labelsPath');
        print('🔄 Using mock labels until provided');
        _labels = [
          'salih', 'sümeyye', 'doğu', 'kerem', 'ceren',
          'elma', 'kitap', 'telefon', 'kalem', 'bardak'
        ];
        return;
      }

      final labelsData = await file.readAsString();
      _labels = labelsData.split('\n').map((label) => label.trim()).toList();
      
      print('📝 Labels loaded successfully: ${_labels!.length} labels');
      
    } catch (e) {
      print('❌ Error loading labels: $e');
      rethrow;
    }
  }

  // Detect objects in camera image
  Future<DetectionResult> detectObjects(CameraImage cameraImage) async {
    if (!_isInitialized) {
      await initialize();
    }

    final stopwatch = Stopwatch()..start();

    try {
      // For now, always use mock detection until model is provided
      print('🔄 Using mock detection (TensorFlow Lite disabled temporarily)');
      return await _getMockDetection(cameraImage);
      
      // Future implementation when model is available:
      // if (_interpreter == null) {
      //   return await _getMockDetection(cameraImage);
      // }
      
      // // Preprocess image
      // final input = _preprocessImage(cameraImage);
      
      // // Run inference
      // final output = List.filled(_outputSize, 0.0).reshape([1, _outputSize ~/ 85, 85]);
      // _interpreter!.run(input, output);
      
      // // Postprocess results
      // final detections = _postprocessOutput(output[0]);
      
      // stopwatch.stop();
      
      // return DetectionResult(
      //   detections: detections,
      //   inferenceTime: stopwatch.elapsedMilliseconds,
      //   timestamp: DateTime.now(),
      // );
      
    } catch (e) {
      print('❌ Error during detection: $e');
      stopwatch.stop();
      
      // Fallback to mock detection
      return await _getMockDetection(cameraImage);
    }
  }

  // Preprocess camera image for model input
  List<List<List<List<double>>>> _preprocessImage(CameraImage cameraImage) {
    try {
      // Convert CameraImage to Image
      final image = _convertCameraImage(cameraImage);
      
      // Resize to model input size
      final resized = img.copyResize(
        image,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.linear,
      );
      
      // Convert to normalized tensor [1, height, width, channels]
      final input = List.generate(
        1,
        (i) => List.generate(
          _inputSize,
          (y) => List.generate(
            _inputSize,
            (x) {
              final pixel = resized.getPixel(x, y);
              return [
                pixel.r / 255.0, // Normalize to [0, 1]
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );
      
      return input;
      
    } catch (e) {
      print('❌ Error preprocessing image: $e');
      rethrow;
    }
  }

  // Convert CameraImage to Image format
  img.Image _convertCameraImage(CameraImage cameraImage) {
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;
      
      // Create image
      final image = img.Image(width: width, height: height);
      
      // Convert based on format group
      // Note: Bu kodlar TensorFlow Lite aktif olduğunda kullanılacak
      // Şimdilik mock detection kullanıldığı için bu metoda ihtiyaç yok
      throw UnsupportedError('Camera image conversion disabled in mock mode');
      
      return image;
      
    } catch (e) {
      print('❌ Error converting camera image: $e');
      rethrow;
    }
  }

  // Convert YUV420 to RGB (TensorFlow Lite aktif olduğunda kullanılacak)
  // void _convertYUV420ToRGB(CameraImage cameraImage, img.Image image) {
  //   final yPlane = cameraImage.planes[0];
  //   final uPlane = cameraImage.planes[1];
  //   final vPlane = cameraImage.planes[2];
    
  //   final width = cameraImage.width;
  //   final height = cameraImage.height;
    
  //   for (int y = 0; y < height; y++) {
  //     for (int x = 0; x < width; x++) {
  //       final yIndex = y * yPlane.bytesPerRow + x;
  //       final uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);
        
  //       final yValue = yPlane.bytes[yIndex];
  //       final uValue = uPlane.bytes[uvIndex];
  //       final vValue = vPlane.bytes[uvIndex];
        
  //       // Convert YUV to RGB
  //       final r = (yValue + 1.402 * (vValue - 128)).clamp(0, 255).toInt();
  //       final g = (yValue - 0.344 * (uValue - 128) - 0.714 * (vValue - 128)).clamp(0, 255).toInt();
  //       final b = (yValue + 1.772 * (uValue - 128)).clamp(0, 255).toInt();
        
  //       image.setPixel(x, y, img.ColorRgb8(r, g, b));
  //     }
  //   }
  // }

  // Convert BGRA8888 to RGB (TensorFlow Lite aktif olduğunda kullanılacak)
  // void _convertBGRA8888ToRGB(CameraImage cameraImage, img.Image image) {
  //   final plane = cameraImage.planes[0];
  //   final bytes = plane.bytes;
    
  //   final width = cameraImage.width;
  //   final height = cameraImage.height;
    
  //   for (int y = 0; y < height; y++) {
  //     for (int x = 0; x < width; x++) {
  //       final index = y * plane.bytesPerRow + x * 4;
        
  //       final b = bytes[index];
  //       final g = bytes[index + 1];
  //       final r = bytes[index + 2];
        
  //       image.setPixel(x, y, img.ColorRgb8(r, g, b));
  //     }
  //   }
  // }

  // Postprocess model output to get detections
  List<Detection> _postprocessOutput(List<List<List<double>>> output) {
    final detections = <Detection>[];
    
    try {
      // This is a simplified postprocessing
      // Actual implementation will depend on Doğu's model output format
      for (int i = 0; i < output.length; i++) {
        for (int j = 0; j < output[i].length; j++) {
          final detection = output[i][j];
          
          if (detection.length >= 5) {
            final confidence = detection[4];
            
            if (confidence > _confidenceThreshold) {
              final classId = detection.indexOf(detection.reduce((a, b) => a > b ? a : b));
              final label = classId < _labels!.length ? _labels![classId] : 'unknown';
              
              // Extract bounding box (simplified)
              final centerX = detection[0] * _inputSize;
              final centerY = detection[1] * _inputSize;
              final w = detection[2] * _inputSize;
              final h = detection[3] * _inputSize;
              
              final boundingBox = ui.Rect.fromCenter(
                center: ui.Offset(centerX, centerY),
                width: w,
                height: h,
              );
              
              detections.add(Detection(
                label: label,
                confidence: confidence,
                boundingBox: boundingBox,
                classId: classId,
              ));
            }
          }
        }
      }
      
      // Apply Non-Maximum Suppression (simplified)
      return _applyNMS(detections);
      
    } catch (e) {
      print('❌ Error postprocessing output: $e');
      return [];
    }
  }

  // Apply Non-Maximum Suppression
  List<Detection> _applyNMS(List<Detection> detections) {
    // Sort by confidence (descending)
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    
    final result = <Detection>[];
    final suppressed = <bool>[]..addAll(List.filled(detections.length, false));
    
    for (int i = 0; i < detections.length; i++) {
      if (suppressed[i]) continue;
      
      result.add(detections[i]);
      
      for (int j = i + 1; j < detections.length; j++) {
        if (suppressed[j]) continue;
        
        // Calculate IoU
        final iou = _calculateIoU(detections[i].boundingBox, detections[j].boundingBox);
        
        if (iou > _iouThreshold) {
          suppressed[j] = true;
        }
      }
    }
    
    return result;
  }

  // Calculate Intersection over Union
  double _calculateIoU(ui.Rect box1, ui.Rect box2) {
    final intersection = box1.intersect(box2);
    final intersectionArea = intersection.width * intersection.height;
    
    final area1 = box1.width * box1.height;
    final area2 = box2.width * box2.height;
    final unionArea = area1 + area2 - intersectionArea;
    
    return intersectionArea / unionArea;
  }

  // Mock detection for testing
  Future<DetectionResult> _getMockDetection(CameraImage cameraImage) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing
    
    // Mock detections based on current time
    final mockLabels = ['salih', 'sümeyye', 'doğu', 'kerem', 'ceren'];
    final randomIndex = DateTime.now().millisecondsSinceEpoch % mockLabels.length;
    final label = mockLabels[randomIndex];
    
    final detection = Detection(
      label: label,
      confidence: 0.75 + (DateTime.now().millisecondsSinceEpoch % 25) / 100.0,
      boundingBox: ui.Rect.fromLTWH(
        50.0 + (DateTime.now().millisecondsSinceEpoch % 100),
        50.0 + (DateTime.now().millisecondsSinceEpoch % 100),
        200.0,
        200.0,
      ),
      classId: randomIndex,
    );
    
    return DetectionResult(
      detections: [detection],
      inferenceTime: 500,
      timestamp: DateTime.now(),
    );
  }

  // Get model info
  Map<String, dynamic> getModelInfo() {
    return {
      'isInitialized': _isInitialized,
      'hasModel': false, // _interpreter != null, // Geçici olarak false
      'hasLabels': _labels != null,
      'inputSize': _inputSize,
      'outputSize': _outputSize,
      'confidenceThreshold': _confidenceThreshold,
      'iouThreshold': _iouThreshold,
      'labelCount': _labels?.length ?? 0,
      'mode': 'Mock Detection (TensorFlow Lite temporarily disabled)',
    };
  }

  // Update thresholds
  void updateThresholds({double? confidence, double? iou}) {
    if (confidence != null) _confidenceThreshold = confidence;
    if (iou != null) _iouThreshold = iou;
  }

  // Dispose resources
  void dispose() {
    // _interpreter?.close(); // Geçici olarak kaldırıldı
    // _interpreter = null;
    _labels = null;
    _isInitialized = false;
  }
}

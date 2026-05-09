import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'parent_dashboard_screen.dart';
import 'ai_personalization_screen.dart';

class ParentalPinScreen extends StatefulWidget {
  const ParentalPinScreen({super.key});

  @override
  State<ParentalPinScreen> createState() => _ParentalPinScreenState();
}

class _ParentalPinScreenState extends State<ParentalPinScreen> {
  final String _correctPin = "0000";
  List<String> _pinDigits = ['', '', '', ''];
  int _failedAttempts = 0;
  bool _isBlocked = false;
  DateTime? _blockEndTime;

  void _onDigitPressed(String digit) {
    if (_isBlocked) return;
    
    HapticFeedback.lightImpact();
    
    setState(() {
      // Boş olan ilk slota ekle
      for (int i = 0; i < _pinDigits.length; i++) {
        if (_pinDigits[i].isEmpty) {
          _pinDigits[i] = digit;
          break;
        }
      }
      
      // 4 hane tamamlandığında kontrol et
      if (_pinDigits.every((digit) => digit.isNotEmpty)) {
        _checkPin();
      }
    });
  }

  void _onDeletePressed() {
    if (_isBlocked) return;
    
    HapticFeedback.lightImpact();
    
    setState(() {
      // Son dolu slotu sil
      for (int i = _pinDigits.length - 1; i >= 0; i--) {
        if (_pinDigits[i].isNotEmpty) {
          _pinDigits[i] = '';
          break;
        }
      }
    });
  }

  void _checkPin() {
    final enteredPin = _pinDigits.join('');
    
    if (enteredPin == _correctPin) {
      HapticFeedback.mediumImpact();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ParentDashboardScreen(),
        ),
      );
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _failedAttempts++;
        _pinDigits = ['', '', '', ''];
        
        if (_failedAttempts >= 3) {
          _isBlocked = true;
          _blockEndTime = DateTime.now().add(const Duration(seconds: 30));
        }
      });
      
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Hatalı PIN'),
        content: Text(
          _failedAttempts >= 3 
            ? 'Çok fazla hatalı deneme! 30 saniye bekleyin.'
            : 'PIN yanlış. Tekrar deneyin.\nKalan hak: ${3 - _failedAttempts}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Veli Doğrulama',
          style: AppTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Başlık
              Icon(
                Icons.lock,
                size: 80,
                color: AppTheme.primary,
              ),
              const SizedBox(height: AppTheme.lg),
              
              Text(
                'Veli PIN\'i',
                style: AppTheme.headlineLarge,
              ),
              const SizedBox(height: AppTheme.md),
              
              Text(
                'Lütfen 4 haneli PIN kodunu girin',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // PIN Gösterim Alanı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _pinDigits[index].isNotEmpty 
                        ? AppTheme.primary 
                        : AppTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppTheme.xl),
              
              // Sayısal Klavye
              _buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    final List<String> numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          for (int row = 0; row < 3; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 0; col < 3; col++)
                  _buildNumberButton(numbers[row * 3 + col]),
              ],
            ),
          const SizedBox(height: AppTheme.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton(''), // Boş
              _buildNumberButton('0'),
              _buildDeleteButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    if (number.isEmpty) {
      return const SizedBox(width: 70, height: 70);
    }

    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => _onDigitPressed(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.surfaceContainer,
          foregroundColor: AppTheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          number,
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: _onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorContainer,
          foregroundColor: AppTheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Icon(
          Icons.backspace,
          color: AppTheme.error,
        ),
      ),
    );
  }
}

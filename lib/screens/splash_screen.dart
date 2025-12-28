import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/audio_service.dart';
import 'alphabet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize audio service (preload audio files)
    await AudioService().init();

    // Small delay to show splash screen
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate to alphabet screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AlphabetScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title
            const Text(
              'ABC',
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phonics',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

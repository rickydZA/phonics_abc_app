import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/branding.dart';
import '../services/audio_service.dart';
import 'alphabet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusMessage = 'Starting...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Step 1: Initialize audio service
    setState(() {
      _statusMessage = 'Loading audio files...';
    });
    await AudioService().init();

    // Step 2: Ready
    setState(() {
      _statusMessage = 'Ready!';
    });

    // Small delay to show "Ready!" message
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
            const SizedBox(height: 24),
            // Status message
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 60),
            // Teacher branding with mascot
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    Branding.mascotPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  Branding.recommendedBy,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

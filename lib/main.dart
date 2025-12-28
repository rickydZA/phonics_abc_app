import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PhonicsABCApp());
}

class PhonicsABCApp extends StatelessWidget {
  const PhonicsABCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonics ABC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

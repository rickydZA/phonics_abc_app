import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4CAF50);      // Green
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);

  // Background colors
  static const Color background = Color(0xFFFFF8E1);   // Warm cream
  static const Color splashBackground = Color(0xFF81D4FA); // Light blue

  // Tile colors - bright and engaging for children
  static const List<Color> tileColors = [
    Color(0xFFEF5350), // Red
    Color(0xFFEC407A), // Pink
    Color(0xFFAB47BC), // Purple
    Color(0xFF7E57C2), // Deep Purple
    Color(0xFF5C6BC0), // Indigo
    Color(0xFF42A5F5), // Blue
    Color(0xFF29B6F6), // Light Blue
    Color(0xFF26C6DA), // Cyan
    Color(0xFF26A69A), // Teal
    Color(0xFF66BB6A), // Green
    Color(0xFF9CCC65), // Light Green
    Color(0xFFD4E157), // Lime
    Color(0xFFFFEE58), // Yellow
    Color(0xFFFFCA28), // Amber
    Color(0xFFFFA726), // Orange
    Color(0xFFFF7043), // Deep Orange
  ];

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textOnTile = Color(0xFFFFFFFF);

  // Popup colors
  static const Color popupBackground = Color(0xFFFFFFFF);
  static const Color popupOverlay = Color(0x88000000);

  // Get a color for a letter based on its index
  static Color getTileColor(int index) {
    return tileColors[index % tileColors.length];
  }
}

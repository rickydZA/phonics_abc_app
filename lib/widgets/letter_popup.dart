import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/letter_data.dart';
import '../services/audio_service.dart';

class LetterPopup extends StatelessWidget {
  final LetterData letterData;
  final Color tileColor;

  const LetterPopup({
    super.key,
    required this.letterData,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = (screenWidth * 0.85).clamp(280.0, 400.0);
    final imageSize = popupWidth - 32; // 16px padding each side

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: popupWidth),
        decoration: BoxDecoration(
          color: AppColors.popupBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Letter display (uppercase and lowercase)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  letterData.upperCase,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: tileColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  letterData.lowerCase,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: tileColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image or fallback
            _buildImage(imageSize),
            const SizedBox(height: 16),
            // Word text
            Text(
              letterData.capitalizedWord,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: tileColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                letterData.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: colored circle with letter
                  return Container(
                    decoration: BoxDecoration(
                      color: tileColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        letterData.upperCase,
                        style: TextStyle(
                          fontSize: size * 0.5,
                          fontWeight: FontWeight.bold,
                          color: tileColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => AudioService().play(letterData.letter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show the letter popup dialog
Future<void> showLetterPopup(
  BuildContext context,
  LetterData letterData,
  Color tileColor,
) {
  return showDialog(
    context: context,
    barrierColor: AppColors.popupOverlay,
    builder: (context) => LetterPopup(
      letterData: letterData,
      tileColor: tileColor,
    ),
  );
}

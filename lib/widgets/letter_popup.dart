import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/letter_data.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: AppColors.popupBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            // Image or fallback
            _buildImage(),
            const SizedBox(height: 24),
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

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        letterData.imagePath,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: colored circle with letter
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: tileColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                letterData.upperCase,
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: tileColor,
                ),
              ),
            ),
          );
        },
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

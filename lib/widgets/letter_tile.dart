import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final int index;
  final VoidCallback onTap;

  const LetterTile({
    super.key,
    required this.letter,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getTileColor(index),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.getTileColor(index).withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter.toUpperCase(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnTile,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

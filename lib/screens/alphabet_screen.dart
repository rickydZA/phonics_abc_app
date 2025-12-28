import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/letter_data.dart';
import '../services/audio_service.dart';
import '../widgets/letter_tile.dart';
import '../widgets/letter_popup.dart';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive column count based on screen width
              final crossAxisCount = _calculateColumns(constraints.maxWidth);

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: alphabetData.length,
                itemBuilder: (context, index) {
                  final letter = alphabetData[index];
                  return LetterTile(
                    letter: letter.letter,
                    index: index,
                    onTap: () => _onLetterTap(context, letter, index),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  int _calculateColumns(double width) {
    if (width >= 800) return 7;      // Large tablet landscape
    if (width >= 600) return 6;      // Tablet landscape
    if (width >= 500) return 5;      // Tablet portrait / large phone landscape
    if (width >= 400) return 4;      // Phone landscape
    return 4;                         // Phone portrait (minimum 4)
  }

  void _onLetterTap(BuildContext context, LetterData letter, int index) {
    // Play audio
    AudioService().play(letter.letter);

    // Show popup
    showLetterPopup(
      context,
      letter,
      AppColors.getTileColor(index),
    );
  }
}

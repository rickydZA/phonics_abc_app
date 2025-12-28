import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../data/letter_data.dart';
import '../services/audio_service.dart';
import '../widgets/letter_tile.dart';
import '../widgets/letter_popup.dart';

// Placeholder URLs - update when app is published
const String _appStoreUrl = 'https://apps.apple.com/app/id000000000';
const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.phonics_abc_app';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App store badges (web only)
            if (kIsWeb) _buildStoreBadges(),
            // Letter grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildStoreBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Get the app:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          _StoreBadge(
            imageUrl: 'https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg',
            storeUrl: _appStoreUrl,
            alt: 'App Store',
          ),
          const SizedBox(width: 8),
          _StoreBadge(
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg',
            storeUrl: _playStoreUrl,
            alt: 'Google Play',
          ),
        ],
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

class _StoreBadge extends StatelessWidget {
  final String imageUrl;
  final String storeUrl;
  final String alt;

  const _StoreBadge({
    required this.imageUrl,
    required this.storeUrl,
    required this.alt,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(storeUrl),
        child: Image.network(
          imageUrl,
          height: 36,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                alt,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

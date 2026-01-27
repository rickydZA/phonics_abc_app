import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/branding.dart';
import '../data/letter_data.dart';
import '../services/audio_service.dart';
import '../widgets/letter_tile.dart';
import '../widgets/letter_popup.dart';

// Placeholder URLs - update when app is published
const String _appStoreUrl = 'https://apps.apple.com/app/id000000000';
const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.phonics_abc_app';

// Height of the site header (web only)
const double _webHeaderHeight = 60.0;

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Add top padding for web header
        top: !kIsWeb, // Only use SafeArea top on mobile
        child: Padding(
          padding: EdgeInsets.only(top: kIsWeb ? _webHeaderHeight : 0),
          child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _calculateColumns(constraints.maxWidth);

            return CustomScrollView(
              slivers: [
                // Teacher branding header
                SliverToBoxAdapter(
                  child: _buildBrandingHeader(context),
                ),
                // Letter grid
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final letter = alphabetData[index];
                        return LetterTile(
                          letter: letter.letter,
                          index: index,
                          onTap: () => _onLetterTap(context, letter, index),
                        );
                      },
                      childCount: alphabetData.length,
                    ),
                  ),
                ),
                // App store badges (web only) - temporarily disabled
                // TODO: Re-enable when apps are live on stores
                // if (kIsWeb)
                //   SliverToBoxAdapter(
                //     child: _buildStoreBadges(),
                //   ),
              ],
            );
          },
        ),
        ),
      ),
    );
  }

  Widget _buildBrandingHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.1),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _launchWebsite(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mascot image
                ClipOval(
                  child: Image.asset(
                    Branding.mascotPath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                // Brand text
                Text(
                  Branding.recommendedBy,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreBadges() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StoreBadge(
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Download_on_the_App_Store_Badge.svg/200px-Download_on_the_App_Store_Badge.svg.png',
            storeUrl: _appStoreUrl,
            alt: 'App Store',
          ),
          const SizedBox(width: 16),
          _StoreBadge(
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Google_Play_Store_badge_EN.svg/200px-Google_Play_Store_badge_EN.svg.png',
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

  Future<void> _launchWebsite(BuildContext context) async {
    final uri = Uri.parse(Branding.website);
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show message if no browser available (common on emulators)
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Visit: ${Branding.website}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Handle launch errors gracefully
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Visit: ${Branding.website}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
          height: 50,
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

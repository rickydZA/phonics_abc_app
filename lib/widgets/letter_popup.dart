import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/branding.dart';
import '../data/letter_data.dart';
import '../services/audio_service.dart';

class LetterPopup extends StatefulWidget {
  final LetterData letterData;
  final Color tileColor;

  const LetterPopup({
    super.key,
    required this.letterData,
    required this.tileColor,
  });

  @override
  State<LetterPopup> createState() => _LetterPopupState();
}

class _LetterPopupState extends State<LetterPopup> {
  bool _isLaunching = false;

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
                  widget.letterData.upperCase,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: widget.tileColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.letterData.lowerCase,
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: widget.tileColor,
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
              widget.letterData.capitalizedWord,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: widget.tileColor,
              ),
            ),
            const SizedBox(height: 12),
            // Teacher branding with mascot
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _launchWebsite(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        Branding.mascotPath,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback: show small icon if mascot image fails
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.school,
                              size: 12,
                              color: AppColors.textPrimary.withValues(alpha: 0.4),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Branding.teacherName,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchWebsite(BuildContext context) async {
    final uri = Uri.parse('http://${Branding.website}');
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show message if no browser available (common on emulators)
        if (mounted) {
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
      debugPrint('Error launching website: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Visit: ${Branding.website}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _launchPodcast(String url) async {
    if (_isLaunching) return;

    setState(() {
      _isLaunching = true;
    });

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open podcast link'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching podcast: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening podcast'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLaunching = false;
        });
      }
    }
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
                widget.letterData.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: colored circle with letter
                  return Container(
                    decoration: BoxDecoration(
                      color: widget.tileColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.letterData.upperCase,
                        style: TextStyle(
                          fontSize: size * 0.5,
                          fontWeight: FontWeight.bold,
                          color: widget.tileColor,
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
                  onTap: () => AudioService().play(widget.letterData.letter),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _isLaunching ? null : () => _launchPodcast(widget.letterData.podcastUrl),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isLaunching
                        ? Colors.grey.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: _isLaunching
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(widget.tileColor),
                          ),
                        )
                      : Icon(
                          Icons.headphones,
                          size: 16,
                          color: widget.tileColor,
                        ),
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

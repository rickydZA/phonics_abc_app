import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../data/letter_data.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  final Set<String> _availableAudio = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Initialize the audio service and check which audio files exist
  Future<void> init() async {
    if (_initialized) return;

    // Check which audio files are available
    for (final letter in alphabetData) {
      try {
        await rootBundle.load(letter.audioPath);
        _availableAudio.add(letter.letter.toLowerCase());
      } catch (e) {
        // Audio file doesn't exist yet - that's okay
      }
    }

    _initialized = true;
  }

  /// Play audio for a letter, stopping any currently playing audio
  Future<void> play(String letter) async {
    final lowerLetter = letter.toLowerCase();

    // Check if audio exists for this letter
    if (!_availableAudio.contains(lowerLetter)) {
      return; // Silent fail - no audio available
    }

    try {
      // Stop current audio before playing new one (handles rapid tapping)
      await _player.stop();

      // Play the audio
      await _player.play(AssetSource('audio/$lowerLetter.mp3'));
    } catch (e) {
      // Silent fail - don't crash if audio fails to play
    }
  }

  /// Stop any currently playing audio
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      // Ignore errors when stopping
    }
  }

  /// Dispose of the audio player
  void dispose() {
    _player.dispose();
  }
}

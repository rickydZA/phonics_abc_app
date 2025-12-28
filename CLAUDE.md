# Phonics ABC App

A Flutter app for young English learners to practice basic phonics skills.

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── constants/
│   └── app_colors.dart          # Centralized color definitions
├── data/
│   └── letter_data.dart         # Letter model & A-Z data
├── screens/
│   ├── splash_screen.dart       # Loading screen during audio preload
│   └── alphabet_screen.dart     # Main screen with letter grid
├── widgets/
│   ├── letter_tile.dart         # Clickable letter button
│   └── letter_popup.dart        # Popup dialog with image
└── services/
    └── audio_service.dart       # Audio playback handling

assets/
├── audio/                       # Voice recordings (a.mp3 - z.mp3)
└── images/                      # Letter images (a_apple.webp - z_zebra.webp)
```

## Key Features

- Single-page app with alphabet grid (A-Z)
- Tap letter → plays audio chant + shows popup with image
- Responsive grid adapts to screen orientation
- Audio stops current before playing new (handles rapid tapping)
- Graceful fallbacks for missing assets

## Dependencies

- `audioplayers` - Audio playback

## Asset Conventions

**Audio:** `assets/audio/{letter}.mp3` (e.g., `a.mp3`)
- Content: Voice saying "A A a a a, a is for apple"

**Images:** `assets/images/{letter}_{word}.webp` (e.g., `a_apple.webp`)
- Size: 512x512px recommended

## Word Associations

A-Apple, B-Ball, C-Cat, D-Dog, E-Elephant, F-Fish, G-Gorilla, H-Hat, I-Igloo, J-Jam, K-Kite, L-Lion, M-Monkey, N-Nurse, O-Octopus, P-Pig, Q-Queen, R-Rainbow, S-Sun, T-Turtle, U-Umbrella, V-Violin, W-Window, X-Fox, Y-Yellow, Z-Zebra

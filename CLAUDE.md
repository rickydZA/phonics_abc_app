# Phonics ABC App

A Flutter app for young English learners to practice basic phonics skills.

**Version:** 1.0.0+10
**Package:** tw.com.englishteacher.phonicsabc

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── constants/
│   ├── app_colors.dart          # Color palette definitions
│   └── branding.dart            # Teacher branding (name, website, mascot)
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
└── images/
    ├── a_apple.webp ... z_zebra.webp        # Letter images
    ├── little_chick_mascot_3D.png           # App mascot
    └── app_icon/                            # App launcher icons
        ├── app_icon_foreground.png
        └── app_icon_background.png

docs/                            # GitHub Pages website (englishabc.englishteacher.com.tw)
├── index.html                   # Redirects to closed-test-landing.html
├── closed-test-landing.html     # Marketing page for closed testing
├── privacy-policy.html          # App privacy policy
├── little_chick_mascot_3D.png   # Mascot for website
└── CNAME                        # Custom domain configuration

marketing/                       # App store materials
└── play_store_listing.txt       # Google Play Store metadata

infrastructure/                  # DevOps & deployment notes
└── dns-configuration-request.txt
```

## Key Features

- Single-page app with alphabet grid (A-Z)
- Tap letter → plays audio chant + shows popup with image
- Responsive grid adapts to screen orientation
- Audio stops current before playing new (handles rapid tapping)
- Graceful fallbacks for missing assets
- Teacher branding with customizable name and website link

## Dependencies

- `audioplayers: ^6.1.0` - Audio playback
- `url_launcher: ^6.2.1` - Open external URLs (teacher website)

## Dev Dependencies

- `flutter_launcher_icons: ^0.14.3` - Generate app icons
- `flutter_lints: ^6.0.0` - Linting rules

## Web Deployment

```bash
flutter build web --release --base-href "/phonics/alphabet/"
```

Upload `build/web/` contents to server. No code changes needed for web.

## GitHub Pages

The `docs/` folder contains the marketing website served at:
- **URL:** https://englishabc.englishteacher.com.tw
- **Purpose:** Closed testing landing page + privacy policy
- **Note:** Only files in `docs/` are web-accessible via GitHub Pages

## Asset Conventions

**Audio:** `assets/audio/{letter}.mp3` (e.g., `a.mp3`)
- Content: Voice saying "A A a a a, a is for apple"
- Format: MP3, ~60-65KB per file

**Images:** `assets/images/{letter}_{word}.webp` (e.g., `a_apple.webp`)
- Size: 512x512px recommended
- Format: WebP for smaller file sizes

## Word Associations

A-Apple, B-Ball, C-Cat, D-Dog, E-Elephant, F-Fish, G-Gorilla, H-Hat, I-Igloo, J-Jam, K-Kite, L-Lion, M-Monkey, N-Nurse, O-Octopus, P-Pig, Q-Queen, R-Rainbow, S-Sun, T-Turtle, U-Umbrella, V-Violin, W-Window, X-Fox, Y-Yellow, Z-Zebra

## Branding

Teacher: 李之茗外師
Website: https://www.englishteacher.com.tw/xsst/ywgssj/
Mascot: Little Chick (3D character)

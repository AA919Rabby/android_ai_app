# AI Chat App

A cross-platform AI chat application built with **Flutter**, **Firebase**, and **Google Generative AI**. Users sign in with **Google Sign-In**, chat with an AI assistant using text or voice, share images, and their conversations are saved in the cloud.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](#)

**[Watch the demo video](https://youtu.be/bk3znYpUq5g?si=CTDd2pjdANZncOuO)** · **[Download the Android APK](https://drive.google.com/file/d/1MbVEp_5PY4dLOMgfX5XezTbzXKKM8-XF/view?usp=drive_link)**

---

## Overview

This project demonstrates end-to-end mobile product development: authentication, a cloud database, generative AI integration, device features (microphone and camera/gallery), and a payments flow, all organized in a clean, modular codebase.

## Features

- **Google Sign-In**: secure, one-tap login powered by Firebase Authentication (Google is the only sign-in method).
- **AI assistant**: contextual responses powered by Google Generative AI (`google_generative_ai`).
- **Cloud-synced chat history**: messages and metadata stored in Cloud Firestore.
- **Voice input**: speech-to-text for hands-free messaging.
- **Image upload**: pick images from the gallery or camera with `image_picker`.
- **In-app payments**: Stripe integration via `flutter_stripe`.
- **Responsive UI**: adapts to different screen sizes with Flutter ScreenUtil.

## Tech Stack

| Area | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Authentication | Firebase Auth + Google Sign-In |
| Database | Cloud Firestore |
| AI | Google Generative AI (`google_generative_ai`) |
| State management & routing | GetX |
| Payments | `flutter_stripe` |
| Device features | `speech_to_text`, `image_picker` |
| Networking | `http` |
| Local storage | `shared_preferences` |
| UI | `flutter_screenutil`, `google_fonts` |
| Utilities | `uuid`, `flutter_dotenv` (environment config) |

## Architecture

The app separates UI from data and shared code, with GetX handling state management, dependency injection, and navigation.

```
lib/
├── core/            # Shared widgets and theme
└── presentation/    # Screens, controllers, and data layer
android/             # Android native config
ios/                 # iOS native config
assets/              # Images and launcher icon
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio / Android SDK for Android builds
- Xcode for iOS builds (macOS only)
- A Firebase project with **Google** enabled as a sign-in provider

### Setup

```bash
# 1. Clone the repository and switch to the branch
git clone <your-repo-url>
cd <your-repo-folder>
git checkout Rabbi

# 2. Install dependencies
flutter pub get
```

### Configure environment variables

Create a `.env` file in the project root (copy `.env.example` if it exists) and add your keys:

```env
GEMINI_API_KEY=your_google_generative_ai_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
```

> Variable names may differ; check the `lib/` code for the exact keys used.

### Firebase setup

1. Create a Firebase project and add your Android/iOS app.
2. Enable **Google** under *Authentication → Sign-in method*.
3. Add your SHA-1 / SHA-256 fingerprints to the Firebase Android app (required for Google Sign-In).
4. Place `google-services.json` in `android/app/` (and `GoogleService-Info.plist` in `ios/Runner/` for iOS).
5. Create a Cloud Firestore database and set appropriate security rules.

### Run

```bash
flutter run
```

### Build a release APK

```bash
flutter build apk --release
```

## Security Notes

- API keys are loaded from a `.env` file and are **not** committed to the repository.
- Never commit production secrets or signing keystores. Use CI secret stores for release builds.
- Review your Firestore security rules before deploying to production.

## Roadmap

- Unit, widget, and integration tests
- Response streaming for the AI assistant
- Offline message caching
- Play Store listing

## License

No license is currently specified. Add one (for example, MIT) if you want others to reuse this code.

## Author

**Rabbi**: Flutter developer
Branch: `Rabbi`
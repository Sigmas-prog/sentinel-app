# Sentinel DedSec Edition v6.2

## Android release build fix

- Upgraded `file_picker` from `8.1.7` to the compatible `10.3.11` line.
- Set the Android application `compileSdk` to API 36.
- Kept `minSdk` at API 21 for Android 5.0 support.
- Pinned GitHub Actions to Flutter `3.44.8` for reproducible builds.
- Made the generated Android project use API 36 before downloading packages
  and building the release APK.

This fixes `:file_picker:checkReleaseAarMetadata`, where the old plugin was
compiled against Android API 34 while `flutter_plugin_android_lifecycle`
required API 36.

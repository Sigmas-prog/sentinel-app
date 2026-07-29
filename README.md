# Sentinel Marcus Hub

Интерактивный Flutter-хаб в неоновой пиксельной стилистике, вдохновлённой
телефонными интерфейсами Watch Dogs. Это самостоятельное Android-приложение,
не системный лаунчер и не копия игровых материалов.

## Реальные модули

- **NET** — скан доступных Wi‑Fi сетей: SSID, BSSID, dBm, канал и частота.
- **DEVICES** — модель, Android/API, заряд, SSID, IP, шлюз и маска сети.
- **LENS** — системная камера через `image_picker` и локальный просмотр кадра.
- **CONSOLE** — безопасный список системных команд через `Process.run`.
- **MAP** — OpenStreetMap, Москва, Санкт‑Петербург, Париж и GPS телефона.
- **TOOLS** — локальная оценка пароля и 32-битный FNV‑1a.

## Android

- Минимальная версия: Android 5.0 / API 21.
- Wi‑Fi scan требует включённых Wi‑Fi и геолокации. Android ограничивает
  частоту сканирования.
- На Android 13+ требуется разрешение Nearby Wi‑Fi Devices.
- Некоторые прошивки не содержат `ifconfig`; консоль покажет честную ошибку.
- Для карты необходим интернет.

## Сборка

```bash
flutter pub get
flutter analyze lib --no-fatal-infos
flutter build apk --release
```

APK появится в:

```text
build/app/outputs/flutter-apk/app-release.apk
```

GitHub Actions автоматически выполняет те же действия и сохраняет артефакт
`sentinel-marcus-hub-release`.

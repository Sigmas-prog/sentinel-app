# Sentinel App

Sentinel — Flutter-приложение для визуальной диагностики сети в стилистике Watch Dogs. Работает на Android (minSdk 21) и iOS; для Android доступен реальный список Wi‑Fi, системные сведения, терминал диагностических команд и анимированный экран визуализации.

## Что умеет

- Главная панель: модель устройства, заряд, активная Wi‑Fi сеть и IP-адрес.
- Wi‑Fi: SSID, BSSID, мощность сигнала и вычисленный канал.
- Терминал: `help`, `scan`, `showip`, `test`, `ping <адрес>`.
- Анимированный фон с сеткой и точками.
- Экран Data Visualizer — локальный эффект с индикатором выполнения.
- Карта города с определением текущей позиции.
- Хаб телефона в стиле Watch Dogs: камера, локальные заметки, медиа-визуализатор, профиль, гардероб и тренировочный дрон-симулятор.
- City View: интерактивная карта OpenStreetMap и твоя геопозиция.
- Lens: съёмка с камеры и выбор кадра из галереи.
- Media: неоновый плеер и плейлист.
- Chat: локальные заметки в формате переписки.
- Contacts: стилизованный список команды и их статусов.
- Profile: личный экран устройства.

## Важно для Android

Android 10+ не позволяет обычному приложению получить реальный MAC устройства, поэтому интерфейс честно отображает его как недоступный. Для Wi‑Fi поиска на Android 13+ требуется разрешение «Устройства поблизости», а также включённые службы геолокации.

Карта загружается из интернета. Местоположение и камера запрашивают разрешение только при запуске соответствующей функции.

## Структура

```text
sentinel_app/
├── lib/                  # Dart-код приложения
├── assets/fonts/         # Моноширинный шрифт
├── assets/icons/         # Иконка приложения
├── android/              # Android-манифест и minSdk 21
├── ios/                  # создаётся командой Flutter ниже
└── pubspec.yaml
```

## Сборка и запуск

### Только с телефона: сборка APK в браузере

Termux удобно использовать для распаковки, редактирования и отправки проекта в GitHub. Саму Flutter-сборку лучше запускать через включённый в проект GitHub Actions: Android SDK для сборки APK не рассчитан на ARM-телефоны и в Termux обычно не работает.

1. Скачайте и распакуйте архив в Termux:

   ```bash
   pkg update && pkg install unzip git
   termux-setup-storage
   cd ~/storage/downloads
   tar -xzf Sentinel-app-phone-build.tar.gz
   cd sentinel_app
   ```

2. Создайте пустой репозиторий на GitHub, затем выполните в Termux (подставьте свой логин):

   ```bash
   git init
   git add .
   git commit -m "Sentinel app"
   git branch -M main
   git remote add origin https://github.com/ВАШ_ЛОГИН/sentinel-app.git
   git push -u origin main
   ```

3. Откройте в браузере репозиторий → **Actions** → **Build Android APK** → **Run workflow**. Когда процесс станет зелёным, откройте его и скачайте `sentinel-app-release` в блоке **Artifacts**. Внутри будет `app-release.apk`.

4. Откройте APK в «Загрузках» и разрешите установку из этого источника, если Android спросит.

### Сборка на компьютере

1. Установите Flutter SDK с [официальной страницы](https://docs.flutter.dev/get-started/install), затем проверьте окружение:

   ```bash
   flutter doctor
   ```

2. Перейдите в папку проекта и создайте служебные файлы платформ. Команда не перезаписывает папку `lib`:

   ```bash
   cd sentinel_app
   flutter create --platforms=android,ios .
   ```

3. Если Flutter спросит о перезаписи Android-файлов, сохраните версии из этого проекта для `AndroidManifest.xml` и `app/build.gradle`; они содержат разрешения и `minSdk 21`.

4. Установите зависимости:

   ```bash
   flutter pub get
   ```

5. На телефоне включите «Для разработчиков» → «Отладка по USB», подключите его и проверьте:

   ```bash
   flutter devices
   ```

6. Запустите приложение:

   ```bash
   flutter run
   ```

7. Для APK:

   ```bash
   flutter build apk --release
   ```

Готовый APK появится в `build/app/outputs/flutter-apk/app-release.apk`.

## Шрифт и иконка

В проект включён рабочий `DejaVuSansMono.ttf` под семейством `SentinelMono`. Чтобы использовать Hack Nerd Font, положите его в `assets/fonts/HackNerdFont-Regular.ttf` и замените путь шрифта в `pubspec.yaml` — больше менять ничего не требуется. Исходник иконки лежит рядом как `assets/icons/sentinel_icon.svg`; PNG создаётся при подготовке проекта.

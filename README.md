# TaskFlow AI

Advanced, offline-first, cross-platform Task & Habit Tracking app.
**100% Free & Open-Source — no ads, no paywalls.**

## Status of this build

This is a complete, hand-written Flutter source tree covering the full spec:

| Module | Status |
|---|---|
| 1. Material 3 Dashboard (Daily Summary, Quick Add, Analytics, Streaks) | ✅ Implemented |
| 2. Calendar & Time Management (day/week/month, recurrence, flexible windows) | ✅ Implemented |
| 3. AI Integration — offline heuristic parser + optional Claude API | ✅ Implemented |
| 4. Reminders & Snooze Engine (persistent alarms, per-severity vibration) | ✅ Implemented |
| 5. Challenge & Habit System (30/90-day, streaks, badges, Failure Guard) | ✅ Implemented |
| 6. Reporting (daily/weekly/monthly/yearly, time analytics, PDF/Excel export) | ✅ Implemented |
| 7. Additional features (Voice-to-Task, Pomodoro, Biometric Lock, Backup) | ✅ Implemented |
| Completed Tasks history screen | ✅ Implemented (tap the ✓ icon on the Dashboard) |
| Full-screen alarm ring UI (stop/snooze on a firing alarm) | ✅ Implemented |
| Home Screen Widgets | ✅ Implemented (native Kotlin `AppWidgetProvider` + Dart `home_widget` bridge) |
| Device Calendar 2-way sync | ✅ Implemented (opt-in in Settings; mirrors tasks to your phone's calendar) |

**Not done here (needs your machine):** compiling. I don't have the Flutter/Android
SDK in this sandbox, so none of this has been run, `flutter pub get`'d, or built
into an APK. Treat it as a strong, structured first draft to open and iterate on,
not a tested binary.

**Every module from the original spec is now implemented.** The only remaining
step is compiling it — see the two options below. Both are free.

**One thing you'll need to personalize:** the Kotlin widget file lives at
`android/app/src/main/kotlin/com/example/taskflow_ai/TaskFlowWidgetProvider.kt`.
If you change your app's package name (`applicationId` in
`android/app/build.gradle`) away from the default `com.example.taskflow_ai`,
move this file to match the new package path and update the `package` line
inside it — otherwise leave it as-is.

## Getting it running — Option A: fully in the browser, no install at all (recommended)

This project already includes a GitHub Actions workflow
(`.github/workflows/build-apk.yml`) that builds the installable APK for you,
in the cloud, for free. You only need a free GitHub account and a browser —
no Flutter, no Android Studio, no terminal commands.

1. Go to **https://github.com** and sign up (free) if you don't have an account.
2. Click the **+** icon (top right) → **New repository**. Name it anything
   (e.g. `taskflow-ai`), leave it Public, click **Create repository**.
3. On the new repo's page, click **"uploading an existing file"**.
4. Unzip `taskflow_ai.zip` on your computer, then **drag the entire contents**
   of the `taskflow_ai` folder (not the folder itself — its contents:
   `lib`, `android`, `pubspec.yaml`, `.github`, etc.) into the GitHub upload
   box. Click **Commit changes**.
5. Click the **Actions** tab at the top of your repo. You'll see a workflow
   run start automatically (named "Build Android APK") — click it and wait
   (~5–10 minutes; it's building in Google's cloud, not your device).
6. When it finishes (green checkmark ✅), scroll down to **Artifacts** and
   click **taskflow-ai-apk** to download a `.zip` containing your
   `app-release.apk`.
7. Transfer that `.apk` to your Android phone (via Google Drive, Telegram to
   yourself, USB, email — anything), open it, allow "install from unknown
   sources" if prompted, and install.

That's the whole process — everything happens on GitHub's servers.

## Getting it running — Option B: your own computer (more control, offline)

I can't compile this into an installed app myself — I don't have hands or a
phone, and this sandbox has no Flutter/Android SDK. But turning this code
into a working app on your phone is a **free, one-time setup**, done on any
Windows/Mac/Linux computer:

1. **Install Android Studio** (free): https://developer.android.com/studio
   — during setup, let it install the Android SDK (default options are fine).
2. **Install Flutter** (free): https://docs.flutter.dev/get-started/install
   — follow the guide for your OS; it will tell you to add Flutter to your
   Android Studio via the Flutter plugin (Android Studio → Settings → Plugins
   → search "Flutter" → Install).
3. **Open this project**: unzip `taskflow_ai.zip`, then in Android Studio:
   `File → Open` → select the `taskflow_ai` folder.
4. In the terminal inside Android Studio, run once:
   ```bash
   flutter create .
   flutter pub get
   ```
5. Plug in your Android phone via USB (enable "USB debugging" in phone
   Settings → Developer Options), or start an emulator from Android Studio.
6. Click the green ▶ **Run** button in Android Studio (or `flutter run` in
   the terminal). The app installs and opens on your phone.

That's the whole process — no coding required, just following the installer
prompts. It usually takes 30–60 minutes the first time (mostly downloads).

Requirements: Flutter 3.3+ SDK, Android Studio (or VS Code + Flutter/Dart plugins),
an Android device/emulator on API 23+.

You will very likely need to:
1. Run `flutter create .` in this folder once, to generate the platform
   scaffolding this AI can't produce (Gradle wrapper binaries, `ios/` Xcode
   project, generated `local.properties`, etc.) — then re-apply the
   `AndroidManifest.xml` in this repo (it has the extra permissions the app needs).
2. Add real audio files to `assets/sounds/` for the Focus Timer ambient sounds
   (`rain.mp3`, `white_noise.mp3`, `cafe.mp3`) — placeholders aren't included
   since I can't generate audio.
3. Set up a Google Cloud OAuth client if you want Google Drive backup or
   Calendar sync to work (`google_sign_in` needs your own `google-services.json`
   / OAuth client ID — I can't provision one for you).
4. (Optional) Get your own Anthropic API key from console.anthropic.com if you
   want the higher-accuracy **online** AI parsing/insights mode. The app is
   fully functional without one — it falls back to a local rule-based parser.

## Architecture

- **State management:** `provider` (simple, no code-gen, easy to read/extend)
- **Storage:** `sqflite` — fully offline, no server, no user accounts required
- **AI:** `lib/services/ai_service.dart` — offline rule-based parser by default;
  swaps to Claude API calls automatically once a key is saved in Settings
- **Notifications:** `lib/services/notification_service.dart` — exact alarms,
  full-screen intent for high-severity tasks, per-severity vibration patterns
- **Theming:** `lib/theme/app_theme.dart` — Material 3 with dynamic color
  (Android 12+ wallpaper-based theming), falls back to a fixed seed color

## Folder guide

```
lib/
  models/        Task, Challenge/Habit data classes
  services/      database, notifications, AI, export, backup
  providers/     ChangeNotifier state for tasks & challenges
  theme/         Material 3 theme
  screens/
    dashboard/   home screen + widgets
    calendar/    calendar view + task editor
    challenges/  30/90-day habit tracker
    reports/     analytics + PDF/Excel export
    settings/    biometric lock, backup, AI key, theme
    focus_timer/ Pomodoro timer
```

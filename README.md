name: taskflow_ai
description: "TaskFlow AI - Advanced Cross-Platform Task & Habit Tracking App (Free & Open-Source)"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  sqflite: ^2.3.3
  path_provider: ^2.1.3
  path: ^1.9.0
  google_sign_in: ^6.2.1
  googleapis: ^13.2.0
  extension_google_sign_in_as_googleapis_auth: ^2.0.12
  table_calendar: ^3.1.2
  device_calendar: ^4.3.2
  flutter_local_notifications: ^17.2.2
  android_alarm_manager_plus: ^4.0.4
  vibration: ^2.0.0
  timezone: ^0.9.4
  fl_chart: ^0.68.0
  http: ^1.2.1
  speech_to_text: ^7.0.0
  audioplayers: ^6.0.0
  local_auth: ^2.3.0
  home_widget: ^0.6.0
  pdf: ^3.11.0
  printing: ^5.13.0
  excel: ^4.0.6
  share_plus: ^9.0.0
  intl: ^0.19.0
  uuid: ^4.4.0
  shared_preferences: ^2.2.3
  flutter_colorpicker: ^1.1.0
  dynamic_color: ^1.7.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11

flutter:
  uses-material-design: true
  assets:
    - assets/sounds/

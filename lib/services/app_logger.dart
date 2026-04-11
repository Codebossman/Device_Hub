import 'package:flutter/foundation.dart';

class AppLogger {
  static const bool bleEnabled = false;

  static void ble(String message) {
    if (bleEnabled && kDebugMode) {
      debugPrint(message);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void error(String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint(error == null ? message : '$message: $error');
    }
  }
}

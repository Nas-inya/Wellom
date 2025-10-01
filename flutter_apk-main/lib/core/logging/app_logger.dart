import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

@singleton
class AppLogger {
  final Logger _logger;
  final FirebaseCrashlytics? _crashlytics;

  AppLogger(this._crashlytics)
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            printTime: true,
          ),
        );

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    _logToCrashlytics(message, error, stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    _logToCrashlytics(message, error, stackTrace);
  }

  void _logToCrashlytics(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_crashlytics != null && !kDebugMode) {
      _crashlytics!.recordError(
        error ?? message,
        stackTrace,
        reason: message,
      );
    }
  }

  Future<void> setUserIdentifier(String userId) async {
    if (_crashlytics != null && !kDebugMode) {
      await _crashlytics!.setUserIdentifier(userId);
    }
  }

  Future<void> setAttribute(String key, String value) async {
    if (_crashlytics != null && !kDebugMode) {
      await _crashlytics!.setCustomKey(key, value);
    }
  }
}
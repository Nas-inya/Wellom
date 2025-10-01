import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
class AppError with _$AppError {
  const factory AppError.network({
    required String message,
    int? statusCode,
    String? endpoint,
  }) = NetworkError;

  const factory AppError.api({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ApiError;

  const factory AppError.unauthorized({
    String? message,
    @Default(false) bool needsReauthentication,
  }) = UnauthorizedError;

  const factory AppError.validation({
    required String message,
    Map<String, List<String>>? fieldErrors,
  }) = ValidationError;

  const factory AppError.security({
    required String message,
    String? type,
  }) = SecurityError;

  const factory AppError.quantum({
    required String message,
    String? algorithm,
    String? detail,
  }) = QuantumError;

  const factory AppError.unexpected({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) = UnexpectedError;
}

extension AppErrorX on AppError {
  String get userFriendlyMessage {
    return map(
      network: (e) => 'Connection error. Please check your internet connection and try again.',
      api: (e) => e.message,
      unauthorized: (e) => e.message ?? 'Your session has expired. Please sign in again.',
      validation: (e) => e.message,
      security: (e) => 'A security error occurred. Please try again.',
      quantum: (e) => 'Quantum security verification failed. Please try again.',
      unexpected: (e) => 'An unexpected error occurred. Please try again later.',
    );
  }

  bool get isRecoverable {
    return map(
      network: (_) => true,
      api: (e) => e.code != 'fatal',
      unauthorized: (e) => !e.needsReauthentication,
      validation: (_) => true,
      security: (e) => e.type != 'critical',
      quantum: (_) => true,
      unexpected: (_) => false,
    );
  }

  bool get requiresReauthentication {
    return maybeMap(
      unauthorized: (e) => e.needsReauthentication,
      orElse: () => false,
    );
  }
}
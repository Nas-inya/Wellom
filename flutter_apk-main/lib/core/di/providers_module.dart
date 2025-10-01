import 'package:injectable/injectable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_controller.dart';
import '../providers/payment_controller.dart';
import '../providers/scanner_controller.dart';
import '../providers/config_controller.dart';
import '../logging/app_logger.dart';

@module
abstract class ProvidersModule {
  @singleton
  ProviderContainer getProviderContainer(AppLogger logger) {
    return ProviderContainer(
      observers: [
        ProviderLogger(logger),
      ],
    );
  }

  @singleton
  AuthController getAuthController(
    AuthService authService,
    AppLogger logger,
    AnalyticsService analyticsService,
  ) {
    return AuthController(
      authService,
      logger,
      analyticsService,
    );
  }

  @singleton
  PaymentController getPaymentController(
    PaymentService paymentService,
    AppLogger logger,
    AnalyticsService analyticsService,
  ) {
    return PaymentController(
      paymentService,
      logger,
      analyticsService,
    );
  }

  @singleton
  ScannerController getScannerController(
    ScannerService scannerService,
    AppLogger logger,
    AnalyticsService analyticsService,
  ) {
    return ScannerController(
      scannerService,
      logger,
      analyticsService,
    );
  }

  @singleton
  ConfigController getConfigController(
    StorageService storageService,
    AppLogger logger,
  ) {
    return ConfigController(
      storageService,
      logger,
    );
  }
}

class ProviderLogger extends ProviderObserver {
  final AppLogger _logger;

  ProviderLogger(this._logger);

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.debug(
      'Provider ${provider.name ?? provider.runtimeType} updated: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    _logger.debug(
      'Provider ${provider.name ?? provider.runtimeType} added: $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    _logger.debug(
      'Provider ${provider.name ?? provider.runtimeType} disposed',
    );
  }
}
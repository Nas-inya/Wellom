import 'package:injectable/injectable.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../services/scanner_service.dart';
import '../services/analytics_service.dart';
import '../services/storage_service.dart';
import '../logging/app_logger.dart';

@module
abstract class ServicesModule {
  @singleton
  AuthService getAuthService(
    ApiService apiService,
    SecureStorageService secureStorage,
    AppLogger logger,
    EncryptionService encryptionService,
  ) {
    return AuthService(
      apiService,
      secureStorage,
      logger,
      encryptionService,
    );
  }

  @singleton
  PaymentService getPaymentService(
    ApiService apiService,
    AppLogger logger,
    EncryptionService encryptionService,
    AnalyticsService analyticsService,
  ) {
    return PaymentService(
      apiService,
      logger,
      encryptionService,
      analyticsService,
    );
  }

  @singleton
  ScannerService getScannerService(
    ApiService apiService,
    AppLogger logger,
    StorageService storageService,
    AnalyticsService analyticsService,
  ) {
    return ScannerService(
      apiService,
      logger,
      storageService,
      analyticsService,
    );
  }

  @singleton
  AnalyticsService getAnalyticsService(
    FirebaseAnalytics analytics,
    AppLogger logger,
  ) {
    return AnalyticsService(analytics, logger);
  }

  @singleton
  StorageService getStorageService(
    AppLogger logger,
    CacheManager cacheManager,
    SecureStorageService secureStorage,
  ) {
    return StorageService(
      logger,
      cacheManager,
      secureStorage,
    );
  }
}
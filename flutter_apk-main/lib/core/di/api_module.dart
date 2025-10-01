import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../network/api_service.dart';
import '../network/interceptors/auth_interceptor.dart' as auth;
import '../network/interceptors/cache_interceptor.dart' as cache;
import '../network/interceptors/error_interceptor.dart' as error;
import '../network/interceptors/retry_interceptor.dart' as retry;
import '../network/interceptors/logging_interceptor.dart' as logging;
import '../services/secure_storage_service.dart';
import '../logging/app_logger.dart';
import '../cache/cache_manager.dart';
import '../network/network_manager.dart';
import '../network/request_queue_manager.dart';

@module
abstract class ApiModule {
  @singleton
  Dio getDio(
    AppLogger logger,
    NetworkManager networkManager,
    CacheManager cacheManager,
    SecureStorageService secureStorage,
  ) {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.tumorheal.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    ));

    // Initialize interceptors
    final authInterceptor = auth.AuthInterceptor(
      logger: logger,
      secureStorage: secureStorage,
    );

    final cacheInterceptor = cache.CacheInterceptor(
      logger: logger,
      cache: cacheManager,
    );

    final retryInterceptor = retry.RetryInterceptor(
      logger: logger,
      dio: dio,
    );

    final errorInterceptor = error.ErrorInterceptor(
      logger: logger,
    );

    final loggingInterceptor = logging.LoggingInterceptor(
      logger: logger,
    );

    // Add interceptors in order of execution
    dio.interceptors.addAll([
      authInterceptor,
      cacheInterceptor,
      retryInterceptor,
      errorInterceptor,
      loggingInterceptor,
    ]);

    return dio;
  }

  @singleton
  ApiService getApiService(
    Dio dio,
    AppLogger logger,
    NetworkManager networkManager,
    CacheManager cacheManager,
  ) {
    return ApiService(dio, logger, networkManager, cacheManager);
  }

  @singleton
  AuthInterceptor getAuthInterceptor(
    AppLogger logger,
    SecureStorageService secureStorage,
  ) {
    return AuthInterceptor(logger, secureStorage);
  }

  @singleton
  CacheInterceptor getCacheInterceptor(
    AppLogger logger,
    CacheManager cacheManager,
  ) {
    return CacheInterceptor(logger, cacheManager);
  }

  @singleton
  RetryInterceptor getRetryInterceptor(
    AppLogger logger,
    NetworkManager networkManager,
  ) {
    return RetryInterceptor(logger, networkManager);
  }

  @singleton
  ErrorInterceptor getErrorInterceptor(
    AppLogger logger,
  ) {
    return ErrorInterceptor(logger);
  }

  @singleton
  LoggingInterceptor getLoggingInterceptor(
    AppLogger logger,
  ) {
    return LoggingInterceptor(logger);
  }

  @singleton
  RequestQueueManager getRequestQueueManager(
    AppLogger logger,
  ) {
    return RequestQueueManager(logger);
  }

  @singleton
  RateLimiter getRateLimiter(
    AppLogger logger,
  ) {
    return RateLimiter(logger);
  }
}
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../error/failures.dart';

class ApiClient {
  ApiClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: const {'Content-Type': 'application/json'},
            ),
          );
  final Dio dio;
}

Failure mapDioError(Object error) {
  if (error is! DioException) return const ServerFailure();
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return const NetworkFailure();
  }
  final status = error.response?.statusCode;
  if (status == 400 || status == 401 || status == 403) {
    return const UnauthorizedFailure();
  }
  return const ServerFailure();
}

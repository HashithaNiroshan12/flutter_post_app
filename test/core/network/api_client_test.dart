import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/api_client.dart';

void main() {
  group('mapDioError', () {
    RequestOptions options() => RequestOptions(path: '/posts');

    test('mapDioError_onConnectionError_returnsNetworkFailure', () {
      final error = DioException(
        requestOptions: options(),
        type: DioExceptionType.connectionError,
      );
      expect(mapDioError(error), isA<NetworkFailure>());
    });

    test('mapDioError_onTimeout_returnsNetworkFailure', () {
      final error = DioException(
        requestOptions: options(),
        type: DioExceptionType.receiveTimeout,
      );
      expect(mapDioError(error), isA<NetworkFailure>());
    });

    test('mapDioError_on400_returnsUnauthorizedFailure', () {
      final error = DioException(
        requestOptions: options(),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options(), statusCode: 400),
      );
      expect(mapDioError(error), isA<UnauthorizedFailure>());
    });

    test('mapDioError_on500_returnsServerFailure', () {
      final error = DioException(
        requestOptions: options(),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options(), statusCode: 500),
      );
      expect(mapDioError(error), isA<ServerFailure>());
    });

    test('mapDioError_onUnknownError_returnsServerFailure', () {
      expect(mapDioError(Exception('boom')), isA<ServerFailure>());
    });
  });
}
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/network/api_client.dart';
import 'package:posts_app/core/network/api_endpoints.dart';
import 'package:posts_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late DioAuthRemoteDataSource dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = DioAuthRemoteDataSource(ApiClient(dio: dio));
  });

  tearDown(() => resetMocktailState());

  Response<Map<String, dynamic>> mockResponse(Map<String, dynamic> data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        statusCode: 200,
        data: data,
      );

  group('DioAuthRemoteDataSource.login', () {
    test('login_withCredentials_sendsRequestAndReturnsLoginResponse', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          ApiEndpoints.login,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => mockResponse(const {
          'accessToken': 'token123',
          'id': 1,
          'username': 'emilys',
          'firstName': 'Emily',
          'lastName': 'Johnson',
          'email': 'emily@example.com',
        }),
      );

      final response = await dataSource.login('emilys', 'emilyspass');

      verify(
        () => dio.post<Map<String, dynamic>>(
          ApiEndpoints.login,
          data: {'username': 'emilys', 'password': 'emilyspass', 'expiresInMins': 30},
        ),
      ).called(1);
      expect(response.accessToken, 'token123');
      expect(response.user.username, 'emilys');
    });

    test('login_onMissingAccessToken_throwsFormatException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          ApiEndpoints.login,
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => mockResponse(const {'id': 1}));

      expect(
        () => dataSource.login('emilys', 'emilyspass'),
        throwsFormatException,
      );
    });
  });

  group('DioAuthRemoteDataSource.currentUser', () {
    test('currentUser_withToken_sendsAuthorizationHeader', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.currentUser,
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ApiEndpoints.currentUser),
          statusCode: 200,
          data: const {
            'id': 1,
            'username': 'emilys',
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'email': 'emily@example.com',
          },
        ),
      );

      final user = await dataSource.currentUser('token');

      final captured = verify(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.currentUser,
          options: captureAny(named: 'options'),
        ),
      ).captured;
      final options = captured.single as Options;
      expect(options.headers, contains('Authorization'));
      expect(options.headers?['Authorization'], 'Bearer token');
      expect(user.username, 'emilys');
    });

    test('currentUser_onNullData_throwsFormatException', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.currentUser,
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ApiEndpoints.currentUser),
          statusCode: 200,
        ),
      );

      expect(() => dataSource.currentUser('token'), throwsFormatException);
    });
  });
}
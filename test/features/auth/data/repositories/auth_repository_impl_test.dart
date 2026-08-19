import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/result.dart';
import 'package:posts_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:posts_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:posts_app/features/auth/data/models/login_response.dart';
import 'package:posts_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:posts_app/features/auth/domain/entities/app_user.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late _MockAuthRemoteDataSource remote;
  late _MockAuthLocalDataSource local;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockAuthRemoteDataSource();
    local = _MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(remote, local);
  });

  tearDown(() => resetMocktailState());

  const user = AppUser(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily@example.com',
  );
  const loginResponse = LoginResponse(user: user, accessToken: 'token123');

  group('login', () {
    test('login_withValidCredentials_returnsUserAndStoresToken', () async {
      when(() => remote.login('emilys', 'emilyspass')).thenAnswer(
        (_) async => loginResponse,
      );
      when(() => local.saveToken('token123')).thenAnswer((_) async {});

      final result = await repository.login('emilys', 'emilyspass');

      expect(result, isA<Success<AppUser>>());
      expect((result as Success<AppUser>).value, user);
      verify(() => local.saveToken('token123')).called(1);
    });

    test('login_onWrongCredentials_returnsUnauthorizedFailure', () async {
      when(() => remote.login(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(path: '/auth/login'), statusCode: 401),
        ),
      );

      final result = await repository.login('emilys', 'wrongpass');

      expect(result, isA<FailureResult<AppUser>>());
      expect((result as FailureResult<AppUser>).failure, isA<UnauthorizedFailure>());
    });

    test('login_onNetworkError_returnsNetworkFailure', () async {
      when(() => remote.login(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.login('emilys', 'emilyspass');

      expect((result as FailureResult<AppUser>).failure, isA<NetworkFailure>());
    });

    test('login_onMalformedResponse_returnsParsingFailure', () async {
      when(() => remote.login(any(), any())).thenThrow(const FormatException());

      final result = await repository.login('emilys', 'emilyspass');

      expect((result as FailureResult<AppUser>).failure, isA<ParsingFailure>());
    });
  });

  group('restoreSession', () {
    test('restoreSession_withoutStoredToken_returnsNullUser', () async {
      when(() => local.readToken()).thenAnswer((_) async => null);

      final result = await repository.restoreSession();

      expect(result, isA<Success<AppUser?>>());
      expect((result as Success<AppUser?>).value, isNull);
      verifyNever(() => remote.currentUser(any()));
    });

    test('restoreSession_withStoredToken_returnsUserFromRemote', () async {
      when(() => local.readToken()).thenAnswer((_) async => 'token123');
      when(() => remote.currentUser('token123')).thenAnswer((_) async => user);

      final result = await repository.restoreSession();

      expect((result as Success<AppUser?>).value, user);
      verify(() => remote.currentUser('token123')).called(1);
    });

    test('restoreSession_onUnauthorized_clearsToken', () async {
      when(() => local.readToken()).thenAnswer((_) async => 'token123');
      when(() => remote.currentUser(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: RequestOptions(path: '/auth/me'), statusCode: 401),
        ),
      );
      when(() => local.clear()).thenAnswer((_) async {});

      final result = await repository.restoreSession();

      verify(() => local.clear()).called(1);
      expect((result as FailureResult<AppUser?>).failure, isA<UnauthorizedFailure>());
    });

    test('restoreSession_onNetworkError_returnsNetworkFailure', () async {
      when(() => local.readToken()).thenAnswer((_) async => 'token123');
      when(() => remote.currentUser(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.restoreSession();

      expect((result as FailureResult<AppUser?>).failure, isA<NetworkFailure>());
    });
  });

  group('logout', () {
    test('logout_clearsLocalStorage', () async {
      when(() => local.clear()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => local.clear()).called(1);
    });
  });
}
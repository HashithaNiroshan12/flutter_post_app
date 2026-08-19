import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/result.dart';
import 'package:posts_app/features/auth/domain/entities/app_user.dart';
import 'package:posts_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:posts_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:posts_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:posts_app/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:posts_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:posts_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:posts_app/features/auth/presentation/bloc/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repository = _MockAuthRepository();
  });

  tearDown(() => resetMocktailState());

  const user = AppUser(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily@example.com',
  );

  AuthBloc buildBloc() => AuthBloc(
    LoginUseCase(repository),
    RestoreSessionUseCase(repository),
    LogoutUseCase(repository),
  );

  blocTest<AuthBloc, AuthState>(
    'login_withValidCredentials_emitsAuthenticated',
    build: buildBloc,
    setUp: () {
      when(() => repository.login('emilys', 'emilyspass')).thenAnswer(
        (_) async => const Success(user),
      );
    },
    act: (bloc) => bloc.add(const LoginSubmitted('emilys', 'emilyspass')),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.submitting),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.authenticated)
          .having((s) => s.user, 'user', user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'login_withInvalidCredentials_emitsError',
    build: buildBloc,
    setUp: () {
      when(() => repository.login(any(), any())).thenAnswer(
        (_) async => const FailureResult(UnauthorizedFailure()),
      );
    },
    act: (bloc) => bloc.add(const LoginSubmitted('emilys', 'wrongpass')),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.submitting),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.unauthenticated)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'restoreSession_withSavedSession_emitsAuthenticated',
    build: buildBloc,
    setUp: () {
      when(() => repository.restoreSession()).thenAnswer(
        (_) async => const Success(user),
      );
    },
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.checking),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.authenticated)
          .having((s) => s.user, 'user', user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'restoreSession_withoutSession_emitsUnauthenticated',
    build: buildBloc,
    setUp: () {
      when(() => repository.restoreSession()).thenAnswer(
        (_) async => const Success(null),
      );
    },
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.checking),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.unauthenticated),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'logout_emitsUnauthenticated',
    build: buildBloc,
    setUp: () {
      when(() => repository.logout()).thenAnswer((_) async {});
    },
    seed: () => const AuthState(status: AuthStatus.authenticated, user: user),
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.unauthenticated),
    ],
  );
}
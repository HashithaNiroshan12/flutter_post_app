import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._loginUseCase,
    this._restoreSessionUseCase,
    this._logoutUseCase,
  ) : super(const AuthState()) {
    on<AuthStarted>(_restore);
    on<LoginSubmitted>(_login);
    on<LogoutRequested>(_logout);
  }
  final LoginUseCase _loginUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> _restore(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.checking));
    final result = await _restoreSessionUseCase(const NoParams());
    switch (result) {
      case Success(value: final user) when user != null:
        emit(AuthState(status: AuthStatus.authenticated, user: user));
      case FailureResult():
        emit(const AuthState(status: AuthStatus.unauthenticated));
      default:
        emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _login(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.submitting));
    final result = await _loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );
    switch (result) {
      case Success(value: final user):
        emit(AuthState(status: AuthStatus.authenticated, user: user));
      case FailureResult(failure: final failure):
        emit(
          AuthState(status: AuthStatus.unauthenticated, error: failure.message),
        );
    }
  }

  Future<void> _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _logoutUseCase(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
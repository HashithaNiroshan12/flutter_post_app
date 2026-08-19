import '../../domain/entities/app_user.dart';

enum AuthStatus { checking, unauthenticated, submitting, authenticated }

class AuthState {
  const AuthState({this.status = AuthStatus.checking, this.user, this.error});
  final AuthStatus status;
  final AppUser? user;
  final String? error;
  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    bool clearError = false,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    error: clearError ? null : error ?? this.error,
  );
}
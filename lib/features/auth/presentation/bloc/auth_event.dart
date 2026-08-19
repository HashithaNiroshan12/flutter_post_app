sealed class AuthEvent {
  const AuthEvent();
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted(this.username, this.password);
  final String username;
  final String password;
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
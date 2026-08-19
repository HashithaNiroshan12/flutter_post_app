sealed class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your username or password is incorrect.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'We could not read the server response.',
  ]);
}
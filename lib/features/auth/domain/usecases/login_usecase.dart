import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.username, required this.password});
  final String username;
  final String password;
}

class LoginUseCase implements UseCase<Result<AppUser>, LoginParams> {
  LoginUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<AppUser>> call(LoginParams params) =>
      _repository.login(params.username, params.password);
}
import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase implements UseCase<Result<AppUser?>, NoParams> {
  RestoreSessionUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<AppUser?>> call(NoParams params) => _repository.restoreSession();
}
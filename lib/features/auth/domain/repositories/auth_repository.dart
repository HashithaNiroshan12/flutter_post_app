import '../../../../core/network/result.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Result<AppUser>> login(String username, String password);
  Future<Result<AppUser?>> restoreSession();
  Future<void> logout();
}
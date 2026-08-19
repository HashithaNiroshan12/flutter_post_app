import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<AppUser>> login(String username, String password) async {
    try {
      final response = await _remote.login(username, password);
      await _local.saveToken(response.accessToken);
      return Success(response.user);
    } on FormatException {
      return const FailureResult(ParsingFailure());
    } catch (error) {
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }

  @override
  Future<Result<AppUser?>> restoreSession() async {
    final token = await _local.readToken();
    if (token == null || token.isEmpty) return const Success(null);
    try {
      return Success(await _remote.currentUser(token));
    } on FormatException {
      await _local.clear();
      return const FailureResult(ParsingFailure());
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 401) {
        await _local.clear();
      }
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }

  @override
  Future<void> logout() => _local.clear();
}

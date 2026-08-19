import 'package:dio/dio.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../domain/entities/app_user.dart';
import '../../models/login_response.dart';
import '../../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponse> login(String username, String password);
  Future<AppUser> currentUser(String token);
}

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  DioAuthRemoteDataSource(this._client);
  final ApiClient _client;
  @override
  Future<LoginResponse> login(String username, String password) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'username': username, 'password': password, 'expiresInMins': 30},
    );
    if (response.data == null) throw const FormatException();
    return LoginResponse.fromJson(response.data!);
  }

  @override
  Future<AppUser> currentUser(String token) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.currentUser,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data == null) throw const FormatException();
    return UserModel.fromJson(response.data!);
  }
}

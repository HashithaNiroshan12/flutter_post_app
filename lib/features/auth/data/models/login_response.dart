import '../../domain/entities/app_user.dart';
import 'user_model.dart';

class LoginResponse {
  const LoginResponse({required this.user, required this.accessToken});
  final AppUser user;
  final String accessToken;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['accessToken'] is! String) throw const FormatException();
    return LoginResponse(
      user: UserModel.fromJson(json),
      accessToken: json['accessToken'] as String,
    );
  }
}
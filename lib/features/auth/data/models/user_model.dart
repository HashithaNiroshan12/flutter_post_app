import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int? ?? 0,
    username: json['username'] as String? ?? '',
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    image: json['image'] as String?,
  );
}
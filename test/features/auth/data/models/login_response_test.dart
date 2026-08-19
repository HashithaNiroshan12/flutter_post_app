import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/features/auth/data/models/login_response.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('fromJson_withValidToken_mapsUserAndToken', () {
      final response = LoginResponse.fromJson(const {
        'accessToken': 'token123',
        'id': 1,
        'username': 'emilys',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'email': 'emily@example.com',
      });
      expect(response.accessToken, 'token123');
      expect(response.user.username, 'emilys');
      expect(response.user.firstName, 'Emily');
    });

    test('fromJson_withInvalidToken_throwsFormatException', () {
      expect(
        () => LoginResponse.fromJson(const {'accessToken': 123}),
        throwsFormatException,
      );
    });
  });
}
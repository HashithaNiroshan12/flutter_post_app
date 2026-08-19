import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('fromJson_withFullData_mapsAllFields', () {
      final user = UserModel.fromJson(const {
        'id': 1,
        'username': 'emilys',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'email': 'emily@example.com',
        'image': 'https://example.com/avatar.png',
      });
      expect(user.id, 1);
      expect(user.username, 'emilys');
      expect(user.firstName, 'Emily');
      expect(user.lastName, 'Johnson');
      expect(user.email, 'emily@example.com');
      expect(user.image, 'https://example.com/avatar.png');
    });

    test('fromJson_withMissingFields_usesDefaults', () {
      final user = UserModel.fromJson(const {});
      expect(user.id, 0);
      expect(user.username, '');
      expect(user.firstName, '');
      expect(user.lastName, '');
      expect(user.email, '');
      expect(user.image, isNull);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/features/posts/data/models/post_author_model.dart';

void main() {
  group('PostAuthorModel.fromJson', () {
    test('fromJson_withFullData_mapsFields', () {
      final author = PostAuthorModel.fromJson(const {
        'id': 17,
        'firstName': 'Evelyn',
        'lastName': 'Sanchez',
      });
      expect(author.id, 17);
      expect(author.firstName, 'Evelyn');
      expect(author.lastName, 'Sanchez');
      expect(author.displayName, 'Evelyn Sanchez');
      expect(author.initials, 'ES');
    });

    test('fromJson_withMissingFields_usesDefaults', () {
      final author = PostAuthorModel.fromJson(const {});
      expect(author.id, 0);
      expect(author.firstName, '');
      expect(author.lastName, '');
      expect(author.initials, '');
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';

void main() {
  group('PostModel.fromJson', () {
    test('fromJson_withReactions_mapsLikesAndDislikes', () {
      final post = PostModel.fromJson(const {
        'id': 1,
        'title': 'A post',
        'body': 'Body',
        'tags': ['tech', 'flutter'],
        'reactions': {'likes': 5, 'dislikes': 2},
        'views': 10,
        'userId': 3,
      });
      expect(post.id, 1);
      expect(post.title, 'A post');
      expect(post.body, 'Body');
      expect(post.tags, ['tech', 'flutter']);
      expect(post.likes, 5);
      expect(post.dislikes, 2);
      expect(post.views, 10);
      expect(post.userId, 3);
    });

    test('fromJson_withMissingFields_usesDefaults', () {
      final post = PostModel.fromJson(const {});
      expect(post.id, 0);
      expect(post.title, '');
      expect(post.body, '');
      expect(post.tags, isEmpty);
      expect(post.likes, 0);
      expect(post.dislikes, 0);
      expect(post.views, 0);
      expect(post.userId, 0);
    });
  });
}
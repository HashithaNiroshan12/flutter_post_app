import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/features/posts/data/models/post_comments_model.dart';

void main() {
  group('PostCommentsModel.fromJson', () {
    test('fromJson_withTotal_mapsTotal', () {
      final comments = PostCommentsModel.fromJson(const {'total': 3});
      expect(comments.total, 3);
    });

    test('fromJson_withMissingTotal_usesDefault', () {
      final comments = PostCommentsModel.fromJson(const {});
      expect(comments.total, 0);
    });
  });
}
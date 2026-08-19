import '../../../../core/network/result.dart';
import '../entities/post.dart';
import '../entities/post_author.dart';
import '../entities/post_comments.dart';

abstract interface class PostsRepository {
  Future<Result<PostsPage>> fetch({
    required int limit,
    required int skip,
    String? query,
  });
  Future<Result<Post>> detail(int id);
  Future<Result<PostAuthor>> author(int id);
  Future<Result<PostComments>> comments(int postId);
}
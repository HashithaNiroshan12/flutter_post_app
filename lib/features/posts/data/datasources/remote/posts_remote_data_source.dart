import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/entities/post_author.dart';
import '../../../domain/entities/post_comments.dart';
import '../../models/post_author_model.dart';
import '../../models/post_comments_model.dart';
import '../../models/post_model.dart';

abstract interface class PostsRemoteDataSource {
  Future<PostsPage> fetch({
    required int limit,
    required int skip,
    String? query,
  });
  Future<Post> detail(int id);
  Future<PostAuthor> author(int id);
  Future<PostComments> comments(int postId);
}

class DioPostsRemoteDataSource implements PostsRemoteDataSource {
  final ApiClient _client;

  DioPostsRemoteDataSource(this._client);

  @override
  Future<PostsPage> fetch({
    required int limit,
    required int skip,
    String? query,
  }) async {
    final path = query == null || query.isEmpty
        ? ApiEndpoints.posts
        : ApiEndpoints.searchPosts;
    final params = <String, dynamic>{'limit': limit, 'skip': skip};
    if (query != null && query.isNotEmpty) params['q'] = query;
    final response = await _client.dio.get<Map<String, dynamic>>(
      path,
      queryParameters: params,
    );
    return _page(response.data);
  }

  @override
  Future<Post> detail(int id) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.postDetail(id),
    );
    if (response.data == null) throw const FormatException();
    return PostModel.fromJson(response.data!);
  }

  @override
  Future<PostAuthor> author(int id) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.user(id),
    );
    if (response.data == null) throw const FormatException();
    return PostAuthorModel.fromJson(response.data!);
  }

  @override
  Future<PostComments> comments(int postId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      ApiEndpoints.postComments(postId),
    );
    if (response.data == null) throw const FormatException();
    return PostCommentsModel.fromJson(response.data!);
  }

  PostsPage _page(Map<String, dynamic>? data) {
    if (data == null || data['posts'] is! List) throw const FormatException();
    return PostsPage(
      posts: (data['posts'] as List)
          .whereType<Map<String, dynamic>>()
          .map(PostModel.fromJson)
          .toList(),
      total: data['total'] as int? ?? 0,
      skip: data['skip'] as int? ?? 0,
      limit: data['limit'] as int? ?? 0,
    );
  }
}

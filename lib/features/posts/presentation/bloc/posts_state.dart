import '../../domain/entities/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState {
  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.query = '',
    this.total = 0,
    this.isLoadingMore = false,
    this.error,
  });
  final PostsStatus status;
  final List<Post> posts;
  final String query;
  final int total;
  final bool isLoadingMore;
  final String? error;
  bool get hasMore => posts.length < total;
  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    String? query,
    int? total,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) => PostsState(
    status: status ?? this.status,
    posts: posts ?? this.posts,
    query: query ?? this.query,
    total: total ?? this.total,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: clearError ? null : error ?? this.error,
  );
}
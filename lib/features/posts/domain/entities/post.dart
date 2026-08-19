class Post {
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;
}

class PostsPage {
  const PostsPage({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;
}
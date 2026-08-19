abstract final class ApiEndpoints {
  static const login = '/auth/login';
  static const currentUser = '/auth/me';
  static const posts = '/posts';
  static const searchPosts = '/posts/search';
  static String postDetail(int id) => '/posts/$id';
  static String user(int id) => '/users/$id';
  static String postComments(int postId) => '/comments/post/$postId';
}

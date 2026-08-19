import '../../domain/entities/post.dart';

class PostDetailState {
  const PostDetailState({this.loading = true, this.post, this.error});
  final bool loading;
  final Post? post;
  final String? error;
}
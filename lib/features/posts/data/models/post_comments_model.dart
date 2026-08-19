import '../../domain/entities/post_comments.dart';

class PostCommentsModel extends PostComments {
  const PostCommentsModel({required super.total});

  factory PostCommentsModel.fromJson(Map<String, dynamic> json) =>
      PostCommentsModel(total: json['total'] as int? ?? 0);
}
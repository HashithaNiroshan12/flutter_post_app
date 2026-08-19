import '../../domain/entities/post_author.dart';

class PostAuthorModel extends PostAuthor {
  const PostAuthorModel({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  factory PostAuthorModel.fromJson(Map<String, dynamic> json) =>
      PostAuthorModel(
        id: json['id'] as int? ?? 0,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
      );
}
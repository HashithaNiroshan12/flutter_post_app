import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.likes,
    required super.dislikes,
    required super.views,
    required super.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] as Map<String, dynamic>? ?? {};
    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? []).whereType<String>().toList(),
      likes: reactions['likes'] as int? ?? 0,
      dislikes: reactions['dislikes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
    );
  }
}
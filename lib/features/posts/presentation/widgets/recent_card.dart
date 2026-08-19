import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_post_author_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';
import 'comment_count.dart';
import 'post_author_info.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({
    super.key,
    required this.post,
    required this.authorUseCase,
    required this.commentsUseCase,
    required this.onTap,
  });

  final Post post;
  final GetPostAuthorUseCase authorUseCase;
  final GetPostCommentsUseCase commentsUseCase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostAuthorInfo(userId: post.userId, useCase: authorUseCase),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'LexendDeca',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: appTheme().textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    Text(
                      '${post.likes}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'LexendDeca',
                      ),
                    ),
                    const SizedBox(width: 16),
                    CommentCount(postId: post.id, useCase: commentsUseCase),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

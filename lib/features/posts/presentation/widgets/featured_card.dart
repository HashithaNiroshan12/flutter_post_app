import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_post_author_usecase.dart';
import 'post_author_info.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({
    super.key,
    required this.post,
    required this.authorUseCase,
    required this.onTap,
  });

  final Post post;
  final GetPostAuthorUseCase authorUseCase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 280,
    child: Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      elevation: 5,
      shadowColor: AppColors.onSurface.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/book.png',
                width: 40,
                height: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                  fontFamily: 'LexendDeca',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 40, 12),
              child: PostAuthorInfo(
                userId: post.userId,
                useCase: authorUseCase,
                iconAvatar: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: AppColors.critical),
                    Text(
                      '${post.likes}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'LexendDeca',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

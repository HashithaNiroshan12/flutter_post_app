import 'package:flutter/material.dart';

import '../../../../core/network/result.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post_author.dart';
import '../../domain/usecases/get_post_author_usecase.dart';

class PostAuthorInfo extends StatefulWidget {
  const PostAuthorInfo({
    super.key,
    required this.userId,
    required this.useCase,
    this.iconAvatar = false,
    this.trailing,
  });

  final int userId;
  final GetPostAuthorUseCase useCase;
  final bool iconAvatar;
  final Widget? trailing;

  @override
  State<PostAuthorInfo> createState() => _PostAuthorInfoState();
}

class _PostAuthorInfoState extends State<PostAuthorInfo> {
  late final Future<Result<PostAuthor>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.useCase(PostAuthorParams(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<PostAuthor>>(
      future: _future,
      builder: (context, snapshot) {
        final author = switch (snapshot.data) {
          Success(value: final author) => author,
          _ => null,
        };
        final trailing = widget.trailing;
        return Row(
          children: [
            widget.iconAvatar
                ? const Icon(Icons.person, size: 17, color: AppColors.secondary)
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.line,
                    child: Text(
                      author?.initials ?? '?',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                        fontFamily: 'LexendDeca',
                      ),
                    ),
                  ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                author?.displayName ?? 'Loading...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.onSurface,
                  fontFamily: 'LexendDeca',
                ),
              ),
            ),
            if (trailing != null) ...[const Spacer(), trailing],
          ],
        );
      },
    );
  }
}

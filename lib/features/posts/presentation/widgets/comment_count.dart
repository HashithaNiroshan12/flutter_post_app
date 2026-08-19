import 'package:flutter/material.dart';

import '../../../../core/network/result.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post_comments.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';

class CommentCount extends StatefulWidget {
  const CommentCount({super.key, required this.postId, required this.useCase});

  final int postId;
  final GetPostCommentsUseCase useCase;

  @override
  State<CommentCount> createState() => _CommentCountState();
}

class _CommentCountState extends State<CommentCount> {
  late final Future<Result<PostComments>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.useCase(PostCommentsParams(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<PostComments>>(
      future: _future,
      builder: (context, snapshot) {
        final total = switch (snapshot.data) {
          Success(value: final comments) => comments.total,
          _ => 0,
        };
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outlined, size: 17),
            const SizedBox(width: 4),
            Text(
              '$total',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
                fontWeight: FontWeight.w300,
                fontFamily: 'LexendDeca',
              ),
            ),
          ],
        );
      },
    );
  }
}

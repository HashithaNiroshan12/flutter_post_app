import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/post_detail_bloc.dart';
import '../bloc/post_detail_state.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Post Detail')),
    body: BlocBuilder<PostDetailBloc, PostDetailState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) return Center(child: Text(state.error!));
        final post = state.post!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 54,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                post.body,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.tags
                    .map((tag) => Chip(label: Text('#$tag')))
                    .toList(),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  Text(' ${post.likes}'),
                  const SizedBox(width: 22),
                  const Icon(Icons.thumb_down_outlined),
                  Text(' ${post.dislikes}'),
                  const SizedBox(width: 22),
                  const Icon(Icons.visibility_outlined),
                  Text(' ${post.views}'),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
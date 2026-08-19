import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/result.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_app/features/posts/domain/usecases/fetch_posts_usecase.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts_event.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts_state.dart';

class _MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late _MockPostsRepository repository;

  setUpAll(() {
    registerFallbackValue(0);
    registerFallbackValue('');
  });

  setUp(() {
    repository = _MockPostsRepository();
  });

  tearDown(() => resetMocktailState());

  const post = Post(
    id: 1,
    title: 'A post',
    body: 'Body',
    tags: ['tech'],
    likes: 5,
    dislikes: 2,
    views: 10,
    userId: 3,
  );
  const page = PostsPage(posts: [post], total: 1, skip: 0, limit: 10);

  void mockFetch({
    int skip = 0,
    String? query,
    Result<PostsPage>? result,
  }) {
    when(
      () => repository.fetch(
        limit: any(named: 'limit'),
        skip: skip,
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => result ?? const Success(page));
  }

  blocTest<PostsBloc, PostsState>(
    'loadPosts_onSuccess_emitsLoadingThenSuccess',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    setUp: () => mockFetch(),
    act: (bloc) => bloc.add(const PostsLoaded()),
    expect: () => [
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.loading),
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.success)
          .having((s) => s.posts, 'posts', hasLength(1)),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'loadPosts_onNetworkError_emitsFailure',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    setUp: () => mockFetch(result: const FailureResult(NetworkFailure())),
    act: (bloc) => bloc.add(const PostsLoaded()),
    expect: () => [
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.loading),
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.failure)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'searchPosts_withQuery_debouncesAndLoadsResults',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    setUp: () => mockFetch(query: 'flutter'),
    act: (bloc) => bloc.add(const PostsSearchChanged('flutter')),
    wait: const Duration(milliseconds: 600),
    expect: () => [
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.loading)
          .having((s) => s.query, 'query', 'flutter'),
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.loading)
          .having((s) => s.query, 'query', 'flutter'),
      isA<PostsState>()
          .having((s) => s.status, 'status', PostsStatus.success)
          .having((s) => s.query, 'query', 'flutter'),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'loadMore_whenHasMore_appendsPosts',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [post],
      total: 3,
    ),
    setUp: () => mockFetch(
      skip: 1,
      result: const Success(
        PostsPage(posts: [post, post], total: 3, skip: 1, limit: 10),
      ),
    ),
    act: (bloc) => bloc.add(const PostsLoadMore()),
    expect: () => [
      isA<PostsState>()
          .having((s) => s.isLoadingMore, 'isLoadingMore', true),
      isA<PostsState>()
          .having((s) => s.isLoadingMore, 'isLoadingMore', false)
          .having((s) => s.posts, 'posts', hasLength(3)),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'loadMore_whenExhausted_doesNotFetch',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [post, post],
      total: 2,
    ),
    act: (bloc) => bloc.add(const PostsLoadMore()),
    expect: () => [],
    verify: (bloc) {
      verifyNever(
        () => repository.fetch(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          query: any(named: 'query'),
        ),
      );
    },
  );

  blocTest<PostsBloc, PostsState>(
    'loadMore_onNetworkError_emitsError',
    build: () => PostsBloc(FetchPostsUseCase(repository)),
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [post],
      total: 3,
    ),
    setUp: () => mockFetch(
      skip: 1,
      result: const FailureResult(NetworkFailure()),
    ),
    act: (bloc) => bloc.add(const PostsLoadMore()),
    expect: () => [
      isA<PostsState>()
          .having((s) => s.isLoadingMore, 'isLoadingMore', true),
      isA<PostsState>()
          .having((s) => s.isLoadingMore, 'isLoadingMore', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );
}
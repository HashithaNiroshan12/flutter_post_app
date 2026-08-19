import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/result.dart';
import 'package:posts_app/features/posts/data/datasources/remote/posts_remote_data_source.dart';
import 'package:posts_app/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/entities/post_author.dart';
import 'package:posts_app/features/posts/domain/entities/post_comments.dart';

class _MockPostsRemoteDataSource extends Mock implements PostsRemoteDataSource {}

void main() {
  late _MockPostsRemoteDataSource remote;
  late PostsRepositoryImpl repository;

  setUp(() {
    remote = _MockPostsRemoteDataSource();
    repository = PostsRepositoryImpl(remote);
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
  const author = PostAuthor(id: 17, firstName: 'Evelyn', lastName: 'Sanchez');
  const comments = PostComments(total: 3);

  DioException dioError(int statusCode) => DioException(
    requestOptions: RequestOptions(path: '/posts'),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(path: '/posts'),
      statusCode: statusCode,
    ),
  );

  group('fetch', () {
    test('fetchPosts_onSuccess_returnsPostsPage', () async {
      when(() => remote.fetch(limit: 10, skip: 0, query: null)).thenAnswer(
        (_) async => page,
      );

      final result = await repository.fetch(limit: 10, skip: 0);

      expect(result, isA<Success<PostsPage>>());
      expect((result as Success<PostsPage>).value.posts, hasLength(1));
    });

    test('fetchPosts_onNetworkError_returnsNetworkFailure', () async {
      when(() => remote.fetch(limit: 10, skip: 0, query: null)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/posts'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.fetch(limit: 10, skip: 0);

      expect((result as FailureResult<PostsPage>).failure, isA<NetworkFailure>());
    });

    test('fetchPosts_onServerError_returnsServerFailure', () async {
      when(() => remote.fetch(limit: 10, skip: 0, query: null)).thenThrow(
        dioError(500),
      );

      final result = await repository.fetch(limit: 10, skip: 0);

      expect((result as FailureResult<PostsPage>).failure, isA<ServerFailure>());
    });

    test('fetchPosts_onMalformedResponse_returnsParsingFailure', () async {
      when(() => remote.fetch(limit: 10, skip: 0, query: null)).thenThrow(
        const FormatException(),
      );

      final result = await repository.fetch(limit: 10, skip: 0);

      expect((result as FailureResult<PostsPage>).failure, isA<ParsingFailure>());
    });
  });

  group('detail', () {
    test('detail_withValidId_returnsPost', () async {
      when(() => remote.detail(1)).thenAnswer((_) async => post);

      final result = await repository.detail(1);

      expect((result as Success<Post>).value, post);
    });

    test('detail_onNetworkError_returnsNetworkFailure', () async {
      when(() => remote.detail(1)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/posts/1'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.detail(1);

      expect((result as FailureResult<Post>).failure, isA<NetworkFailure>());
    });
  });

  group('author', () {
    test('author_withValidId_returnsAuthor', () async {
      when(() => remote.author(17)).thenAnswer((_) async => author);

      final result = await repository.author(17);

      expect((result as Success<PostAuthor>).value, author);
    });

    test('author_onMalformedResponse_returnsParsingFailure', () async {
      when(() => remote.author(17)).thenThrow(const FormatException());

      final result = await repository.author(17);

      expect((result as FailureResult<PostAuthor>).failure, isA<ParsingFailure>());
    });
  });

  group('comments', () {
    test('comments_withPostId_returnsTotal', () async {
      when(() => remote.comments(6)).thenAnswer((_) async => comments);

      final result = await repository.comments(6);

      expect((result as Success<PostComments>).value.total, 3);
    });

    test('comments_onNetworkError_returnsNetworkFailure', () async {
      when(() => remote.comments(6)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/comments/post/6'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.comments(6);

      expect((result as FailureResult<PostComments>).failure, isA<NetworkFailure>());
    });
  });
}
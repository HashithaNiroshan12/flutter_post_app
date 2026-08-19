import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_app/core/network/api_client.dart';
import 'package:posts_app/core/network/api_endpoints.dart';
import 'package:posts_app/features/posts/data/datasources/remote/posts_remote_data_source.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late DioPostsRemoteDataSource dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = DioPostsRemoteDataSource(ApiClient(dio: dio));
  });

  tearDown(() => resetMocktailState());

  Response<Map<String, dynamic>> response(Map<String, dynamic> data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: ApiEndpoints.posts),
        statusCode: 200,
        data: data,
      );

  Map<String, dynamic> pageJson() => {
    'posts': [
      {
        'id': 1,
        'title': 'A post',
        'body': 'Body',
        'tags': ['tech'],
        'reactions': {'likes': 5, 'dislikes': 2},
        'views': 10,
        'userId': 3,
      },
    ],
    'total': 1,
    'skip': 0,
    'limit': 10,
  };

  group('DioPostsRemoteDataSource.fetch', () {
    test('fetchPosts_withoutQuery_hitsPostsEndpoint', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.posts,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response(pageJson()));

      final page = await dataSource.fetch(limit: 10, skip: 0, query: null);

      verify(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.posts,
          queryParameters: {'limit': 10, 'skip': 0},
        ),
      ).called(1);
      expect(page.posts, hasLength(1));
      expect(page.posts.first.title, 'A post');
      expect(page.total, 1);
    });

    test('fetchPosts_withQuery_hitsSearchEndpointWithQ', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.searchPosts,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response(pageJson()));

      final page = await dataSource.fetch(limit: 10, skip: 0, query: 'flutter');

      verify(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.searchPosts,
          queryParameters: {'limit': 10, 'skip': 0, 'q': 'flutter'},
        ),
      ).called(1);
      expect(page.posts, hasLength(1));
    });

    test('fetchPosts_withoutPostsList_throwsFormatException', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ApiEndpoints.posts,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response(const {}));

      expect(
        () => dataSource.fetch(limit: 10, skip: 0),
        throwsFormatException,
      );
    });
  });

  group('DioPostsRemoteDataSource.detail', () {
    test('detail_withValidId_returnsPost', () async {
      when(
        () => dio.get<Map<String, dynamic>>(ApiEndpoints.postDetail(1)),
      ).thenAnswer(
        (_) async => response(pageJson()['posts'].first as Map<String, dynamic>),
      );

      final post = await dataSource.detail(1);

      verify(() => dio.get<Map<String, dynamic>>(ApiEndpoints.postDetail(1)))
          .called(1);
      expect(post.id, 1);
      expect(post.likes, 5);
    });
  });

  group('DioPostsRemoteDataSource.author', () {
    test('author_withValidId_returnsAuthor', () async {
      when(() => dio.get<Map<String, dynamic>>(ApiEndpoints.user(17))).thenAnswer(
        (_) async => response(const {
          'id': 17,
          'firstName': 'Evelyn',
          'lastName': 'Sanchez',
        }),
      );

      final author = await dataSource.author(17);

      expect(author.id, 17);
      expect(author.displayName, 'Evelyn Sanchez');
    });
  });

  group('DioPostsRemoteDataSource.comments', () {
    test('comments_withPostId_returnsTotal', () async {
      when(
        () => dio.get<Map<String, dynamic>>(ApiEndpoints.postComments(6)),
      ).thenAnswer((_) async => response(const {'total': 3}));

      final comments = await dataSource.comments(6);

      expect(comments.total, 3);
    });
  });
}
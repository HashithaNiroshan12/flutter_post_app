import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_author.dart';
import '../../domain/entities/post_comments.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/remote/posts_remote_data_source.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource _remote;

  PostsRepositoryImpl(this._remote);

  @override
  Future<Result<PostsPage>> fetch({
    required int limit,
    required int skip,
    String? query,
  }) async {
    try {
      return Success(
        await _remote.fetch(limit: limit, skip: skip, query: query),
      );
    } on FormatException {
      return const FailureResult(ParsingFailure());
    } catch (error) {
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }

  @override
  Future<Result<Post>> detail(int id) async {
    try {
      return Success(await _remote.detail(id));
    } on FormatException {
      return const FailureResult(ParsingFailure());
    } catch (error) {
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }

  @override
  Future<Result<PostAuthor>> author(int id) async {
    try {
      return Success(await _remote.author(id));
    } on FormatException {
      return const FailureResult(ParsingFailure());
    } catch (error) {
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }

  @override
  Future<Result<PostComments>> comments(int postId) async {
    try {
      return Success(await _remote.comments(postId));
    } on FormatException {
      return const FailureResult(ParsingFailure());
    } catch (error) {
      return FailureResult(
        error is DioException ? mapDioError(error) : const ServerFailure(),
      );
    }
  }
}

import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class FetchPostsParams {
  const FetchPostsParams({
    required this.limit,
    required this.skip,
    this.query,
  });
  final int limit;
  final int skip;
  final String? query;
}

class FetchPostsUseCase implements UseCase<Result<PostsPage>, FetchPostsParams> {
  FetchPostsUseCase(this._repository);
  final PostsRepository _repository;
  @override
  Future<Result<PostsPage>> call(FetchPostsParams params) => _repository.fetch(
    limit: params.limit,
    skip: params.skip,
    query: params.query,
  );
}
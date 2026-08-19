import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/post_author.dart';
import '../repositories/posts_repository.dart';

class PostAuthorParams {
  const PostAuthorParams(this.id);
  final int id;
}

class GetPostAuthorUseCase
    implements UseCase<Result<PostAuthor>, PostAuthorParams> {
  GetPostAuthorUseCase(this._repository);
  final PostsRepository _repository;
  @override
  Future<Result<PostAuthor>> call(PostAuthorParams params) =>
      _repository.author(params.id);
}
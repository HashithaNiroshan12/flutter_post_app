import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class PostDetailParams {
  const PostDetailParams(this.id);
  final int id;
}

class GetPostDetailUseCase implements UseCase<Result<Post>, PostDetailParams> {
  GetPostDetailUseCase(this._repository);
  final PostsRepository _repository;
  @override
  Future<Result<Post>> call(PostDetailParams params) =>
      _repository.detail(params.id);
}
import '../../../../core/usecase/usecase.dart';
import '../../../../core/network/result.dart';
import '../entities/post_comments.dart';
import '../repositories/posts_repository.dart';

class PostCommentsParams {
  const PostCommentsParams(this.postId);
  final int postId;
}

class GetPostCommentsUseCase
    implements UseCase<Result<PostComments>, PostCommentsParams> {
  GetPostCommentsUseCase(this._repository);
  final PostsRepository _repository;
  @override
  Future<Result<PostComments>> call(PostCommentsParams params) =>
      _repository.comments(params.postId);
}
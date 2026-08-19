sealed class PostDetailEvent {
  const PostDetailEvent();
}

class PostDetailRequested extends PostDetailEvent {
  const PostDetailRequested(this.id);
  final int id;
}
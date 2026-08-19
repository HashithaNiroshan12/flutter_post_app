sealed class PostsEvent {
  const PostsEvent();
}

class PostsLoaded extends PostsEvent {
  const PostsLoaded();
}

class PostsSearchChanged extends PostsEvent {
  const PostsSearchChanged(this.query);
  final String query;
}

class PostsLoadMore extends PostsEvent {
  const PostsLoadMore();
}

class PostsRefreshed extends PostsEvent {
  const PostsRefreshed();
}
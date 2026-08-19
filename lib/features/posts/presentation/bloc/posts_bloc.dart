import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/result.dart';
import '../../domain/usecases/fetch_posts_usecase.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(this._fetchPosts) : super(const PostsState()) {
    on<PostsLoaded>(_load);
    on<PostsSearchChanged>(_search);
    on<PostsLoadMore>(_more);
    on<PostsRefreshed>(_refresh);
  }
  final FetchPostsUseCase _fetchPosts;
  Timer? _debounce;

  Future<void> _load(PostsLoaded event, Emitter<PostsState> emit) =>
      _request(emit, query: state.query, refresh: true);

  Future<void> _search(
    PostsSearchChanged event,
    Emitter<PostsState> emit,
  ) async {
    _debounce?.cancel();
    emit(
      state.copyWith(
        query: event.query,
        status: PostsStatus.loading,
        posts: const [],
        total: 0,
        clearError: true,
      ),
    );
    _debounce = Timer(
      Duration(milliseconds: AppConfig.searchDebounceMs),
      () => add(PostsLoaded()),
    );
  }

  Future<void> _more(PostsLoadMore event, Emitter<PostsState> emit) async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != PostsStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    final result = await _fetchPosts(
      FetchPostsParams(
        limit: AppConfig.paginationLimit,
        skip: state.posts.length,
        query: state.query,
      ),
    );
    switch (result) {
      case Success(value: final page):
        emit(
          state.copyWith(
            posts: [...state.posts, ...page.posts],
            total: page.total,
            isLoadingMore: false,
          ),
        );
      case FailureResult(failure: final failure):
        emit(state.copyWith(isLoadingMore: false, error: failure.message));
    }
  }

  Future<void> _refresh(PostsRefreshed event, Emitter<PostsState> emit) =>
      _request(emit, query: state.query, refresh: true);

  Future<void> _request(
    Emitter<PostsState> emit, {
    required String query,
    required bool refresh,
  }) async {
    emit(
      state.copyWith(
        status: PostsStatus.loading,
        posts: const [],
        total: 0,
        clearError: true,
      ),
    );
    final result = await _fetchPosts(
      FetchPostsParams(limit: AppConfig.paginationLimit, skip: 0, query: query),
    );
    switch (result) {
      case Success(value: final page):
        emit(
          PostsState(
            status: PostsStatus.success,
            posts: page.posts,
            query: query,
            total: page.total,
          ),
        );
      case FailureResult(failure: final failure):
        emit(
          PostsState(
            status: PostsStatus.failure,
            query: query,
            error: failure.message,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
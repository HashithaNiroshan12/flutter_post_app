import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../domain/usecases/get_post_detail_usecase.dart';
import 'post_detail_event.dart';
import 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc(this._getPostDetail) : super(const PostDetailState()) {
    on<PostDetailRequested>((event, emit) async {
      emit(const PostDetailState());
      final result = await _getPostDetail(PostDetailParams(event.id));
      switch (result) {
        case Success(value: final post):
          emit(PostDetailState(loading: false, post: post));
        case FailureResult(failure: final failure):
          emit(PostDetailState(loading: false, error: failure.message));
      }
    });
  }
  final GetPostDetailUseCase _getPostDetail;
}
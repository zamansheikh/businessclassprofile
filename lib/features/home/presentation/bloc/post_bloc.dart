import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  static const int _postsPerPage = 5;
  PostBloc(this._postRepository) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<SubmitQuestion>(_onSubmitQuestion);
    on<ShareExperience>(_onShareExperience);
    on<DeletePost>(_onDeletePost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await _postRepository.getAllPosts(
        limit: event.limit,
        skip: event.skip,
        additionalQuery: event.additionalQuery,
      );

      emit(
        PostLoaded(
          posts: posts,
          hasMore: posts.length >= _postsPerPage,
          currentSkip: event.skip + posts.length,
        ),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostState> emit,
  ) async {
    try {
      final posts = await _postRepository.getAllPosts(
        limit: _postsPerPage,
        skip: 0,
      );

      emit(
        PostLoaded(
          posts: posts,
          hasMore: posts.length >= _postsPerPage,
          currentSkip: posts.length,
        ),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<PostState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostLoaded || !currentState.hasMore) return;

    emit(
      PostLoadingMore(
        posts: currentState.posts,
        currentSkip: currentState.currentSkip,
      ),
    );

    try {
      final newPosts = await _postRepository.getAllPosts(
        limit: _postsPerPage,
        skip: currentState.currentSkip,
      );

      final allPosts = [...currentState.posts, ...newPosts];

      emit(
        PostLoaded(
          posts: allPosts,
          hasMore: newPosts.length >= _postsPerPage,
          currentSkip: currentState.currentSkip + newPosts.length,
        ),
      );
    } catch (e) {
      emit(currentState); // Revert to previous state on error
    }
  }

  Future<void> _onSubmitQuestion(
    SubmitQuestion event,
    Emitter<PostState> emit,
  ) async {
    emit(PostSubmitting());
    try {
      await _postRepository.submitQuestion(
        description: event.description,
        authorId: event.authorId,
        imagePaths: event.imagePaths,
      );

      emit(const PostSubmitted(message: 'Question submitted successfully!'));

      // After successful submission, refresh the posts
      add(RefreshPosts());
    } catch (e) {
      emit(PostSubmissionError(message: e.toString()));
    }
  }

  Future<void> _onShareExperience(
    ShareExperience event,
    Emitter<PostState> emit,
  ) async {
    emit(PostSubmitting());
    try {
      await _postRepository.shareExperience(
        departure: event.departure,
        arrival: event.arrival,
        airline: event.airline,
        classType: event.classType,
        rating: event.rating,
        shareDate: event.shareDate,
        description: event.description,
        authorId: event.authorId,
        imagePaths: event.imagePaths,
      );

      emit(const PostSubmitted(message: 'Experience shared successfully!'));

      // After successful submission, refresh the posts
      add(RefreshPosts());
    } catch (e) {
      emit(PostSubmissionError(message: e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await _postRepository.deletePost(
        postId: event.postId,
        postType: event.postType,
      );

      // Remove the post from current state if it exists
      final currentState = state;
      if (currentState is PostLoaded) {
        final updatedPosts = currentState.posts
            .where((post) => post.id != event.postId)
            .toList();

        emit(
          PostLoaded(
            posts: updatedPosts,
            hasMore: currentState.hasMore,
            currentSkip: currentState.currentSkip - 1,
          ),
        );
      }
    } catch (e) {
      emit(PostError(message: 'Failed to delete post: $e'));
    }
  }
}

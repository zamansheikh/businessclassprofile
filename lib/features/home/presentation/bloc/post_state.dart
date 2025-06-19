import 'package:equatable/equatable.dart';
import '../../data/models/review_models.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<ReviewPost> posts;
  final bool hasMore;
  final int currentSkip;

  const PostLoaded({
    required this.posts,
    this.hasMore = true,
    this.currentSkip = 0,
  });

  @override
  List<Object?> get props => [posts, hasMore, currentSkip];

  PostLoaded copyWith({
    List<ReviewPost>? posts,
    bool? hasMore,
    int? currentSkip,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }
}

class PostLoadingMore extends PostState {
  final List<ReviewPost> posts;
  final int currentSkip;

  const PostLoadingMore({required this.posts, required this.currentSkip});

  @override
  List<Object?> get props => [posts, currentSkip];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostSubmitting extends PostState {}

class PostSubmitted extends PostState {
  final String message;

  const PostSubmitted({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostSubmissionError extends PostState {
  final String message;

  const PostSubmissionError({required this.message});

  @override
  List<Object?> get props => [message];
}

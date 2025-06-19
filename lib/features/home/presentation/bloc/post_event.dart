import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostEvent {
  final int limit;
  final int skip;
  final String additionalQuery;

  const LoadPosts({this.limit = 5, this.skip = 0, this.additionalQuery = ''});

  @override
  List<Object?> get props => [limit, skip, additionalQuery];
}

class RefreshPosts extends PostEvent {}

class LoadMorePosts extends PostEvent {}

class SubmitQuestion extends PostEvent {
  final String description;
  final String authorId;
  final List<String>? imagePaths;

  const SubmitQuestion({
    required this.description,
    required this.authorId,
    this.imagePaths,
  });

  @override
  List<Object?> get props => [description, authorId, imagePaths];
}

class ShareExperience extends PostEvent {
  final Map<String, dynamic> departure;
  final Map<String, dynamic> arrival;
  final Map<String, dynamic> airline;
  final String classType;
  final double rating;
  final DateTime shareDate;
  final String description;
  final String authorId;
  final List<String>? imagePaths;

  const ShareExperience({
    required this.departure,
    required this.arrival,
    required this.airline,
    required this.classType,
    required this.rating,
    required this.shareDate,
    required this.description,
    required this.authorId,
    this.imagePaths,
  });

  @override
  List<Object?> get props => [
    departure,
    arrival,
    airline,
    classType,
    rating,
    shareDate,
    description,
    authorId,
    imagePaths,
  ];
}

class DeletePost extends PostEvent {
  final String postId;
  final String postType; // 'ask' or 'share'

  const DeletePost({required this.postId, required this.postType});

  @override
  List<Object?> get props => [postId, postType];
}

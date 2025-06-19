import '../../data/models/review_models.dart';

abstract class PostRepository {
  Future<List<ReviewPost>> getAllPosts({
    int limit = 5,
    int skip = 0,
    String additionalQuery = '',
  });

  Future<void> submitQuestion({
    required String description,
    required String authorId,
    required List<String>? imagePaths,
  });

  Future<void> shareExperience({
    required Map<String, dynamic> departure,
    required Map<String, dynamic> arrival,
    required Map<String, dynamic> airline,
    required String classType,
    required double rating,
    required DateTime shareDate,
    required String description,
    required String authorId,
    required List<String>? imagePaths,
  });
}

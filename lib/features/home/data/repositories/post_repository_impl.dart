import 'dart:io';
import '../../domain/repositories/post_repository.dart';
import '../models/review_models.dart';
import '../../../../core/network/post_api_service.dart';

class PostRepositoryImpl implements PostRepository {
  final PostApiService _apiService = PostApiService();

  @override
  Future<List<ReviewPost>> getAllPosts({
    int limit = 5,
    int skip = 0,
    String additionalQuery = '',
  }) async {
    try {
      final response = await _apiService.getAllPosts(
        limit: limit,
        skip: skip,
        additionalQuery: additionalQuery,
      );

      final postsJson = List<Map<String, dynamic>>.from(
        response['posts'] ?? [],
      );
      return postsJson.map((json) => ReviewPost.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<void> submitQuestion({
    required String description,
    required String authorId,
    required List<String>? imagePaths,
  }) async {
    try {
      List<File>? files;
      if (imagePaths != null && imagePaths.isNotEmpty) {
        files = imagePaths.map((path) => File(path)).toList();
      }

      await _apiService.postAskQuestion(
        description: description,
        authorId: authorId,
        files: files,
      );
    } catch (e) {
      throw Exception('Failed to submit question: $e');
    }
  }

  @override
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
  }) async {
    try {
      List<File>? files;
      if (imagePaths != null && imagePaths.isNotEmpty) {
        files = imagePaths.map((path) => File(path)).toList();
      }

      await _apiService.postShareExperience(
        departure: departure,
        arrival: arrival,
        airline: airline,
        classType: classType,
        rating: rating,
        shareDate: shareDate,
        description: description,
        authorId: authorId,
        files: files,
      );
    } catch (e) {
      throw Exception('Failed to share experience: $e');
    }
  }
}

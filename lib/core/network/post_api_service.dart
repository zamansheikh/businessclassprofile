import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostApiService {
  static const String baseUrl = 'https://businessclassprofile.com/api/feed_api';
  final Dio _dio = Dio();

  Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> getAllPosts({
    int limit = 5,
    int skip = 0,
    String additionalQuery = '',
  }) async {
    try {
      final token = await _getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        '$baseUrl/all_posts',
        queryParameters: {
          'limit': limit,
          'skip': skip,
          'additionalQuery': additionalQuery,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  Future<Map<String, dynamic>> postAskQuestion({
    required String description,
    required String authorId,
    List<File>? files,
  }) async {
    try {
      final token = await _getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData();

      // Add the JSON data
      final data = {
        'description': description,
        'published_date': DateTime.now().toIso8601String(),
        'author': authorId,
      };
      formData.fields.add(MapEntry('data', jsonEncode(data)));

      // Add files if provided
      if (files != null && files.isNotEmpty) {
        for (File file in files) {
          String fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              'askFiles',
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      final response = await _dio.post(
        '$baseUrl/post_ask',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to post question: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error posting question: $e');
    }
  }

  Future<Map<String, dynamic>> postShareExperience({
    required Map<String, dynamic> departure,
    required Map<String, dynamic> arrival,
    required Map<String, dynamic> airline,
    required String classType,
    required double rating,
    required DateTime shareDate,
    required String description,
    required String authorId,
    List<File>? files,
  }) async {
    try {
      final token = await _getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final formData = FormData();

      // Add the JSON data
      final data = {
        'departure': departure,
        'arrival': arrival,
        'airline': airline,
        'class': classType,
        'rating': rating.toInt(),
        'share_date': shareDate.toIso8601String(),
        'description': description,
        'author': authorId,
        'published_date': DateTime.now().toIso8601String(),
      };
      formData.fields.add(MapEntry('data', jsonEncode(data)));

      // Add files if provided
      if (files != null && files.isNotEmpty) {
        for (File file in files) {
          String fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              'shareFiles',
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      final response = await _dio.post(
        '$baseUrl/post_share',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to share experience: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sharing experience: $e');
    }
  }

  Future<Map<String, dynamic>> deletePost({
    required String postId,
    required String postType, // 'ask' or 'share'
  }) async {
    try {
      final token = await _getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.delete(
        '$baseUrl/delete_post/',
        queryParameters: {'id': postId, 'type': postType},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}

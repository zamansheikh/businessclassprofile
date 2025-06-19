import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signIn({
    required String emailOrUsername,
    required String password,
  });

  Future<Map<String, dynamic>> signUp({
    required String displayName,
    required String email,
    required String password,
    required String country,
  });
}

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'authentication_api/login',
        data: {'emailOrUsername': emailOrUsername, 'password': password},
      );
      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data;
        } else {
          throw ServerException(data['message'] ?? 'Login failed');
        }
      } else {
        throw ServerException(
          'Login failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        throw ServerException(data['message'] ?? 'Login failed');
      } else {
        throw NetworkException('Network error occurred');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String displayName,
    required String email,
    required String password,
    required String country,
  }) async {
    try {
      final response = await dio.post(
        'authentication_api/signup',
        data: {
          'displayName': displayName,
          'email': email,
          'password': password,
          'country': country,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data;
        } else {
          throw ServerException(data['message'] ?? 'Sign up failed');
        }
      } else {
        throw ServerException(
          'Sign up failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        throw ServerException(data['message'] ?? 'Sign up failed');
      } else {
        throw NetworkException('Network error occurred');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _authTokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(_authTokenKey, token);
  }

  @override
  Future<String?> getAuthToken() async {
    return sharedPreferences.getString(_authTokenKey);
  }

  @override
  Future<void> clearAuthToken() async {
    await sharedPreferences.remove(_authTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = user.toJson();
    await sharedPreferences.setString(_userKey, userJson.toString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      try {
        // Parse the stored JSON string back to Map and then to UserModel
        // Note: This is a simplified approach. In production, you'd want to use a proper JSON parser
        return null; // For now, return null until we implement proper storage
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(_userKey);
  }
}

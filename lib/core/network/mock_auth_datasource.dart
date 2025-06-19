import '../../../features/auth/data/datasources/auth_datasource.dart';

class MockAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful login response
    if (emailOrUsername == "test@example.com" && password == "password123") {
      return {
        "status": "success",
        "message": "Login successful",
        "token": "mock_jwt_token_12345",
        "user": {
          "_id": "mock_user_id_123",
          "email": "test@example.com",
          "displayName": "Test User",
          "profileUrl": null,
          "username": "testuser",
          "country": "Bangladesh",
          "role": "user",
          "status": "active",
        },
      };
    } else {
      throw Exception("Invalid credentials");
    }
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String displayName,
    required String email,
    required String password,
    required String country,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful signup response
    return {
      "status": "success",
      "message": "Check your email to verify your account",
    };
  }
}

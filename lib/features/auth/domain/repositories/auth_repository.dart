import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> signIn({
    required String emailOrUsername,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> signUp({
    required String displayName,
    required String email,
    required String password,
    required String country,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, void>> saveAuthToken(String token);

  Future<Either<Failure, String?>> getAuthToken();

  Future<Either<Failure, void>> clearAuthToken();
}

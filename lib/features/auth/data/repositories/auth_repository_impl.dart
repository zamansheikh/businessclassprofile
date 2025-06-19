import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signIn(
        emailOrUsername: emailOrUsername,
        password: password,
      );

      // Save token and user data if login is successful
      if (result['token'] != null) {
        await localDataSource.saveAuthToken(result['token']);
      }

      if (result['user'] != null) {
        final userModel = UserModel.fromJson(result['user']);
        await localDataSource.saveUser(userModel);
      }

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> signUp({
    required String displayName,
    required String email,
    required String password,
    required String country,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        displayName: displayName,
        email: email,
        password: password,
        country: country,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await localDataSource.clearAuthToken();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthToken(String token) async {
    try {
      await localDataSource.saveAuthToken(token);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save auth token: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final token = await localDataSource.getAuthToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure('Failed to get auth token: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAuthToken() async {
    try {
      await localDataSource.clearAuthToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear auth token: $e'));
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:blocpatternflutter/features/auth/data/datasources/auth_datasource.dart';
import 'package:blocpatternflutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blocpatternflutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:blocpatternflutter/core/errors/exceptions.dart';
import 'package:blocpatternflutter/core/errors/failures.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepository', () {
    const tEmailOrUsername = 'test@example.com';
    const tPassword = 'password123';
    const tToken = 'auth_token';

    final tLoginResponse = {
      'status': 'success',
      'message': 'Login successful',
      'token': tToken,
      'user': {
        '_id': '123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'username': 'testuser',
        'country': 'Bangladesh',
        'role': 'user',
        'status': 'active',
      },
    };

    group('signIn', () {
      test(
        'should return login response when remote data source succeeds',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.signIn(
              emailOrUsername: any(named: 'emailOrUsername'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => tLoginResponse);

          when(
            () => mockLocalDataSource.saveAuthToken(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockLocalDataSource.saveUser(any()),
          ).thenAnswer((_) async {});

          // act
          final result = await repository.signIn(
            emailOrUsername: tEmailOrUsername,
            password: tPassword,
          );

          // assert
          expect(result, equals(Right(tLoginResponse)));
          verify(
            () => mockRemoteDataSource.signIn(
              emailOrUsername: tEmailOrUsername,
              password: tPassword,
            ),
          );
          verify(() => mockLocalDataSource.saveAuthToken(tToken));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.signIn(
              emailOrUsername: any(named: 'emailOrUsername'),
              password: any(named: 'password'),
            ),
          ).thenThrow(const ServerException('Login failed'));

          // act
          final result = await repository.signIn(
            emailOrUsername: tEmailOrUsername,
            password: tPassword,
          );

          // assert
          expect(result, equals(const Left(ServerFailure('Login failed'))));
        },
      );
    });
  });
}

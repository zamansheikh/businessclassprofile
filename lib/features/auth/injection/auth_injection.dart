import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

@module
abstract class AuthModule {
  // Data Sources
  @lazySingleton
  AuthRemoteDataSource authRemoteDataSource(Dio dio) =>
      AuthRemoteDataSourceImpl(dio: dio);

  @lazySingleton
  AuthLocalDataSource authLocalDataSource(SharedPreferences prefs) =>
      AuthLocalDataSourceImpl(sharedPreferences: prefs);

  // Repository
  @lazySingleton
  AuthRepository authRepository(
    AuthRemoteDataSource remoteDataSource,
    AuthLocalDataSource localDataSource,
  ) => AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // Use Cases
  @lazySingleton
  SignInUseCase signInUseCase(AuthRepository repository) =>
      SignInUseCase(repository);

  @lazySingleton
  SignUpUseCase signUpUseCase(AuthRepository repository) =>
      SignUpUseCase(repository);

  @lazySingleton
  SignOutUseCase signOutUseCase(AuthRepository repository) =>
      SignOutUseCase(repository);

  @lazySingleton
  GetCurrentUserUseCase getCurrentUserUseCase(AuthRepository repository) =>
      GetCurrentUserUseCase(repository);

  // Bloc
  @factoryMethod
  AuthBloc authBloc(
    SignInUseCase signInUseCase,
    SignUpUseCase signUpUseCase,
    SignOutUseCase signOutUseCase,
    GetCurrentUserUseCase getCurrentUserUseCase,
  ) => AuthBloc(
    signInUseCase: signInUseCase,
    signUpUseCase: signUpUseCase,
    signOutUseCase: signOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
  );
}

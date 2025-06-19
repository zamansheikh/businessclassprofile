// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:blocpatternflutter/core/network/network_module.dart' as _i506;
import 'package:blocpatternflutter/core/utils/shared_preferences_module.dart'
    as _i748;
import 'package:blocpatternflutter/features/auth/data/datasources/auth_datasource.dart'
    as _i207;
import 'package:blocpatternflutter/features/auth/domain/repositories/auth_repository.dart'
    as _i431;
import 'package:blocpatternflutter/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i13;
import 'package:blocpatternflutter/features/auth/domain/usecases/sign_in_usecase.dart'
    as _i760;
import 'package:blocpatternflutter/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i812;
import 'package:blocpatternflutter/features/auth/domain/usecases/sign_up_usecase.dart'
    as _i721;
import 'package:blocpatternflutter/features/auth/injection/auth_injection.dart'
    as _i629;
import 'package:blocpatternflutter/features/auth/presentation/bloc/auth_bloc.dart'
    as _i1055;
import 'package:blocpatternflutter/features/home/data/datasources/counter_local_data_source.dart'
    as _i541;
import 'package:blocpatternflutter/features/home/data/datasources/counter_local_data_source_new.dart'
    as _i89;
import 'package:blocpatternflutter/features/home/data/repositories/counter_repository_impl.dart'
    as _i808;
import 'package:blocpatternflutter/features/home/domain/repositories/counter_repository.dart'
    as _i549;
import 'package:blocpatternflutter/features/home/domain/usecases/get_counter.dart'
    as _i534;
import 'package:blocpatternflutter/features/home/domain/usecases/increment_counter.dart'
    as _i244;
import 'package:blocpatternflutter/features/home/presentation/bloc/counter_bloc.dart'
    as _i581;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final authModule = _$AuthModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i207.AuthLocalDataSource>(
      () => authModule.authLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i89.CounterLocalDataSource>(
      () => _i89.CounterLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i541.CounterLocalDataSource>(
      () => _i541.CounterLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i207.AuthRemoteDataSource>(
      () => authModule.authRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.factory<_i549.CounterRepository>(
      () => _i808.CounterRepositoryImpl(gh<_i541.CounterLocalDataSource>()),
    );
    gh.lazySingleton<_i431.AuthRepository>(
      () => authModule.authRepository(
        gh<_i207.AuthRemoteDataSource>(),
        gh<_i207.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i534.GetCounter>(
      () => _i534.GetCounter(gh<_i549.CounterRepository>()),
    );
    gh.factory<_i244.IncrementCounter>(
      () => _i244.IncrementCounter(gh<_i549.CounterRepository>()),
    );
    gh.factory<_i581.CounterBloc>(
      () => _i581.CounterBloc(
        getCounter: gh<_i534.GetCounter>(),
        incrementCounter: gh<_i244.IncrementCounter>(),
      ),
    );
    gh.lazySingleton<_i760.SignInUseCase>(
      () => authModule.signInUseCase(gh<_i431.AuthRepository>()),
    );
    gh.lazySingleton<_i721.SignUpUseCase>(
      () => authModule.signUpUseCase(gh<_i431.AuthRepository>()),
    );
    gh.lazySingleton<_i812.SignOutUseCase>(
      () => authModule.signOutUseCase(gh<_i431.AuthRepository>()),
    );
    gh.lazySingleton<_i13.GetCurrentUserUseCase>(
      () => authModule.getCurrentUserUseCase(gh<_i431.AuthRepository>()),
    );
    gh.factory<_i1055.AuthBloc>(
      () => authModule.authBloc(
        gh<_i760.SignInUseCase>(),
        gh<_i721.SignUpUseCase>(),
        gh<_i812.SignOutUseCase>(),
        gh<_i13.GetCurrentUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i506.NetworkModule {}

class _$SharedPreferencesModule extends _i748.SharedPreferencesModule {}

class _$AuthModule extends _i629.AuthModule {}

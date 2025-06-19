import 'package:injectable/injectable.dart';
import '../data/datasources/auth_datasource.dart';
import '../../../core/network/mock_auth_datasource.dart';

@module
abstract class DebugAuthModule {
  // For development/testing when network is not available
  @lazySingleton
  @Named('mock')
  AuthRemoteDataSource mockAuthRemoteDataSource() =>
      MockAuthRemoteDataSourceImpl();
}

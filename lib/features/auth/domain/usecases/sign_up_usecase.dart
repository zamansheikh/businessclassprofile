import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    SignUpParams params,
  ) async {
    return await repository.signUp(
      displayName: params.displayName,
      email: params.email,
      password: params.password,
      country: params.country,
    );
  }
}

class SignUpParams extends Equatable {
  final String displayName;
  final String email;
  final String password;
  final String country;

  const SignUpParams({
    required this.displayName,
    required this.email,
    required this.password,
    required this.country,
  });

  @override
  List<Object> get props => [displayName, email, password, country];
}

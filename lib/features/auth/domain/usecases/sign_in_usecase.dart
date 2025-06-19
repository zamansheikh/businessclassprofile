import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    SignInParams params,
  ) async {
    return await repository.signIn(
      emailOrUsername: params.emailOrUsername,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String emailOrUsername;
  final String password;

  const SignInParams({required this.emailOrUsername, required this.password});

  @override
  List<Object> get props => [emailOrUsername, password];
}

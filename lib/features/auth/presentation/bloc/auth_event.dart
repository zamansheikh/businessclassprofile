import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String emailOrUsername;
  final String password;

  const SignInRequested({
    required this.emailOrUsername,
    required this.password,
  });

  @override
  List<Object> get props => [emailOrUsername, password];
}

class SignUpRequested extends AuthEvent {
  final String displayName;
  final String email;
  final String password;
  final String country;

  const SignUpRequested({
    required this.displayName,
    required this.email,
    required this.password,
    required this.country,
  });

  @override
  List<Object> get props => [displayName, email, password, country];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

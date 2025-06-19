import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? profileUrl;
  final String username;
  final String country;
  final String role;
  final String status;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.profileUrl,
    required this.username,
    required this.country,
    required this.role,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    profileUrl,
    username,
    country,
    role,
    status,
  ];
}

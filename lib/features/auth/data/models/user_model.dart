import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: '_id')
  final String modelId;

  const UserModel({
    required this.modelId,
    required super.email,
    required super.displayName,
    super.profileUrl,
    required super.username,
    required super.country,
    required super.role,
    required super.status,
  }) : super(id: modelId);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? profileUrl,
    String? username,
    String? country,
    String? role,
    String? status,
  }) {
    return UserModel(
      modelId: id ?? modelId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileUrl: profileUrl ?? this.profileUrl,
      username: username ?? this.username,
      country: country ?? this.country,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  modelId: json['_id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  profileUrl: json['profileUrl'] as String?,
  username: json['username'] as String,
  country: json['country'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'displayName': instance.displayName,
  'profileUrl': instance.profileUrl,
  'username': instance.username,
  'country': instance.country,
  'role': instance.role,
  'status': instance.status,
  '_id': instance.modelId,
};

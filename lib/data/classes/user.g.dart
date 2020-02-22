// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['phone'] as String,
    json['token'] as String,
    json['nickname'] as String,
    json['avater'] as String,
    json['create_time'] as String,
    json['update_time'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'token': instance.token,
      'nickname': instance.nickname,
      'avater': instance.avater,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };

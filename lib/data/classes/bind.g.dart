// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bind.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bind _$BindFromJson(Map<String, dynamic> json) {
  return Bind(
    json['id'] as int,
    json['user_id_from'] as int,
    json['user_id_to'] as int,
    json['status'] as int,
    json['bind_time'] as String,
    json['create_time'] as String,
    json['update_time'] as String,
  );
}

Map<String, dynamic> _$BindToJson(Bind instance) => <String, dynamic>{
      'id': instance.id,
      'user_id_from': instance.userIdFrom,
      'user_id_to': instance.userIdTo,
      'status': instance.status,
      'bind_time': instance.bindTime,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };

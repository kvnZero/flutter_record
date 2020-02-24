// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    json['id'] as int,
    json['bind_id'] as int,
    json['user_id'] as int,
    json['type'] as int,
    json['body'] as String,
    json['record_time'] as String,
    json['create_time'] as String,
    json['update_time'] as String,
    json['show'] as String,
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'id': instance.id,
      'bind_id': instance.bindId,
      'user_id': instance.userId,
      'type': instance.type,
      'body': instance.body,
      'record_time': instance.recordTime,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
      'show': instance.show,
    };

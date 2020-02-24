import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';


@JsonSerializable()
class Record extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'bind_id')
  int bindId;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'body')
  String body;

  @JsonKey(name: 'record_time')
  String recordTime;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'update_time')
  String updateTime;

  @JsonKey(name: 'show')
  String show;

  Record(this.id,this.bindId,this.userId,this.type,this.body,this.recordTime,this.createTime,this.updateTime,this.show,);

  factory Record.fromJson(Map<String, dynamic> srcJson) => _$RecordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecordToJson(this);

}


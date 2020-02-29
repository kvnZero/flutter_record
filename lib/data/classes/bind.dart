import 'package:json_annotation/json_annotation.dart';

part 'bind.g.dart';


@JsonSerializable()
class Bind extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'user_id_from')
  int userIdFrom;

  @JsonKey(name: 'user_id_to')
  int userIdTo;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'bind_time')
  String bindTime;

  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'update_time')
  String updateTime;

  Bind(this.id,this.userIdFrom,this.userIdTo,this.status,this.bindTime,this.text,this.createTime,this.updateTime,);

  factory Bind.fromJson(Map<String, dynamic> srcJson) => _$BindFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BindToJson(this);

}
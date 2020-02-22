import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'avater')
  String avater;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'update_time')
  String updateTime;

  User(this.id,this.phone,this.token,this.nickname,this.avater,this.createTime,this.updateTime,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
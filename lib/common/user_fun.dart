import 'package:dio/dio.dart';
import 'package:record/data/classes/user.dart';
import 'package:record/data/classes/bind.dart';
import 'dart:async';

class UserFun{
  String serverUrl = 'http://192.168.1.5:8000/';
  Future<Map> tokenLogin(String userToken,{Map other}) async {
    Map data = {'token':userToken};
    if(other!=null){
      data.addAll(other);
      print(data.toString());
    }
    try {
      Response response = await Dio().post(
          "${this.serverUrl}token",data: data);
      Map otherInfo={};
      if(response.data['status']==200){
        if(response.data['bind']!=null) {
          otherInfo.addAll({'bind':Bind.fromJson(response.data['bind']),});
        }
        if(response.data['otheruser']!=null) {
          otherInfo.addAll({'otheruser':User.fromJson(response.data['otheruser']),});
        }
        otherInfo.addAll({'user': User.fromJson(response.data['user']),'msg':response.data['message']});
        return otherInfo;
      }else{
        return {'msg':response.data['message']};
      }
    }on DioError catch(e) {
      print(e);
      return {'msg':'无法连接到服务器'};
    }
  }
  Future<Map> userLogin(String phone, String passWord, {Map other}) async{
    Map data = {'phone':phone, 'password':passWord};
    if(other!=null){
      data.addAll(other);
    }
    try {
      Response response = await Dio().post("${this.serverUrl}login",
          data: data);
      Map otherInfo={};
      if(response.data['status']==200){
        if(response.data['bind']!=null) {
          otherInfo.addAll({'bind':Bind.fromJson(response.data['bind']),});
        }
        if(response.data['otheruser']!=null) {
          otherInfo.addAll({'otheruser':User.fromJson(response.data['otheruser']),});
        }
        otherInfo.addAll({'user': User.fromJson(response.data['user']),'msg':response.data['message']});
        return otherInfo;
      }else{
        return {'msg':response.data['message']};
      }
    }on DioError catch(e) {
      print(e);
      return {'msg':'无法连接到服务器'};
    }
  }
  Future<Map> sendcode(String phone) async{
    //这个函数需要修改 才能使用
    try {
      Response response = await Dio().get("${this.serverUrl}code/$phone");
      print(response.data);
      if(response.statusCode==200){
        return {'msg':'发送成功'};
      }
    }on DioError catch(e) {
      print(e);
      return {'msg':'发送失败'};
    }
    return {'msg':'未知错误'};
  }
  Future<bool> check(String phone) async{
    //这个函数需要修改 才能使用
    try {
      Response response = await Dio().get("${this.serverUrl}check/$phone");
      print(response.data);
      if(response.statusCode==200){
        return response.data['exist'];
      }
    }on DioError catch(e) {
      if(e.response.hashCode==2011){
        return false;
      }
    }
    return false;
  }
  Future<Map> reg(String phone,String password, String code) async{
    //这个函数需要修改 才能使用
    try {
      Response response = await Dio().post("${this.serverUrl}reg",
          data: {'username':phone.trim(), 'password': password, 'code':code.trim()}
      );
      if(response.statusCode==200){
        if(response.data['message']=='succeed reg'){
          return {'msg':'注册成功'};
        }else if(response.data['message']=='error code'){
          return {'msg':'验证码输入错误'};
        }else if(response.data['message']=='error reg'){
          return {'msg':'未知原因注册失败'};
        }
      }
    }on DioError catch(e) {
      if(e.response.hashCode==2011){
        return {'msg':'无法连接到服务器'};
      }
      if(e.response.statusCode==400){
        return {'msg':'手机号码已经被注册'};
      }
      return {'msg':'网络连接失败'};
    }
    return {'msg':'未知错误'};
  }
  Future<Map> find(String phone,String password, String code) async{
    //这个函数需要修改 才能使用
    try {
      Response response = await Dio().post("${this.serverUrl}find",
          data: {'username':phone.trim(), 'password': password, 'code':code.trim()}
      );
      if(response.statusCode==200){
        if(response.data['message']=='succeed find'){
          return {'msg':'密码重置成功','result':true};
        }else if(response.data['message']=='error code'){
          return {'msg':'验证码输入错误','result':false};
        }else if(response.data['message']=='error phone'){
          return {'msg':'手机号码未注册','result':false};
        }else{
          return {'msg':'未知错误','result':false};
        }
      }
    }on DioError catch(e) {
      print(e);
      return {'msg':'网络连接失败','result':false};
    }
    return {'msg':'未知错误','result':false};
  }
  Future<void> userInfo(String id) async {
    try {
      Response response = await Dio().get("${this.serverUrl}userinfo/$id",
      );
      if (response.statusCode == 200) {
        return {'avater':response.data['avater'],'nickname':response.data['nickname']};
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        return null;
      }
      return null;
    }
  }
  Future<Map> searchUser(String phone) async {
    try {
      Response response = await Dio().get("${this.serverUrl}search/$phone",
      );
      if(response.data['status']==200){
        return {'user':response.data['user']};
      }else{
        return {'msg': response.data['message']};
      }
    } on DioError catch (e) {
      print(e);
      return {'msg':'无法连接到服务器'};
    }
  }
  Future<Map> uploadImg(String userId,imgFile) async{
    String path = imgFile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.fromMap({
      'user_id' : userId,
      "file":await MultipartFile.fromFile(path,filename: name)
    });
    try {
      Response response = await Dio().post("${this.serverUrl}upload",data: formData);
      if(response.data['status'] == 200){
        return {'msg': response.data['message'],'url':response.data['url']};
      }else{
        return {'msg':response.data['message']};
      }
    } on DioError catch (e) {
      print(e);
      return {'msg':'无法连接到服务器'};
    }
  }
  Future<Map> uploadNickname(String userId,String nickname) async{
    try {
      Response response = await Dio().post("${this.serverUrl}upload",
          data: {'user_id':userId, 'nickname': nickname}
      );
      if(response.data['status'] == 200){
        return {'msg': response.data['message'],'nickname':response.data['nickname']};
      }else{
        return {'msg':response.data['message']};
      }
    } on DioError catch (e) {
      print(e);
      return {'msg':'无法连接到服务器'};
    }
  }
}
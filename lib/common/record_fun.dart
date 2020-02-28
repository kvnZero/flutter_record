import 'package:dio/dio.dart';

class RecordFun{
  String serverUrl = 'http://192.168.1.5:8000/';
  Future<Map> getRecord(String bindId, String userId,{Map other}) async {
    Map data = {'bind_id': bindId,'user_id': userId};
    if (other != null) {
      data.addAll(other);
      print(data.toString());
    }
    try {
      Response response = await Dio().post("${this.serverUrl}record", data: data);
      return {'data': response.data['data']};
    } on DioError catch (e) {
      print(e);
      return {'msg': '无法连接到服务器'};
    }
  }
  Future<Map> pushRecord(String bindId, String userId, String text, String time,{Map other}) async {
    Map data = {'bind_id': bindId,'user_id': userId,'text': text,'time':time};
    print(data);
    if (other != null) {
      data.addAll(other);
      print(data.toString());
    }
    try {
      Response response = await Dio().post("${this.serverUrl}push", data: data);
      return {'data': response.data};
    } on DioError catch (e) {
      print(e);
      return {'msg': '无法连接到服务器'};
    }
  }
}
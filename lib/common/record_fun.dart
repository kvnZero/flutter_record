import 'package:dio/dio.dart';

class RecordFun{
  String serverUrl = 'http://192.168.1.5:8000/';
  Future<Map> getRecord(String bind_id, String user_id,{Map other}) async {
    Map data = {'bind_id': bind_id,'user_id': user_id};
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
}
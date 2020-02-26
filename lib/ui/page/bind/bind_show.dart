import 'package:flutter/material.dart';
import 'package:record/common/bind_fun.dart';
class BindShowPage extends StatefulWidget {
  const BindShowPage({
    @required this.bindId,
  });
  final int bindId;
  @override
  _BindShowPageState createState() => _BindShowPageState(bindId);
}

class _BindShowPageState extends State<BindShowPage> {
  int bindId;
  Map bindList;
  _BindShowPageState(int bindId){
    this.bindId=bindId;
  }

  @override
  void initState() {
    // TODO: implement initState
    // 加载数据
   loadInfo();
   super.initState();
  }

  void loadInfo() async{
    Future<Map> result =  BindFun().getRecordMore(bindId.toString());
    result.then((e){
      setState(() {
        bindList = e['data']['bind'][0];
      });
      print(bindList);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(bindList==null){
      return Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("来自${bindList['nickname']}的请求"),
        centerTitle: false,
        elevation: 0.5,
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(height: 100,width: 100,
                  child: ClipRRect( //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(90.0),
                    child: Image.network(
                      bindList['avater'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                Text("这里整些甜言蜜语",style: TextStyle(fontSize: 16),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("拒绝链接"),
                  onPressed: () {},
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("同意链接"),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

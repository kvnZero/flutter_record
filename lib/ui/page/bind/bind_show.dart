import 'package:flutter/material.dart';
import 'package:record/common/bind_fun.dart';
import 'package:record/data/model/auth.dart';
import 'package:provider/provider.dart';
import 'package:record/data/event/event.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(BindUpdateEvent());
  }

  void loadInfo() async{
    Future<Map> result =  BindFun().getBindMore(bindId.toString());
    result.then((e){
      setState(() {
        bindList = e['data']['bind'][0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(bindList==null){
      return Container(
        color: Colors.white,
        child: Center(
          // CircularProgressIndicator是一个圆形的Loading进度条
          child: CircularProgressIndicator(),
        ),
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
                  onPressed: () {
                    Future<Map> result = BindFun().changeStatus(bindId.toString(),2);
                    result.then((e){
                      print(e);
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Consumer<AuthModel>(builder: (context,user,child){
                  return RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("同意链接"),
                    onPressed: () {
                      Future<Map> result = BindFun().changeStatus(bindId.toString(),1);
                      result.then((e){
                        user.loadLogged();
                        Navigator.of(context).pop();
                      });
                      //这里要重新登录
                    },
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}

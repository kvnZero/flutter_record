import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/common/bind_fun.dart';
import 'package:record/data/model/auth.dart';
import 'package:record/data/classes/user.dart';
import 'package:record/ui/widget/record_widget.dart';
import 'package:record/common/record_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:record/common/adapt.dart';
import 'package:record/ui/page/bind/bind_show.dart';
import 'package:record/data/event/event.dart';
import 'record_push.dart';

class RecordHomePage extends StatefulWidget {
  @override
  _RecordHomePageState createState() => _RecordHomePageState();
}

class _RecordHomePageState extends State<RecordHomePage> with AutomaticKeepAliveClientMixin{
  ScrollController _controller = new ScrollController();
  User myUser, otherUser;
  bool showText = false;
  String _leftText,_rightText;
  var _saveUser, _saveBind;
  int bindDay;
  List recordData = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller.addListener((){
      if(_controller.offset>Adapt.px(120)){
        setState(() {
          showText=true;
        });
      }else{
        setState(() {
          showText=false;
        });
      }
    });
    // TODO: implement initState
    super.initState();
    addRecordData();
    getMsgData();
    eventBus.on<BindUpdateEvent>().listen((_) {
      addRecordData();
      getMsgData();
    });
    eventBus.on<RecordUpdateEvent>().listen((_) {
      addRecordData();
    });
  }

  void addRecordData() async{
    String bindData;
    var _prefs = await SharedPreferences.getInstance();
    if(_saveUser==null){
      var _prefs = await SharedPreferences.getInstance();
      setState(() {
        _saveUser = json.decode(_prefs.getString('user_data'));
      });
    }
    if(_saveBind==null) {
      bindData = (_prefs.getString('bind_data'));
      if(bindData != null){
        _saveBind = json.decode(bindData);
        bindDay =  DateTime.now().difference(DateTime.parse(_saveBind['bind_time'])).inDays + 1;
      }
    }
    if(_saveBind != null && _saveUser!= null){
      recordData = [];
      Future<Map> result =  RecordFun().getRecord(_saveBind['id'].toString(), _saveUser['id'].toString());
      result.then((e){
        setState(() {
          recordData.addAll(e['data']);
        });
      });
    }
  }

  void getMsgData() async{
    if(_saveUser==null) {
      var _prefs = await SharedPreferences.getInstance();
      setState(() {
        _saveUser = json.decode(_prefs.getString('user_data'));
      });
    }
    if(_saveBind==null) {
      Future<Map> result = BindFun().getBind(_saveUser['id'].toString());
      result.then((e){
        if(e['data']['status']==200){
          if(e['data']['bind']['status']==0){
            if(e['data']['bind']['user_id_to']==_saveUser['id']) {
              //这里弹出一个窗口 请求连接
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("收到连接请求"),
                    content: Text("收到一条链接请求啦, 去看看伐?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("忽略"),
                        onPressed: () => Navigator.of(context).pop(), //关闭对话框
                      ),
                      FlatButton(
                        child: Text("去瞧瞧"),
                        onPressed: () {
                          //跳转子页面
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return BindShowPage(bindId: e['data']['bind']['id'],);
                          }));
                        },
                      ),
                    ],
                  );
                });
            }
          }
          if(e['data']['bind']['status']==2){
            if(e['data']['bind']['user_id_from']==_saveUser['id']) {
              //这里弹出一个窗口 提示被拒绝
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("呜呜呜被拒绝了",style: TextStyle(fontSize: 14),),
                    content: Text("发送过去的请求被拒绝了\n接下来要咋办呢。"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("重新发送"),
                        onPressed: () {
                          //修改状态
                          Future<Map> result = BindFun().changeStatus(e['data']['bind']['id'].toString(),0);
                          result.then((e){
                            print(e);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("哼那算了"),
                        onPressed: () {
                          //删除状态
                          BindFun().changeStatus(e['data']['bind']['id'].toString(),-1);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      controller: _controller,
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 0.5,
            expandedHeight: Adapt.px(250),
            floating: true,
            snap: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 5),
                title: titleShow(),
                background: infoShow()),
          )
        ];
      },
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: recordData.length==0 ? Center(child: Text("记录现在是空哒ovo"),) :  ListView.builder(
          padding: EdgeInsets.only(top:10),
          itemCount: recordData.length,itemBuilder: (context, index) {
          return RecordWidget(record: recordData[index]);
        },),
      )),
      floatingActionButton: _saveBind == null ? Container() : FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RecordPushPage(bindId: _saveBind['id'],userId: _saveUser['id'],);
          }));
        },
      )
    );
  }

  Widget titleShow(){
    return Container(
      height: Adapt.px(60),
      child: Consumer<AuthModel>(builder: (context,user,child){
        _leftText = user.user.nickname;
        _rightText = user.otherUser==null ? '快来邀请另一半使用' : user.otherUser.nickname;
        return showText==false ? Container() : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: Adapt.px(50),width: Adapt.px(50),
                  child: ClipRRect( //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(90.0),
                    child: Image.network(
                      user.user.avater,
                      fit: BoxFit.cover,
                    ),
                  ),),
                Container(
                  alignment: Alignment.centerLeft,
                    child: Text(_leftText,style: TextStyle(fontSize: Adapt.px(24),color: Colors.black26),),
                    width: MediaQuery.of(context).size.width/2-80
                )
              ],
            ),
          Row(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: Text(_rightText,style: TextStyle(fontSize: Adapt.px(24),color: Colors.black26),),
                  width: MediaQuery.of(context).size.width/2-80
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: Adapt.px(50),width: Adapt.px(50),
                child: ClipRRect( //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(90.0),
                  child: user.otherUser==null ? Image.asset('images/static/nullright.png',fit: BoxFit.fill,) :
                  Image.network(
                    user.otherUser.avater,
                    fit: BoxFit.cover,
                  ),
                ),),
            ],
          )
        ],
      );
      }),
    );
  }

  Widget infoShow() {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(80)),
      child:
      Consumer<AuthModel>(builder: (context,user,child){
        return Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(height: Adapt.px(120),width: Adapt.px(120),
                      child: ClipRRect( //剪裁为圆角矩形
                        borderRadius: BorderRadius.circular(90.0),
                        child: Image.network(
                          user.user.avater,
                          fit: BoxFit.cover,
                        ),
                      ),),
                    Text(user.user.nickname),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(height: Adapt.px(120),width: Adapt.px(120),
                      child: ClipRRect( //剪裁为圆角矩形
                        borderRadius: BorderRadius.circular(90.0),
                        child: user.otherUser==null ? Image.asset('images/static/nullright.png',fit: BoxFit.fill,) :
                        Image.network(
                          user.otherUser.avater,
                          fit: BoxFit.cover,
                        ),
                      ),),
                    Text(user.otherUser==null ? '等她(他)到' : user.otherUser.nickname ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: Adapt.px(10)),
              child: _saveBind ==null ? Text("快去邀请另一半一起记录吧(๑•̀ㅂ•́)",style: TextStyle(fontSize: Adapt.px(28)),) :
              Text("已经在一起$bindDay天啦，现在记录了${recordData.length}条",style: TextStyle(fontSize: Adapt.px(28)),),
            )
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/data/model/auth.dart';
import 'package:record/data/classes/user.dart';
import 'package:record/ui/widget/record_widget.dart';
import 'package:record/common/record_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:record/common/adapt.dart';

class IndexHomePage extends StatefulWidget {
  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {
  ScrollController _controller = new ScrollController();
  User myUser, otherUser;
  bool showText = false;
  String _leftText,_rightText;
  var _saveUser, _saveBind;
  List recordData = [];

  @override
  void initState() {
    _controller.addListener((){
      if(_controller.offset>100){
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
  }

  void addRecordData() async{
    String bindData;
    var _prefs = await SharedPreferences.getInstance();
    if(_saveUser==null){
      var _prefs = await SharedPreferences.getInstance();
      _saveUser = json.decode(_prefs.getString('user_data'));
    }
    if(_saveBind==null) {
      bindData = (_prefs.getString('bind_data'));
      if(bindData != null){
        _saveBind = json.decode(bindData);
      }
    }
    if(_saveBind != null && _saveUser!= null){
      Future<Map> result =  RecordFun().getRecord(_saveBind['id'].toString(), _saveUser['id'].toString());
      result.then((e){
        setState(() {
          recordData.addAll(e['data']);
        });
        print(recordData);
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
            expandedHeight: Adapt.px(350),
            floating: true,
            snap: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(top:50),
                title: titleShow(),
                background: infoShow()),
          )
        ];
      },
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          padding: EdgeInsets.only(top:10),
          itemCount: recordData.length,itemBuilder: (context, index) {
          return RecordWidget(record: recordData[index]);
        },),
      )
    ));
  }

  Widget titleShow(){
    return Container(
      height: 50,
      child:
      Consumer<AuthModel>(builder: (context,user,child){
        _leftText = user.user.nickname;
        _rightText = user.otherUser==null ? '快来邀请另一半使用' : user.otherUser.nickname;
        return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,width: 40,
                  child: ClipRRect( //剪裁为圆角矩形
                    borderRadius: BorderRadius.circular(90.0),
                    child: Image.network(
                      user.user.avater,
                      fit: BoxFit.fill,
                    ),
                  ),),
                Container(
                    child: Text(showText ? _leftText : '',style: TextStyle(fontSize: 14,color: Colors.black26),),
                    width: MediaQuery.of(context).size.width/2-80
                )
              ],
            ),
          Row(
            children: <Widget>[
              Container(
                  child: Text(showText ? _rightText : '',style: TextStyle(fontSize: 14,color: Colors.black26),),
                  width: MediaQuery.of(context).size.width/2-80
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 40,width: 40,
                child: ClipRRect( //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(90.0),
                  child: Image.network(
                    user.otherUser==null ? 'https://i02piccdn.sogoucdn.com/45839b27bec0c9ef': user.otherUser.avater,
                    fit: BoxFit.fill,
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
      padding: EdgeInsets.only(top: 50),
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
                    Container(height: 100,width: 100,
                      child: ClipRRect( //剪裁为圆角矩形
                        borderRadius: BorderRadius.circular(90.0),
                        child: Image.network(
                          user.user.avater,
                          fit: BoxFit.fill,
                        ),
                      ),),
                    Text(user.user.nickname),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(height: 100,width: 100,
                      child: ClipRRect( //剪裁为圆角矩形
                        borderRadius: BorderRadius.circular(90.0),
                        child: Image.network(
                          user.otherUser==null ? 'https://i02piccdn.sogoucdn.com/45839b27bec0c9ef': user.otherUser.avater,
                          fit: BoxFit.fill,
                        ),
                      ),),
                    Text(user.otherUser==null ? '等她(他)到' : user.otherUser.nickname ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("这里可以写在一天多少天，记录了多少条事件",style: TextStyle(fontSize: 16),),
            )
          ],
        );
      }),
    );
  }
}

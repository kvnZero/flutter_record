import 'package:flutter/material.dart';
import 'package:record/common/bind_fun.dart';
import 'package:record/common/user_fun.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SearchIndexPage extends StatefulWidget {
  @override
  _SearchIndexPageState createState() => _SearchIndexPageState();
}

class _SearchIndexPageState extends State<SearchIndexPage> with AutomaticKeepAliveClientMixin {
  Map userInfo;
  Map saveUser;
  TextEditingController _searchController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUser();
  }

  void getLoginUser()async{
    if(saveUser==null) {
      var _prefs = await SharedPreferences.getInstance();
      setState(() {
        saveUser = json.decode(_prefs.getString('user_data'));
      });
    }
  }

  @override
  bool get wantKeepAlive => true;


  Widget searchInput(){
    return Theme(
      data: new ThemeData(primaryColor: Colors.pinkAccent),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width/1.2,
        child: TextFormField(
          autofocus: false,
          controller: _searchController,
          cursorColor: Colors.blue,
          maxLength: 11,
          keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
          decoration: InputDecoration(
            hintText: "搜索手机号",
            contentPadding: EdgeInsets.only(left: 15,right: 15),
            border:OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          style: TextStyle(fontSize: 14),
          onFieldSubmitted: (inputText){
            //进行格式判断后开始搜索
            BuildContext _dialogC;
            showDialog(context: context,builder: (BuildContext context){
              _dialogC = context;
              return Center(child: CircularProgressIndicator(),);
            });
            Future<Map> msg = UserFun().searchUser(inputText.trim());
            Future.delayed(Duration(seconds: 1), () {
              msg.then((e) {
                if(e['user'] != null ){
                  setState(() {
                    userInfo = e['user'];
                  });
                }else{
                  Toast.show(e['msg'], context);
                }
                Navigator.pop(_dialogC);
              });
            });
          },
        ),
      ),
    );
  }

  Widget searchShow (){
    if(userInfo==null){
      return Container();
    }else{
      return Container(
        padding: EdgeInsets.only(left: 5),
        child:Column(
          children: <Widget>[
            Container(height: 100,width: 100,
              margin: EdgeInsets.only(bottom: 10),
              child: ClipRRect( //剪裁为圆角矩形
                borderRadius: BorderRadius.circular(90.0),
                child: Image.network(
                  userInfo['avater'],
                  fit: BoxFit.cover,
                ),
              ),),
            Text(userInfo['nickname']),
            RaisedButton(onPressed: (){
              //发送请求
              BuildContext mainContext = context;
              TextEditingController _textController = new TextEditingController();
              showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("发送请求",style: TextStyle(fontSize: 14),),
                      content: Theme(data: new ThemeData(primaryColor: Colors.pinkAccent),
                          child: TextFormField(
                        autofocus: false,
                        controller: _textController,
                        cursorColor: Colors.blue,
                        maxLength: 25,
                        decoration: InputDecoration(
                          hintText: "输入要请求的内容吧(可空)",
                          contentPadding: EdgeInsets.only(left: 15,right: 15),
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      )),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("发送"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if(saveUser['id'] == userInfo['id']){
                              Toast.show('哪有和自己连接的啦', mainContext,);
                            }else{
                              Future<Map> result =  BindFun().sendBind(saveUser['id'].toString(), userInfo['id'].toString(),_textController.text.trim());
                              BuildContext _dialogC;
                              showDialog(context: context,builder: (BuildContext context){
                                _dialogC = context;
                                return Center(child: CircularProgressIndicator(),);
                              });
                              Future.delayed(Duration(seconds: 1), (){
                                //延迟一秒 防止异步出错
                                result.then((e) {
                                  Navigator.pop(_dialogC);
                                  Toast.show(e['data']['status']==200 ? '发送请求成功': e['data']['message'], mainContext);
                                });
                              });
                            }
                          },
                        ),
                      ],
                    );
                  });
            }, child: Text("发送请求"),color: Colors.blue[400],textColor: Colors.white,)
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索",style: TextStyle(fontSize: 18),),
        elevation: 0.5,
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          searchInput(),
          searchShow(),
        ],
      ),
    );
  }
}

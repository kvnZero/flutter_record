import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/data/model/auth.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{

  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwordController = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         Center(
           child:  Column(
             children: <Widget>[
               Theme(
                 data: new ThemeData(primaryColor: Colors.pinkAccent),
                 child: Container(
                     child: Form(
                         key: _formKey,
                         autovalidate: false,
                         child: Column(
                           children: <Widget>[
                             Container(
                               width: MediaQuery.of(context).size.width/1.3,
                               child: TextFormField(
                                 autofocus: false,
                                 controller: _unameController,
                                 cursorColor: Colors.blue,
                                 decoration: InputDecoration(
                                   hintText: "手机号",
                                   icon: Icon(Icons.person,),
                                   contentPadding: EdgeInsets.only(left: 15,right: 15),
                                   border:OutlineInputBorder(
                                     borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                   ),
                                 ),
                                 style: TextStyle(fontSize: 14),
                               ),
                             ),
                             Container(
                               margin: EdgeInsets.only(top:0),
                               width: MediaQuery.of(context).size.width/1.3,
                               child: TextFormField(
                                 controller: _pwordController,
                                 decoration: InputDecoration(
                                   hintText: "登录密码",
                                   icon: Icon(Icons.lock),
                                   contentPadding: EdgeInsets.only(left: 15,right: 15),
                                   border:OutlineInputBorder(
                                       borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))
                                   ),
                                 ),
                                 style: TextStyle(fontSize: 14),
                                 obscureText: true,
                               ),
                             ),
                             Container(
                               width: MediaQuery.of(context).size.width/1.3,
                               height: 40,
                               margin: const EdgeInsets.only(top: 10.0),
                               child: Consumer<AuthModel>(builder: (context,user,child){
                                 return  RaisedButton(
                                   color: Colors.pink[300],
                                   child: Text("登  录",style: TextStyle(fontSize: 16),),
                                   textColor: Colors.white70,
                                   onPressed: () {
                                     if(_unameController.text.trim().length > 0 && _pwordController.text.trim().length >= 3){
                                       if(isLogin==false) {
                                         isLogin=true;
                                         BuildContext _dialogC;
                                         showDialog(context: context,builder: (BuildContext context){
                                           _dialogC = context;
                                           return Center(child: CircularProgressIndicator());
                                         });
                                    Future<String> msg = user.login(username: _unameController.text, password: _pwordController.text);
                                    Future.delayed(Duration(seconds: 1), (){
                                      //延迟一秒 防止异步出错
                                      msg.then((v){
                                        Navigator.pop(_dialogC);
                                        if (v.isNotEmpty) {
                                          //如果报错 toast错误
                                          Toast.show(v, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                        }
                                      });
                                      isLogin=false;
                                    });
                                       }else{
                                         Toast.show("我正在处理上一个内容\n请稍等下(´･ω･｀)", context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                                       }
                                     }else{
                                       //如果输入有误 toast错误
                                       Toast.show("请检查输入", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                     }
                                   },
                                 );
                               }),
                             ),
                           ],
                         ))
                 ),
               ),
//              Container(
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    FlatButton(onPressed: (){
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => RegPage()));
//                    }, child: Text("注册账户",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.blue[500]),)),
//                    FlatButton(onPressed: (){
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => FindPage()));
//                    }, child: Text("忘记密码",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black54),)),
//                  ],
//                ),
//              ),
             ],
           ),
         )
        ],
      )
    );
  }
}
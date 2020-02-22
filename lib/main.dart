import 'package:flutter/material.dart';
import 'package:record/data/model/auth.dart';
import 'package:record/ui/page/user/login.dart';
import 'package:provider/provider.dart';
import 'ui/page/index/index_home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  final AuthModel _auth = AuthModel();

  @override
  void initState() {
    // TODO: implement initState
    _auth.loadLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>_auth)
    ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: SalashPage()
      ),
    );
  }
}

class SalashPage extends StatefulWidget {
  @override
  _SalashPageState createState() => _SalashPageState();
}

class _SalashPageState extends State<SalashPage> {

  //页面初始化状态的方法
  @override
  void initState() {
    super.initState();
    //开启倒计时
    countDown();
  }

  void countDown() async{
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 3);
    new Future.delayed(duration, goToHomePage);
  }

  void goToHomePage(){
    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context)=>Consumer<AuthModel>(builder: (context, user, child) {
      if (user?.user != null) {
        return new IndexHomePage();
      }else{
        return new LoginPage();
      }
    })), (Route<dynamic> rout)=>false);
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Image.asset("images/static/loading.gif",fit: BoxFit.cover,),//此处fit: BoxFit.cover用于拉伸图片,使图片铺满全屏
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

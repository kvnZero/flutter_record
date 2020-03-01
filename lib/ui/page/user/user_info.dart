import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/common/user_fun.dart';
import 'package:record/data/model/auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserInfoPageState();
  }
}

class UserInfoPageState extends State<UserInfoPage> {
  File _image;
  String userId;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Widget menuList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          '我',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
      ),
      body: Padding(padding: EdgeInsets.only(top: 10),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
                height: 200,width: 200,
                child: ClipRRect( //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(15.0),
                  child:_image == null ? Consumer<AuthModel>(builder: (context,user,child){
                    userId = user.user.id.toString();
                    return Image.network(user.user.avater,fit: BoxFit.cover,);
                  }) : Image.file(_image,fit: BoxFit.cover,),)
            ),
            Consumer<AuthModel>(builder: (context,user,child){
              return _image != null ? RaisedButton(onPressed: (){
                Future<Map> result =  UserFun().uploadImg(userId, _image);
                BuildContext _dialogC;
                showDialog(context: context,builder: (BuildContext context){
                  _dialogC = context;
                  return Center(child: CircularProgressIndicator(),);
                });
                Future.delayed(Duration(seconds: 1), (){
                  //延迟一秒 防止异步出错
                  result.then((e) {
                    user.user.avater = e['url'];
                    Navigator.pop(_dialogC);
                    Toast.show(e['msg'], context);
                  });
                });
              }, child: Text("上传图片"), color: Colors.blue[300],textColor: Colors.white,) : Container();
            },),
            Container(
                height: 100,width: 100,
                child: Text("nickname")
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

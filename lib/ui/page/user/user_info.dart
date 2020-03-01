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
  TextEditingController _textEditingController = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget nicknameInput(){
    return Theme(
      data: new ThemeData(primaryColor: Colors.pinkAccent),
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 20,right: 20),
        child: Consumer<AuthModel>(builder: (context,user,child) {
          return TextFormField(
            autofocus: false,
            controller: _textEditingController,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              hintText: "修改你的昵称",
              contentPadding: EdgeInsets.only(left: 15,right: 15),
              border:OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            style: TextStyle(fontSize: 14),
            onFieldSubmitted: (inputText){
              //进行格式判断后提交
              if(_textEditingController.text.trim().length>8){
                Toast.show('昵称最多8个字的啦', context);
              }else{
                BuildContext _dialogC;
                showDialog(context: context,builder: (BuildContext context){
                  _dialogC = context;
                  return Center(child: CircularProgressIndicator(),);
                });
                Future<Map> result =  UserFun().uploadNickname(user.user.id.toString(), _textEditingController.text.trim());
                Future.delayed(Duration(seconds: 1), () {
                  result.then((e) {
                    if(e['nickname'] != null ){
                      user.user.nickname = e['nickname'];
                    }
                    Toast.show(e['msg'], context);
                    Navigator.pop(_dialogC);
                  });
                });
              }
            },
          );
        })
      ),
    );
  }

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
                    _textEditingController.text = user.user.nickname;
                    return Image.network(user.user.avater,fit: BoxFit.cover,);
                  }) : Image.file(_image,fit: BoxFit.cover,),)
            ),
            Consumer<AuthModel>(builder: (context,user,child){
              return _image != null ? RaisedButton(onPressed: (){
                Future<Map> result =  UserFun().uploadImg(user.user.id.toString(), _image);
                BuildContext _dialogC;
                showDialog(context: context,builder: (BuildContext context){
                  _dialogC = context;
                  return Center(child: CircularProgressIndicator(),);
                });
                Future.delayed(Duration(seconds: 1), (){
                  //延迟一秒 防止异步出错
                  result.then((e) {
                    if(e['url'] != null ) {
                      user.user.avater = e['url'];
                    }
                    Navigator.pop(_dialogC);
                    Toast.show(e['msg'], context);
                  });
                });
              }, child: Text("上传图片"), color: Colors.blue[300],textColor: Colors.white,) : Container();
            },),
            nicknameInput()
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

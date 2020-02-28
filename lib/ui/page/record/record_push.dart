import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/data/model/auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:record/common/record_fun.dart';
import 'package:record/data/event/event.dart';

class RecordPushPage extends StatefulWidget{
  const RecordPushPage({
    @required this.bindId,
    @required this.userId,
  });
  final int bindId;
  final int userId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RecordPushPageState(bindId,userId);
  }
}

class RecordPushPageState extends State<RecordPushPage>{
  int bindId;
  int userId;
  RecordPushPageState(int bindId,int userId){
    this.bindId=bindId;
    this.userId=userId;
  }

  TextEditingController _textEditingController = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();
  DateTime mDate = DateTime.now();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(RecordUpdateEvent());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('记录'),),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: Center(
            child:  Theme(
              data: new ThemeData(primaryColor: Colors.pinkAccent),
              child: Container(
                  child: Form(
                      key: _formKey,
                      autovalidate: false,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.1,
                            child: TextFormField(
                              autofocus: false,
                              controller: _textEditingController,
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "填写这个时间发生了什么事情吧~",
                                contentPadding: EdgeInsets.all(15),
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          FlatButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    maxTime: DateTime.now(),
                                    onConfirm: (date) {
                                      setState(() {
                                        mDate = date;
                                      });
                                    }, currentTime: mDate, locale: LocaleType.zh);
                              },
                              child: Text(
                                '事件时间:${mDate.year}-${mDate.month}-${mDate.day},点击修改',
                                style: TextStyle(color: Colors.blue),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width/1.1,
                            height: 40,
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Consumer<AuthModel>(builder: (context,user,child){
                              return  RaisedButton(
                                color: Colors.pink[300],
                                child: Text("发布",style: TextStyle(fontSize: 16),),
                                textColor: Colors.white70,
                                onPressed: () {
                                  if(_textEditingController.text.trim().length > 0){
                                    Future<Map> result =  RecordFun().pushRecord(bindId.toString(), userId.toString(), _textEditingController.text.trim(), mDate.toString());
                                    BuildContext _dialogC;
                                    showDialog(context: context,builder: (BuildContext context){
                                      _dialogC = context;
                                      return Center(child: CircularProgressIndicator(),);
                                    });
                                    Future.delayed(Duration(seconds: 1), (){
                                      //延迟一秒 防止异步出错
                                      result.then((e) {
                                        print(e['data']['status']);
                                        IconData showIcon = e['data']['status'] == 200
                                            ? Icons.done
                                            : Icons.error;
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Container(
                                                  padding: EdgeInsets.only(top: 10),
                                                  height: 130,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Icon(
                                                        showIcon,
                                                        size: 40,
                                                      ),
                                                      Text(e['data']['status']==200 ? '该条记录存储成功': '发布失败, 未知原因'),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("确定"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      });
                                      Navigator.pop(_dialogC);
                                    });
                                  }else{
                                    //如果输入有误 toast错误
                                    Toast.show("请检查输入", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ))
              ),
            )
          ),
        )
    );
  }
}
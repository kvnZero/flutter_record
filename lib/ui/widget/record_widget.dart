import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/data/classes/record.dart';

class RecordWidget extends StatefulWidget {
  const RecordWidget({
    @required this.record,
  });
  final Map record;
  @override
  _RecordWidgetState createState() => _RecordWidgetState(record);
}

class _RecordWidgetState extends State<RecordWidget> {

  Record record;
  _RecordWidgetState(Map _record){
    record =  Record.fromJson(_record);
  }

  @override
  Widget build(BuildContext context) {
    Widget recordBody = Container(
      width: MediaQuery.of(context).size.width/2-20,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child:Card(
          elevation: 0.5,
          child: Padding(padding: EdgeInsets.all(5),child: Text(record.body),)),
    );
    Widget timeShow = Container(
      margin: record.show== 'left' ? EdgeInsets.only(left: 10): EdgeInsets.only(right: 10),
      child: Text(record.recordTime,style: TextStyle(fontSize: 12,color: Colors.black26),),
    );
    Widget lineShow = record.show == 'left' ?
    Transform.rotate(angle: pi,
      child: new CustomPaint(
            painter: new MyPainter(colors: Colors.blue[200])),
      ) :
    new CustomPaint(
        painter: new MyPainter(colors:Colors.pink[200]));
    return record.show == 'left' ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                border: new Border(right: BorderSide(width: 2.0, color: Colors.blue[200]),)
            ),
            child:Row(
              children: <Widget>[
                recordBody,
                Container(margin: EdgeInsets.only(right: 9),child: lineShow,),
              ],
            )
        ),
        timeShow
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        timeShow,
        Container(
            decoration: new BoxDecoration(
                border: new Border(left: BorderSide(width: 2.0, color: Colors.pink[200]),)
            ),
            child:Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(left: 9),child: lineShow,),
                recordBody,
              ],
            )
        )
      ],
    );
  }
}

class MyPainter extends CustomPainter{
  MyPainter({
    @required this.colors,
  });
  Color colors = Colors.blue;
  Paint _paint = Paint()
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..strokeWidth = 2.0; //画笔的宽度
  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawLine(new Offset(0, 0), new Offset(0,100), _paint);
    _paint.color = colors;
    canvas.drawLine(new Offset(-5, 0), new Offset(5,0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


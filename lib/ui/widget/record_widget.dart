import 'dart:math';

import 'package:flutter/material.dart';
class RecordWidget extends StatefulWidget {
  const RecordWidget({
    @required this.record,
  });
  final Map record;

  @override
  _RecordWidgetState createState() => _RecordWidgetState(record: record);
}

class _RecordWidgetState extends State<RecordWidget> {
  _RecordWidgetState({
    @required this.record,
  });
  Map record;

  @override
  Widget build(BuildContext context) {
    Widget recordBody = Container(
      width: MediaQuery.of(context).size.width/2-20,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child:Card(
          elevation: 0.5,
          child: Padding(padding: EdgeInsets.all(5),child: Text("这个啊啊啊啊啊啊啊啊啊啊啊是内容"),)),
    );
    Widget lineShow = record['show'] == 'left' ?
    Transform.rotate(angle: pi,
      child: new CustomPaint(
            painter: new MyPainter(colors: Colors.blue[200])),
      ) :
    new CustomPaint(
        painter: new MyPainter(colors:Colors.pink[200]));
    return record['show'] == 'left' ? Container(
        decoration: new BoxDecoration(
            border: new Border(right: BorderSide(width: 2.0, color: Colors.blue[200]),)
        ),
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/2-1),
        child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                recordBody,
                Padding(padding: EdgeInsets.only(left: 5),child: lineShow,)
              ],
            )
        ) : Container(
        decoration: new BoxDecoration(
            border: new Border(left: BorderSide(width: 2.0, color: Colors.pink[200]),)
        ),
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-1),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right: 5),child: lineShow,),
            recordBody,
          ],
        )
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


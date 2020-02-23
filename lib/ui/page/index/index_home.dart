import 'package:flutter/material.dart';

class IndexHomePage extends StatefulWidget {
  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {
  ScrollController _controller = new ScrollController();
  String leftText='',rightText='';

  @override
  void initState() {
    _controller.addListener((){
      if(_controller.offset>120){
        setState(() {
          leftText="啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";
          rightText="11111111111111111111111111111111111111";
        });
      }else{
        setState(() {
          leftText="";
          rightText="";
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      controller: _controller,
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 170,
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
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("标题$index"),
          );
        },
        itemCount: 50,
      ),
    ));
  }

  Widget titleShow(){
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 40,width: 40,
                child: ClipRRect( //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(90.0),
                  child: Image.asset(
                    'images/static/loading.gif',
                    fit: BoxFit.fill,
                  ),
                ),),
              Container(
                child: Text(leftText,style: TextStyle(fontSize: 14,color: Colors.black26),),
                width: MediaQuery.of(context).size.width/2-80
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                  child: Text(rightText,style: TextStyle(fontSize: 14,color: Colors.black26),),
                  width: MediaQuery.of(context).size.width/2-80
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 40,width: 40,
                child: ClipRRect( //剪裁为圆角矩形
                  borderRadius: BorderRadius.circular(90.0),
                  child: Image.asset(
                    'images/static/loading.gif',
                    fit: BoxFit.fill,
                  ),
                ),),
            ],
          )
        ],
      ),
    );
  }

  Widget infoShow() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
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
                      child: Image.asset(
                        'images/static/loading.gif',
                        fit: BoxFit.fill,
                      ),
                    ),),
                  Text("自定义的名字"),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(height: 100,width: 100,
                    child: ClipRRect( //剪裁为圆角矩形
                      borderRadius: BorderRadius.circular(90.0),
                      child: Image.asset(
                        'images/static/loading.gif',
                        fit: BoxFit.fill,
                      ),
                    ),),
                  Text("自定义的昵称"),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("哈哈哈哈哈哈哈",style: TextStyle(fontSize: 16),),
          )
        ],
      )
    );
  }
}

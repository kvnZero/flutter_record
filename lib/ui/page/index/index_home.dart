import 'package:flutter/material.dart';

class IndexHomePage extends StatefulWidget {
  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Text("hello"),
        )
    );
  }
}

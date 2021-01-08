import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo_app_1/data.dart' as dataList;
import 'package:demo_app_1/suggestions.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var info;
  String query;
  int from;
  int size;

  @override
  void initState() {
    super.initState();
    info = new Map();
    query = "the";
    from = 0;
    size = 7;
  }

  void setFrom(int i) {
    Future.delayed(new Duration(seconds: 2), () async {
      setState(() {
        from = i;
      });
    });
  }

  void setInfo() {
    final jsonEncoder = JsonEncoder();
    setState(() {
      info["numberOfResults"] = dataList.DemoData.data
          .where((element) =>
              jsonDecode(jsonEncoder.convert(element))["original_title"]
                  .toLowerCase()
                  .startsWith(query.toLowerCase()))
          .toList()
          .length;
      info["time"] = 90;
      info["data"] = dataList.DemoData.data
          .where((element) =>
              jsonDecode(jsonEncoder.convert(element))["original_title"]
                  .toLowerCase()
                  .startsWith(query.toLowerCase()))
          .toList()
          .sublist(
              0,
              this.from + 10 < info["numberOfResults"]
                  ? this.from + this.size
                  : this.from + (info["numberOfResults"] - this.from));
    });
  }

  @override
  Widget build(BuildContext context) {
    setInfo();
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Infinite List"),
      ),
      body: new SuggestionsPage(
        result: info,
        loading: false,
        from: this.from,
        size: this.size,
        setFrom: this.setFrom,
      ),
    ));
  }
}

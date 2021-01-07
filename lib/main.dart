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
  var info = new Map();
  String query = "the";
  int from = 0;
  int size = 7;

  void setFrom(int i) {
    Future.delayed(new Duration(hours: 0, minutes: 0, seconds: 2), () async {
      print(i);
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

    print('list size ${info["data"].length}');
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

// class MyApp extends StatelessWidget {
//   int from = 0;
//   void setFrom(int i) {
//     print(i);
//     this.from = i;
//     setInfo();
//   }
//
//   var info = new Map();
//   String query = "the";
//
//   void setInfo() {
//     final jsonEncoder = JsonEncoder();
//     info["data"] = dataList.DemoData.data
//         .where((element) =>
//             jsonDecode(jsonEncoder.convert(element))["original_title"]
//                 .toLowerCase()
//                 .startsWith(query.toLowerCase()))
//         .toList()
//         .sublist(0, this.from + 10);
//     info["numberOfResults"] = dataList.DemoData.data
//         .where((element) =>
//             jsonDecode(jsonEncoder.convert(element))["original_title"]
//                 .toLowerCase()
//                 .startsWith(query.toLowerCase()))
//         .toList()
//         .length;
//     info["time"] = 90;
//     print('list size ${info["data"].length}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     setInfo();
//     return new MaterialApp(
//         home: new Scaffold(
//       appBar: new AppBar(
//         title: new Text("Infinite List"),
//       ),
//       body: new SuggestionsPage(
//         result: info,
//         loading: false,
//         from: this.from,
//         size: 10,
//         setFrom: this.setFrom,
//       ),
//     ));
//   }
// }

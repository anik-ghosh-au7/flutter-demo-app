import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo_app_1/data.dart' as dataList;
import 'package:demo_app_1/suggestions.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jsonEncoder = JsonEncoder();
    var info = new Map();
    String query = "the";

    info["data"] = dataList.DemoData.data
        .where((element) =>
            jsonDecode(jsonEncoder.convert(element))["original_title"]
                .toLowerCase()
                .startsWith(query.toLowerCase()))
        .toList();
    info["numberOfResults"] = info["data"].length;
    info["time"] = 90;
    return new MaterialApp(
      home: new SuggestionsPage(
        result: info,
        loading: false,
        from: 0,
        size: 10,
      ),
    );
  }
}

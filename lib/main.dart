import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:demo_app_1/data.dart' as data;
import 'package:demo_app_1/star.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jsonEncoder = JsonEncoder();
    String query = "the";
    return new MaterialApp(
      home: new SuggestionsPage(
        infoList: data.DemoData.data
            .where((element) =>
                jsonDecode(jsonEncoder.convert(element))["original_title"]
                    .toLowerCase()
                    .startsWith(query.toLowerCase()))
            .toList(),
        loading: false,
        size: 10,
        from: 0,
      ),
    );
  }
}

class SuggestionsPage extends StatefulWidget {
  List infoList = [];
  bool loading = true;
  int size = 5;
  int from = 0;

  SuggestionsPage({Key key, this.infoList, this.loading, this.size, this.from})
      : super(key: key);

  @override
  _SuggestionsPageState createState() => new _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final jsonEncoder = JsonEncoder();
  @override
  Widget build(BuildContext context) {
    print(widget.loading);
    print(widget.infoList.length);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Infinite List"),
        ),
        body: Column(
          children: [
            Card(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.white,
                  height: 20,
                  child: Text('${0} results found in ${0} ms'),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                    child: (index < widget.infoList.length)
                        ? Container(
                            margin: const EdgeInsets.all(0.5),
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            decoration: new BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            height: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Card(
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.network(
                                          widget.infoList[index]
                                              ["image_medium"],
                                          fit: BoxFit.fill,
                                        ),
                                        elevation: 5,
                                        margin: EdgeInsets.all(10),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 110,
                                            width: 280,
                                            child: ListTile(
                                              title: Text(
                                                widget.infoList[index]
                                                    ["original_title"],
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              subtitle: Text(
                                                widget.infoList[index]
                                                                ["authors"]
                                                            .join(", ")
                                                            .length >
                                                        100
                                                    ? 'By: ${widget.infoList[index]["authors"].join(", ").substring(0, 100)}...'
                                                    : 'By: ${widget.infoList[index]["authors"].join(", ")}',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              isThreeLine: true,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 0, 0, 0),
                                                child: IconTheme(
                                                  data: IconThemeData(
                                                    color: Colors.amber,
                                                    size: 48,
                                                  ),
                                                  child: StarDisplay(
                                                      value: widget
                                                              .infoList[index][
                                                          "average_rating_rounded"]),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 0, 0),
                                                child: Text(
                                                  '(${widget.infoList[index]["average_rating"]} avg)',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        27, 10, 0, 0),
                                                child: Text(
                                                  'Pub: ${widget.infoList[index]["original_publication_year"]}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : (widget.loading
                            ? Center(child: CircularProgressIndicator())
                            : ListTile(
                                title: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: widget.infoList.length > 0
                                          ? "No more results"
                                          : 'No results found',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ))),
                itemCount: widget.infoList.length + 1,
              ),
            ),
          ],
        ));
  }
}

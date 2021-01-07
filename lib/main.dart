import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo_app_1/data.dart' as dataList;
import 'package:demo_app_1/star.dart';

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

class SuggestionsPage extends StatefulWidget {
  Map result;
  bool loading = true;
  int size = 5;
  int from = 0;

  SuggestionsPage({Key key, this.result, this.loading, this.size, this.from})
      : super(key: key);

  @override
  _SuggestionsPageState createState() => new _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final jsonEncoder = JsonEncoder();
  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                      '${widget.result["numberOfResults"]} results found in ${widget.result["time"]} ms'),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                    child: (index < widget.result["data"].length)
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
                                          widget.result["data"][index]
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
                                                widget.result["data"][index]
                                                    ["original_title"],
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              subtitle: Text(
                                                widget.result["data"][index]
                                                                ["authors"]
                                                            .join(", ")
                                                            .length >
                                                        100
                                                    ? 'By: ${widget.result["data"][index]["authors"].join(", ").substring(0, 100)}...'
                                                    : 'By: ${widget.result["data"][index]["authors"].join(", ")}',
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
                                                      value: widget.result[
                                                              "data"][index][
                                                          "average_rating_rounded"]),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 0, 0),
                                                child: Text(
                                                  '(${widget.result["data"][index]["average_rating"]} avg)',
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
                                                  'Pub: ${widget.result["data"][index]["original_publication_year"]}',
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
                                      text: widget.result["data"].length > 0
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
                itemCount: widget.result["data"].length + 1,
              ),
            ),
          ],
        ));
  }
}

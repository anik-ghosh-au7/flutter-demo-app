import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:demo_app_1/data.dart' as data;
import 'package:demo_app_1/star.dart';

class DataSearch extends SearchDelegate<String> {
  final jsonEncoder = JsonEncoder();
  var result;
  int perPage = 7;
  int present = 0;
  bool isLoading = true;

  @override
  String get searchFieldLabel => 'Search Books';

  @override
  TextStyle get searchFieldStyle =>
      TextStyle(color: Colors.white, fontWeight: FontWeight.w400);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      primaryColor: Colors.black54,
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).primaryTextTheme.headline6.color),
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestionList = data.DemoData.data
        .where((element) =>
            jsonDecode(jsonEncoder.convert(element))["original_title"]
                .toLowerCase()
                .startsWith(query.toLowerCase()))
        .toList();

    if (suggestionList.length < (present + perPage)) {
      present = 0;
      perPage = 7;
    }

    List items = List();
    items.addAll(query.isEmpty
        ? []
        : suggestionList.getRange(
            present,
            (present + perPage) < suggestionList.length
                ? (present + perPage)
                : (suggestionList.length)));
    // print('${suggestionList.length}  ${present}');
    return suggestionList.isEmpty
        ? Container(
            child: Text('No items found'),
          )
        : StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: ListView.builder(
                itemBuilder: (context, index) => (index <
                            suggestionList.length &&
                        query.isNotEmpty)
                    ? Container(
                        margin: index < items.length
                            ? const EdgeInsets.all(1.0)
                            : const EdgeInsets.fromLTRB(1, 2, 1, 1),
                        padding: index < items.length
                            ? const EdgeInsets.all(3.0)
                            : null,
                        decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black26),
                        ),
                        child: (index >= items.length)
                            ? Container(
                                color: Colors.black12,
                                child: SizedBox(
                                  height: 35,
                                  child: TextButton(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Load More",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if ((present + perPage) >
                                            suggestionList.length) {
                                          items.addAll(suggestionList.getRange(
                                              present, suggestionList.length));
                                        } else {
                                          items.addAll(suggestionList.getRange(
                                              suggestionList.length > present
                                                  ? present
                                                  : suggestionList.length,
                                              present + perPage));
                                        }
                                        present = present + perPage;
                                      });
                                    },
                                  ),
                                ),
                              )
                            : ListTile(
                                isThreeLine: true,
                                leading: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 80,
                                    maxWidth: 64,
                                    maxHeight: 100,
                                  ),
                                  child: Image.network(
                                      jsonDecode(jsonEncoder
                                              .convert(suggestionList[index]))[
                                          "image_medium"],
                                      fit: BoxFit.cover),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                      text: query.isEmpty
                                          ? jsonDecode(jsonEncoder.convert(
                                                  suggestionList[index]))[
                                              "original_title"]
                                          : jsonDecode(jsonEncoder.convert(
                                                      suggestionList[index]))[
                                                  "original_title"]
                                              .substring(0, query.length),
                                      style: TextStyle(color: Colors.grey),
                                      children: [
                                        TextSpan(
                                          text: query.isEmpty
                                              ? ''
                                              : jsonDecode(jsonEncoder.convert(
                                                          suggestionList[
                                                              index]))[
                                                      "original_title"]
                                                  .substring(query.length),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ]),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              text: jsonDecode(jsonEncoder
                                                      .convert(suggestionList[
                                                          index]))["authors"]
                                                  .join(', '),
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconTheme(
                                          data: IconThemeData(
                                            color: Colors.amber,
                                            size: 48,
                                          ),
                                          child: StarDisplay(
                                              value: jsonDecode(jsonEncoder
                                                      .convert(suggestionList[
                                                          index]))[
                                                  "average_rating_rounded"]),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                // trailing: StarDisplay(
                                //     value: jsonDecode(jsonEncoder
                                //             .convert(suggestionList[index]))[
                                //         "average_rating_rounded"]),
                              ),
                      )
                    : null,
                itemCount: (present <= suggestionList.length)
                    ? items.length + 1
                    : items.length,
              ),
            );
          });
  }
}

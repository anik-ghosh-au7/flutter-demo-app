import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:demo_app_1/delegate.dart';

void main() {
  runApp(MaterialApp(
    home: DemoSearch(),
  ));
}

class DemoSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openSearch() {
      showSearch(context: context, delegate: DataSearch());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.fromLTRB(8.3, 0, 0, 0),
            icon: Icon(Icons.search),
            onPressed: () {
              openSearch();
            },
          ),
          FlatButton(
            minWidth: 380,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 202.47, 0),
              child: RichText(
                text: TextSpan(
                  text: "Search Books",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            onPressed: () {
              openSearch();
            },
          ),
        ],
      ),
    );
  }
}

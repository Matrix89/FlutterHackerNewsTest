import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:flutter_app/page/Comments.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as launcher;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Item>> fetchNews() async {
    final postList = (await http
            .get("https://hacker-news.firebaseio.com/v0/topstories.json"))
        .body;
    final postIds =
        postList.replaceFirst("[", "").split(","); /* please don't kill me */
    return Future.wait(postIds.getRange(0, 10).map((v) => Item.fetch(v)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Articles"),
        ),
        body: FutureBuilder(
            future: fetchNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: (snapshot.data as List<Item>)
                      .map((Item news) => ListTile(
                          onTap: news.descendants != 0
                              ? () {
                                  launcher.launch(news.url);
                                }
                              : null,
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new Comments(news.kids)));
                          },
                          subtitle: Row(children: <Widget>[
                            Text(
                                "comments: ${news.descendants} score: ${news.score}")
                          ]),
                          title: Text(news.title)))
                      .toList(),
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}

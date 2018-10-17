import 'dart:convert';

import 'Comments.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class News extends StatefulWidget {
  final String endpoint;

  News(this.endpoint);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<List<Item>> fetchNews() async {
    final postList = (await http
            .get("https://hacker-news.firebaseio.com/v0/${widget.endpoint}.json"))
        .body;
    List<dynamic> postIds = jsonDecode(postList);
    return Future.wait(postIds.getRange(0, 10).map((v) => Item.fetch("$v")));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                                builder: (context) => new Comments(news.kids)));
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
        });
  }
}

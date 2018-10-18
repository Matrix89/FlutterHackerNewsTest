import 'package:flutter_app/HackerNews.dart';

import 'Comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class News extends StatefulWidget {
  final HackerNews api;
  final String endpoint;

  News(this.endpoint, this.api);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<List<Item>> fetchNews() async => widget.api
      .top(widget.endpoint)
      .then((top) => top.getRange(0, 10))
      .then((top) => Future.wait(top.map((id) => widget.api.item(id))));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: (snapshot.data as List<Item>)
                .map((Item news) => ListTile(
                    onTap: news.descendants != 0
                        ? () => launcher.launch(news.url)
                        : null,
                    onLongPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Comments(news.kids, widget.api)));
                    },
                    subtitle: Row(children: <Widget>[
                      Text("comments: ${news.descendants} score: ${news.score}")
                    ]),
                    title: Text(news.title)))
                .toList(),
          );
        });
  }
}

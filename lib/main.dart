import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

class Item {
  final int id;
  final String title;
  final String url;
  final String text;
  final int score;
  final int descendants;
  final List<String> kids;

  Item({this.id, this.title, this.url, this.text, this.score, this.descendants, this.kids});

  factory Item.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];
    return Item(
        id: json['id'],
        title: json['title'],
        url: json['url'],
        text: json['text'] != null ? json['text'] : "",
        score: json['score'],
        descendants: json['descendants'],
        kids: json['kids'] != null
            ? (json['kids'] as List<dynamic>).map((v) => "$v").toList()
            : List<String>());
  }
}

Future<Item> fetchItem(String id) async {
  return http
      .get("https://hacker-news.firebaseio.com/v0/item/$id.json")
      .then((v) => Item.fromJson(jsonDecode(v.body)));
}

class CommentsPage extends StatefulWidget {
  List<String> ids;

  CommentsPage(List<String> ids) {
    this.ids = ids;
  }

  @override
  State<StatefulWidget> createState() => _CommentsState(ids);
}

class _CommentsState extends State<CommentsPage> {
  Future<List<Item>> fetchComments(List<String> ids) =>
      Future.wait(ids.map((id) => fetchItem(id)));

  _CommentsState(List<String> ids) {
    fetchComments(ids).then((l) {
      l.forEach((comment) => print(comment.text));
      setState(() {
        comments.addAll(l);
      });
    });
  }

  List<Item> comments = List();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: ListView.separated(
        itemCount: comments.length,
        itemBuilder: (context, i) {
          final comment = comments[i];
          return ListTile(title: new Text(comment.text));
        },
        separatorBuilder: (c, i) => Divider(color: Colors.blue),
      ));
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Item> news = new List();

  Future<List<Item>> fetchNews() async {
    final postList = (await http
            .get("https://hacker-news.firebaseio.com/v0/topstories.json"))
        .body;
    final postIds = postList.replaceFirst("[", "").split(","); /* please don't kill me */
    return Future.wait(postIds.getRange(0, 10).map((v) => fetchItem(v)));
  }

  _MyHomePageState() {
    fetchNews().then((a) {
      setState(() {
        news.addAll(a);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Articles"),
        ),
        body: ListView(
          children: news
              .map((Item news) => ListTile(
                  onTap: news.descendants != 0 ? () {
                    launcher.launch(news.url);
                  } : null,
                  onLongPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new CommentsPage(news.kids)));
                  },
                  subtitle: Row(children: <Widget>[
                    Text("comments: ${news.descendants} score: ${news.score}")
                  ]),
                  title: Text(news.title)))
              .toList(),
        ));
  }
}

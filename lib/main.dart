import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter_html_widget/flutter_html_widget.dart';

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
      Future.wait(ids.map((id) => Item.fetch(id)));

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
          return ListTile(title: new HtmlWidget(html: comment.text));
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
    return Future.wait(postIds.getRange(0, 10).map((v) => Item.fetch(v)));
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

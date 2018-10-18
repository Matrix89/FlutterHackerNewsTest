import 'package:flutter/material.dart';
import 'package:flutter_app/HackerNews.dart';
import 'package:flutter_app/page/News.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HackerNews api = HackerNews();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(title: Text("The Hacker News"),
              bottom: TabBar(tabs: [Tab(text: "News"), Tab(text: "Show"), Tab(text: "Ask")])),
          body: TabBarView(children: [
            new News("topstories", api),
            new News("showstories", api),
            new News("askstories", api),
          ]),
        ));
  }
}

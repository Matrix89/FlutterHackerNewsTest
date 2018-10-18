import 'package:flutter/material.dart';
import 'package:flutter_app/HackerNews.dart';
import 'package:flutter_app/page/News.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
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
            News("topstories", api),
            News("showstories", api),
            News("askstories", api),
          ]),
        ));
  }
}

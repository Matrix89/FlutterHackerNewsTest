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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.api.top(widget.endpoint),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final ids = (snapshot.data as List).cast<int>();

          return ListView.builder(
              itemCount: ids.length,
              itemBuilder: (c, i) => FutureBuilder(
                    future: widget.api.item(ids[i]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return ListTile(title: Text("loading..."));
                      }
                      final item = snapshot.data as Item;

                      return ListTile(
                        onLongPress: () => item.descendants != 0
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        Comments(item.kids, widget.api)))
                            : null,
                        onTap: () => launcher.launch(item.url),
                        title: Text(item.title),
                        subtitle: Text(
                            "comments: ${item.descendants} score: ${item.score}"),
                      );
                    },
                  ));
        });
  }
}

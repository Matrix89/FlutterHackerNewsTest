import 'package:flutter/material.dart';
import 'package:flutter_app/HackerNews.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:flutter_html_widget/flutter_html_widget.dart';

class Comments extends StatefulWidget {
  final List<int> ids;
  final HackerNews api;

  Comments(this.ids, this.api);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  Future<List<Item>> fetchComments() =>
      Future.wait(widget.ids.map((id) => widget.api.item(id)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: FutureBuilder(
          future: fetchComments(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<Item>;

              return ListView.separated(
                  itemBuilder: (context, i) =>
                      ListTile(title: HtmlWidget(html: data[i].text)),
                  separatorBuilder: (context, i) => Divider(color: Colors.blue),
                  itemCount: data.length);
            }

            return LinearProgressIndicator();
          }),
    );
  }
}

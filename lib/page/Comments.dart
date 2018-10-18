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
  Future<List<Item>> fetchComments(List<int> ids) =>
      Future.wait(ids.map((id) => widget.api.item(id)).toList());

  Widget _buildCommentColumn(List<int> ids) {
    return FutureBuilder(
        future: fetchComments(ids),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<Item>;
            return SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: data
                        .map((c) => Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HtmlWidget(html: c.text),
                                Divider(color: Colors.orange),
                                _buildCommentColumn(c.kids),
                              ],
                            )))
                        .toList()));
          }
          return LinearProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: _buildCommentColumn(widget.ids),
    );
  }
}

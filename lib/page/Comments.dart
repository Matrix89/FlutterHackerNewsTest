import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:flutter_html_widget/flutter_html_widget.dart';

class Comments extends StatefulWidget {
  List<String> ids;

  Comments(List<String> kids) {
    this.ids = kids;
  }

  @override
  _CommentsState createState() => _CommentsState(ids);
}

class _CommentsState extends State<Comments> {
  List<String> ids;

  _CommentsState(List<String> ids) {
    this.ids = ids;
  }

  Future<List<Item>> fetchComments() =>
      Future.wait(ids.map((id) => Item.fetch(id)));

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

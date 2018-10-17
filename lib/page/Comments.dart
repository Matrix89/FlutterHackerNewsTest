import 'package:flutter/material.dart';
import 'package:flutter_app/data/Item.dart';
import 'package:flutter_html_widget/flutter_html_widget.dart';
import 'package:http/http.dart' as http;

class Comments extends StatefulWidget {
  final List<String> ids;

  Comments(this.ids);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  Future<List<Item>> fetchComments() {
    final client = http.Client();
    return Future.wait(widget.ids.map((id) => Item.fetch(id, client)))
        .whenComplete(() => client.close());
  }

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

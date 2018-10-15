import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static Future<Item> fetch(String id) async {
    return http
        .get("https://hacker-news.firebaseio.com/v0/item/$id.json")
        .then((v) => Item.fromJson(jsonDecode(v.body)));
  }

}


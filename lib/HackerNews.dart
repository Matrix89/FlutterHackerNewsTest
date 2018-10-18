import 'dart:io';

import 'dart:convert';

import 'package:flutter_app/data/Item.dart';

class HackerNews {
  HackerNews();

  Future<List<dynamic>> top(String endpoint) => HttpClient()
      .getUrl(
          Uri.parse("https://hacker-news.firebaseio.com/v0/$endpoint.json"))
      .then((r) => r.close())
      .then((r) => r.transform(utf8.decoder).join())
      .then((body) => jsonDecode(body));

  Future<Item> item(int id) => HttpClient()
      .getUrl(Uri.parse("https://hacker-news.firebaseio.com/v0/item/$id.json"))
      .then((r) => r.close())
      .then((r) => r.transform(utf8.decoder).join())
      .then((body) => Item.fromJson(jsonDecode(body)))
      .catchError((e) => print(e));
}

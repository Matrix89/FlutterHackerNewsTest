class Item {
  final int id;
  final String title;
  final String url;
  final String text;
  final String by;
  final int score;
  final int descendants;
  final List<int> kids;

  Item(
      {this.id,
      this.title,
      this.url,
      this.text,
      this.by,
      this.score,
      this.descendants,
      this.kids});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      text: json['text'] ?? "",
      by: json['by'] ?? "",
      score: json['score'],
      descendants: json['descendants'] ?? 0,
      kids: (json['kids'] as List)?.cast<int>() ?? List<int>());
}

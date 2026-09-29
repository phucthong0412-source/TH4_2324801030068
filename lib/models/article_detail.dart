class ArticleDetail {
  final String title;
  final String description;
  final List<ArticleContent> contents;

  ArticleDetail({
    required this.title,
    required this.description,
    required this.contents,
  });
}

class ArticleContent {
  final String type;
  final String value;
  final String? caption;

  ArticleContent({
    required this.type,
    required this.value,
    this.caption,
  });
}
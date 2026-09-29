import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html_parser;

import '../models/news_item.dart';

class RssService {
  Future<List<NewsItem>> fetchNews(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Không thể tải RSS. Mã lỗi: ${response.statusCode}',
        );
      }

      final String data = utf8.decode(response.bodyBytes);

      final XmlDocument document = XmlDocument.parse(data);

      final items = document.findAllElements('item');

      return items.map((item) {
        final title =
            item.getElement('title')?.innerText.trim() ?? '';

        final description =
            item.getElement('description')?.innerText.trim() ?? '';

        final link =
            item.getElement('link')?.innerText.trim() ?? '';

        final pubDate =
            item.getElement('pubDate')?.innerText.trim() ?? '';

        return NewsItem(
          title: title,
          description: _getDescription(description),
          link: link,
          pubDate: pubDate,
          imageUrl: _getImage(description),
        );
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tải tin: $e');
    }
  }

  String _getImage(String description) {
    try {
      final document = html_parser.parse(description);

      final image = document.querySelector('img');

      return image?.attributes['src'] ?? '';
    } catch (_) {
      return '';
    }
  }

  String _getDescription(String description) {
    try {
      final document = html_parser.parse(description);

      return document.body?.text.trim() ?? '';
    } catch (_) {
      return description;
    }
  }
}
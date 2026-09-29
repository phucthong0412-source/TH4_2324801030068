import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

import '../models/article_detail.dart';

class ArticleService {
  Future<ArticleDetail> fetchArticle(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120 Safari/537.36',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể tải bài báo. Mã lỗi: ${response.statusCode}',
      );
    }

    final document = html_parser.parse(response.body);

    // =========================
    // TIÊU ĐỀ
    // =========================

    final title =
        document.querySelector('h1.title-detail')?.text.trim() ??
            document.querySelector('h1')?.text.trim() ??
            'Không có tiêu đề';

    // =========================
    // MÔ TẢ / SAPO
    // =========================

    final description =
        document.querySelector('p.description')?.text.trim() ??
            '';

    // =========================
    // NỘI DUNG BÀI
    // =========================

    final article =
        document.querySelector('article.fck_detail') ??
            document.querySelector('.fck_detail');

    final List<ArticleContent> contents = [];

    if (article != null) {
      for (final node in article.children) {
        _parseNode(node, contents);
      }
    }

    return ArticleDetail(
      title: title,
      description: description,
      contents: contents,
    );
  }

  void _parseNode(
      Element element,
      List<ArticleContent> contents,
      ) {
    // =========================
    // ĐOẠN VĂN
    // =========================

    if (element.localName == 'p') {
      final text = element.text.trim();

      if (text.isNotEmpty) {
        contents.add(
          ArticleContent(
            type: 'text',
            value: text,
          ),
        );
      }

      return;
    }

    // =========================
    // FIGURE / ẢNH
    // =========================

    if (element.localName == 'figure') {
      final image = element.querySelector('img');

      if (image != null) {
        String imageUrl =
            image.attributes['data-src'] ??
                image.attributes['src'] ??
                '';

        if (imageUrl.startsWith('//')) {
          imageUrl = 'https:$imageUrl';
        }

        if (imageUrl.isNotEmpty) {
          final caption =
          element.querySelector('figcaption')?.text.trim();

          contents.add(
            ArticleContent(
              type: 'image',
              value: imageUrl,
              caption: caption,
            ),
          );
        }
      }

      return;
    }

    // =========================
    // TRƯỜNG HỢP ẢNH NẰM TRONG DIV
    // =========================

    final images = element.querySelectorAll('img');

    if (images.isNotEmpty) {
      for (final image in images) {
        String imageUrl =
            image.attributes['data-src'] ??
                image.attributes['src'] ??
                '';

        if (imageUrl.startsWith('//')) {
          imageUrl = 'https:$imageUrl';
        }

        if (imageUrl.isNotEmpty) {
          contents.add(
            ArticleContent(
              type: 'image',
              value: imageUrl,
            ),
          );
        }
      }

      return;
    }

    // =========================
    // CÁC THẺ CON KHÁC
    // =========================

    if (element.children.isNotEmpty) {
      for (final child in element.children) {
        _parseNode(
          child,
          contents,
        );
      }

      return;
    }

    final text = element.text.trim();

    if (text.isNotEmpty) {
      contents.add(
        ArticleContent(
          type: 'text',
          value: text,
        ),
      );
    }
  }
}
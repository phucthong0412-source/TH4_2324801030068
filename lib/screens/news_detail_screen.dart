import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../models/article_detail.dart';
import '../services/article_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsItem news;

  const NewsDetailScreen({
    super.key,
    required this.news,
  });

  @override
  State<NewsDetailScreen> createState() =>
      _NewsDetailScreenState();
}

class _NewsDetailScreenState
    extends State<NewsDetailScreen> {
  final ArticleService articleService =
  ArticleService();

  late Future<ArticleDetail> articleFuture;

  @override
  void initState() {
    super.initState();

    articleFuture =
        articleService.fetchArticle(
          widget.news.link,
        );
  }

  Future<void> refreshArticle() async {
    setState(() {
      articleFuture =
          articleService.fetchArticle(
            widget.news.link,
          );
    });

    await articleFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHI TIẾT TIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<ArticleDetail>(
        future: articleFuture,
        builder: (context, snapshot) {
          // =====================
          // LOADING
          // =====================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =====================
          // ERROR
          // =====================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Không thể tải chi tiết bài báo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${snapshot.error}',
                      textAlign:
                      TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed:
                      refreshArticle,
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      label: const Text(
                        'Thử lại',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final article =
          snapshot.data!;

          // =====================
          // HIỂN THỊ BÀI
          // =====================

          return RefreshIndicator(
            onRefresh: refreshArticle,

            child: ListView(
              padding:
              const EdgeInsets.all(16),

              children: [
                // TIÊU ĐỀ

                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight:
                    FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 10),

                // NGUỒN

                Row(
                  children: [
                    const Icon(
                      Icons.rss_feed,
                      size: 18,
                      color: Colors.blue,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      'VnExpress',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        widget.news.pubDate,
                        style:
                        const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // MÔ TẢ

                if (article
                    .description
                    .isNotEmpty)
                  Text(
                    article.description,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w600,
                      height: 1.5,
                    ),
                  ),

                const SizedBox(height: 16),

                // NỘI DUNG

                ...article.contents.map(
                      (content) {
                    if (content.type ==
                        'image') {
                      return _buildImage(
                        content,
                      );
                    }

                    return _buildText(
                      content.value,
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    'Nguồn: VnExpress',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 16,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          height: 1.65,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildImage(
      ArticleContent content,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(8),

            child: Image.network(
              content.value,

              width: double.infinity,

              fit: BoxFit.fitWidth,

              loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                  ) {
                if (loadingProgress ==
                    null) {
                  return child;
                }

                return Container(
                  height: 220,
                  alignment:
                  Alignment.center,
                  child:
                  const CircularProgressIndicator(),
                );
              },

              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  height: 200,
                  color:
                  Colors.grey.shade200,
                  alignment:
                  Alignment.center,
                  child: const Icon(
                    Icons
                        .broken_image_outlined,
                    size: 50,
                  ),
                );
              },
            ),
          ),

          if (content.caption != null &&
              content.caption!
                  .isNotEmpty) ...[
            const SizedBox(height: 6),

            Text(
              content.caption!,
              style: const TextStyle(
                fontSize: 13,
                fontStyle:
                FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
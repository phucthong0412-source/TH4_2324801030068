import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../services/rss_service.dart';
import '../widgets/news_item_widget.dart';

class LatestNewsScreen extends StatefulWidget {
  const LatestNewsScreen({super.key});

  @override
  State<LatestNewsScreen> createState() =>
      _LatestNewsScreenState();
}

class _LatestNewsScreenState
    extends State<LatestNewsScreen> {
  final RssService rssService = RssService();

  late Future<List<NewsItem>> newsFuture;

  final String rssUrl =
      'https://vnexpress.net/rss/tin-moi-nhat.rss';

  @override
  void initState() {
    super.initState();

    newsFuture = rssService.fetchNews(rssUrl);
  }

  Future<void> refreshNews() async {
    setState(() {
      newsFuture =
          rssService.fetchNews(rssUrl);
    });

    await newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsItem>>(
      future: newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Không thể tải tin mới nhất',
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: refreshNews,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final allNews = snapshot.data ?? [];

        final latestNews =
        allNews.take(10).toList();

        if (latestNews.isEmpty) {
          return const Center(
            child: Text(
              'Không có tin mới',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: refreshNews,
          child: ListView.builder(
            itemCount: latestNews.length,
            itemBuilder: (context, index) {
              return NewsItemWidget(
                news: latestNews[index],
              );
            },
          ),
        );
      },
    );
  }
}
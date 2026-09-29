import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../services/rss_service.dart';
import '../widgets/news_item_widget.dart';

class TopicNewsScreen extends StatefulWidget {
  final String title;
  final String rssUrl;

  const TopicNewsScreen({
    super.key,
    required this.title,
    required this.rssUrl,
  });

  @override
  State<TopicNewsScreen> createState() =>
      _TopicNewsScreenState();
}

class _TopicNewsScreenState
    extends State<TopicNewsScreen> {
  final RssService rssService = RssService();

  late Future<List<NewsItem>> newsFuture;

  @override
  void initState() {
    super.initState();

    newsFuture =
        rssService.fetchNews(widget.rssUrl);
  }

  Future<void> refreshNews() async {
    setState(() {
      newsFuture =
          rssService.fetchNews(widget.rssUrl);
    });

    await newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<NewsItem>>(
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
                  const Text(
                    'Không thể tải tin',
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

          final news = snapshot.data ?? [];

          if (news.isEmpty) {
            return const Center(
              child: Text('Không có tin'),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshNews,
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return NewsItemWidget(
                  news: news[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
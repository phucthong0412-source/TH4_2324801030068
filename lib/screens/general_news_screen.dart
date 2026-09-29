import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../services/rss_service.dart';
import '../widgets/news_item_widget.dart';

class GeneralNewsScreen extends StatefulWidget {
  const GeneralNewsScreen({super.key});

  @override
  State<GeneralNewsScreen> createState() =>
      _GeneralNewsScreenState();
}

class _GeneralNewsScreenState
    extends State<GeneralNewsScreen> {
  final RssService rssService = RssService();

  late Future<List<NewsItem>> newsFuture;

  final String rssUrl =
      'https://vnexpress.net/rss/tin-noi-bat.rss';

  @override
  void initState() {
    super.initState();

    newsFuture = rssService.fetchNews(rssUrl);
  }

  Future<void> refreshNews() async {
    setState(() {
      newsFuture = rssService.fetchNews(rssUrl);
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Không thể tải tin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: refreshNews,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        final news = snapshot.data ?? [];

        if (news.isEmpty) {
          return const Center(
            child: Text('Không có tin tức'),
          );
        }

        return RefreshIndicator(
          onRefresh: refreshNews,
          child: ListView.builder(
            physics:
            const AlwaysScrollableScrollPhysics(),
            itemCount: news.length,
            itemBuilder: (context, index) {
              return NewsItemWidget(
                news: news[index],
              );
            },
          ),
        );
      },
    );
  }
}
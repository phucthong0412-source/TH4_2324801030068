import 'package:flutter/material.dart';

import 'topic_news_screen.dart';

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'name': 'Thời sự',
        'icon': Icons.public,
        'url':
        'https://vnexpress.net/rss/thoi-su.rss',
      },
      {
        'name': 'Thế giới',
        'icon': Icons.language,
        'url':
        'https://vnexpress.net/rss/the-gioi.rss',
      },
      {
        'name': 'Kinh doanh',
        'icon': Icons.business_center,
        'url':
        'https://vnexpress.net/rss/kinh-doanh.rss',
      },
      {
        'name': 'Thể thao',
        'icon': Icons.sports_soccer,
        'url':
        'https://vnexpress.net/rss/the-thao.rss',
      },
      {
        'name': 'Giải trí',
        'icon': Icons.movie_outlined,
        'url':
        'https://vnexpress.net/rss/giai-tri.rss',
      },
      {
        'name': 'Sức khỏe',
        'icon': Icons.health_and_safety_outlined,
        'url':
        'https://vnexpress.net/rss/suc-khoe.rss',
      },
      {
        'name': 'Đời sống',
        'icon': Icons.home_outlined,
        'url':
        'https://vnexpress.net/rss/doi-song.rss',
      },
      {
        'name': 'Du lịch',
        'icon': Icons.flight,
        'url':
        'https://vnexpress.net/rss/du-lich.rss',
      },
      {
        'name': 'Khoa học công nghệ',
        'icon': Icons.computer,
        'url':
        'https://vnexpress.net/rss/khoa-hoc-cong-nghe.rss',
      },
      {
        'name': 'Xe',
        'icon': Icons.directions_car,
        'url':
        'https://vnexpress.net/rss/oto-xe-may.rss',
      },
      {
        'name': 'Bất động sản',
        'icon': Icons.apartment,
        'url':
        'https://vnexpress.net/rss/bat-dong-san.rss',
      },
      {
        'name': 'Giáo dục',
        'icon': Icons.school,
        'url':
        'https://vnexpress.net/rss/giao-duc.rss',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(10),

      itemCount: topics.length,

      separatorBuilder: (context, index) {
        return const Divider(height: 1);
      },

      itemBuilder: (context, index) {
        final topic = topics[index];

        return ListTile(
          leading: CircleAvatar(
            child: Icon(
              topic['icon'] as IconData,
            ),
          ),

          title: Text(
            topic['name'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TopicNewsScreen(
                    title: topic['name'] as String,
                    rssUrl: topic['url'] as String,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
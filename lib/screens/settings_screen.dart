import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  Future<void> openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'giaovien@example.com',
      query: 'subject=Liên hệ về bài tập Flutter',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // =========================
        // GIAO DIỆN
        // =========================

        const Text(
          'Giao diện',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Card(
          child: SwitchListTile(
            secondary: Icon(
              isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),

            title: const Text(
              'Chế độ tối',
            ),

            subtitle: Text(
              isDarkMode
                  ? 'Đang sử dụng giao diện tối'
                  : 'Đang sử dụng giao diện sáng',
            ),

            value: isDarkMode,

            onChanged: onThemeChanged,
          ),
        ),

        const SizedBox(height: 20),

        // =========================
        // THÔNG TIN SINH VIÊN
        // =========================

        const Text(
          'Thông tin sinh viên',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Họ và tên'),
                subtitle: Text(
                  'Hồ Nguyễn Phúc Thông',
                ),
              ),

              Divider(height: 1),

              ListTile(
                leading: Icon(Icons.badge),
                title: Text('MSSV'),
                subtitle: Text(
                  '2324801030068',
                ),
              ),

              Divider(height: 1),

              ListTile(
                leading: Icon(Icons.school),
                title: Text('Lớp'),
                subtitle: Text(
                  'D23KTPM01',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),


        // =========================
        // THÔNG TIN ỨNG DỤNG
        // =========================

        const Text(
          'Thông tin ứng dụng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.newspaper),
                title: Text(
                  'Ứng dụng đọc báo Online',
                ),
              ),

              Divider(height: 1),

              ListTile(
                leading: Icon(Icons.rss_feed),
                title: Text('Nguồn dữ liệu'),
                subtitle: Text(
                  'VnExpress RSS',
                ),
              ),

              Divider(height: 1),

              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Phiên bản'),
                subtitle: Text('1.0.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_widgets.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final int coursesCount;
  const HomePage({super.key, required this.coursesCount});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat Datang,', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(studentName, style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700)),
          const SizedBox(height: 24),
          const ProfileSummaryCard(studentId: studentId, studentName: studentName),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoBox(context, 'Total Topik', '$coursesCount Courses', Icons.library_books)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoBox(context, 'Total Favorit', '$favoriteCount Disukai', Icons.favorite)),
            ],
          ),
          const SizedBox(height: 24),
          const LocalStateCard(),
          const SizedBox(height: 16),
          const ValueNotifierCard(),
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
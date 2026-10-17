import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class ProfileSummaryCard extends StatelessWidget {
  final String studentId;
  final String studentName;
  const ProfileSummaryCard({super.key, required this.studentId, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade800]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 50, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kartu Mahasiswa', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(studentName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(studentId, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final int index;
  final Course course;

  const CourseCard({super.key, required this.index, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailPage(course: course))),
        child: Center(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade100, child: Text('$index')),
            title: Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${course.code} | ${course.credits} SKS'),
            trailing: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFavorite = provider.favorites.contains(course.code);
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                  onPressed: () => context.read<CourseProvider>().toggleFavorite(course.code),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocalStateCard extends StatefulWidget {
  const LocalStateCard({super.key});
  @override
  State<LocalStateCard> createState() => _LocalStateCardState();
}

class _LocalStateCardState extends State<LocalStateCard> {
  bool isFavorite = false; 
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.deepPurple),
        title: const Text('Materi Provider'),
        subtitle: const Text('Belajar Local vs Shared State'),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
          onPressed: () => setState(() => isFavorite = !isFavorite),
        ),
      ),
    );
  }
}

class ValueNotifierCard extends StatefulWidget {
  const ValueNotifierCard({super.key});
  @override
  State<ValueNotifierCard> createState() => _ValueNotifierCardState();
}

class _ValueNotifierCardState extends State<ValueNotifierCard> {
  final ValueNotifier<int> _favoriteCount = ValueNotifier<int>(0);
  @override
  void dispose() {
    _favoriteCount.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.numbers, color: Colors.deepPurple),
        title: const Text('Tahap 4: ValueNotifier'),
        subtitle: ValueListenableBuilder<int>(
          valueListenable: _favoriteCount,
          builder: (context, value, child) => Text('Jumlah di-klik: $value kali'),
        ),
        trailing: ElevatedButton(
          onPressed: () => _favoriteCount.value++, 
          child: const Text('Klik Saya'),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code), 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // TAHAP 13: Menambahkan tombol Favorite di Halaman Detail menggunakan Consumer
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              final isFavorite = provider.favorites.contains(course.code);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<CourseProvider>().toggleFavorite(course.code);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(leading: const Icon(Icons.school), title: const Text('Beban Studi'), subtitle: Text('${course.credits} SKS')),
            ListTile(leading: const Icon(Icons.info), title: const Text('Status'), subtitle: Text(course.status)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Katalog'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
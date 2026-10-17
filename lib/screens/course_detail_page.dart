import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.code), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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
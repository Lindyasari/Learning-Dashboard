import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_widgets.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class CoursesPage extends StatelessWidget {
  final List<Course> courses;
  const CoursesPage({super.key, required this.courses});

  // 1 & 2. Konstanta URL dan Fungsi GET sementara untuk Tahap 2
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  Future<void> testFetchCourses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // 3. Tampilkan jumlah item di debug console
        debugPrint('Berhasil! Jumlah item API: ${data.length}');
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Terjadi Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Katalog Mata Kuliah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // Tombol sementara untuk memicu API di Tahap 2
              ElevatedButton(
                onPressed: () => testFetchCourses(),
                child: const Text('Test API GET'),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) =>
                      CourseCard(index: index + 1, course: courses[index]),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 900 ? 2 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 100,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) =>
                    CourseCard(index: index + 1, course: courses[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
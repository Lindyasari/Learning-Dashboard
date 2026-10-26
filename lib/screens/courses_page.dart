import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_widgets.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class CoursesPage extends StatefulWidget {
  final List<Course> courses;
  const CoursesPage({super.key, required this.courses});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // Variabel state untuk menyimpan list yang akan ditampilkan di layar
  List<Course> _displayCourses = [];
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  @override
  void initState() {
    super.initState();
    _displayCourses = widget.courses; // Tampilkan dummy saat pertama kali buka
  }

  Future<void> testFetchCourses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Konversi response JSON list menjadi List<Course> dan update layar
        setState(() {
          _displayCourses = data.map((json) => Course.fromJson(json)).toList();
        });
        debugPrint('Berhasil memuat ${_displayCourses.length} data API ke layar');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ni Komang Tri Lindyasari - 2415051017',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Katalog Mata Kuliah',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => testFetchCourses(),
                    child: const Text('Test API GET'),
                  ),
                ],
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
                  itemCount: _displayCourses.length,
                  itemBuilder: (context, index) =>
                      CourseCard(index: index + 1, course: _displayCourses[index]),
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
                itemCount: _displayCourses.length,
                itemBuilder: (context, index) =>
                    CourseCard(index: index + 1, course: _displayCourses[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
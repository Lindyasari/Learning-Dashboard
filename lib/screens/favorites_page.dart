import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_widgets.dart';

// Identitas Mahasiswa:
// Nama: Ni Komang Tri Lindyasari
// NIM : 2415051017

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        // Filter daftar course yang kodenya ada di dalam set favorites
        final favoriteCourses = provider.courses
            .where((course) => provider.favorites.contains(course.code))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Mata Kuliah Favorit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: favoriteCourses.isEmpty
                  ? const Center(child: Text('Belum ada mata kuliah favorit.'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: favoriteCourses.length,
                            itemBuilder: (context, index) => CourseCard(index: index + 1, course: favoriteCourses[index]),
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: constraints.maxWidth < 900 ? 2 : 3,
                            crossAxisSpacing: 16, mainAxisSpacing: 16, mainAxisExtent: 100, 
                          ),
                          itemCount: favoriteCourses.length,
                          itemBuilder: (context, index) => CourseCard(index: index + 1, course: favoriteCourses[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
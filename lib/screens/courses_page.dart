import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_widgets.dart';
import '../widgets/error_view.dart';
import 'add_course_page.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan state dari provider
    final provider = context.watch<CourseProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CATATAN: 'const' di depan Padding dihapus karena di dalamnya ada fungsi Navigator yang dinamis
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
              
              // --- KODE YANG DIUBAH UNTUK TAHAP 6 ADA DI SINI ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Katalog Mata Kuliah',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('TOMBOL TAMBAH BERHASIL DIKLIK!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddCoursePage()),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Tambah'),
                  ),
                ],
              ),
              // --------------------------------------------------
              
            ],
          ),
        ),
        Expanded(
          // Panggil fungsi pembangun konten berdasarkan state
          child: _buildContent(context, provider),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, CourseProvider provider) {
    // 1. Loading State
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error State
    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: provider.loadCourses,
      );
    }

    // 3. Empty State
    if (provider.courses.isEmpty) {
      return const Center(child: Text('Data course belum tersedia'));
    }

    // 4. Success State (Tampilkan list data)
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.courses.length,
            itemBuilder: (context, index) =>
                CourseCard(index: index + 1, course: provider.courses[index]),
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
          itemCount: provider.courses.length,
          itemBuilder: (context, index) =>
                CourseCard(index: index + 1, course: provider.courses[index]),
        );
      },
    );
  }
}
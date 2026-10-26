import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import 'edit_course_page.dart';

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
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCoursePage(course: course),
                ),
              );
            },
          ),

    // Nama : Ni Komang Tri Lindyasari
    // NIM : 2415051017
    
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              // Tampilkan AlertDialog konfirmasi sebelum menghapus
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Mata Kuliah'),
                  content: const Text('Apakah Anda yakin ingin menghapus course ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                if (!context.mounted) return;
                
                final provider = context.read<CourseProvider>();
                final success = await provider.deleteCourse(course.id!, course.code);

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Berhasil menghapus mata kuliah')),
                  );
                  Navigator.pop(context); // Kembali ke halaman utama setelah hapus
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: ${provider.error}')),
                  );
                }
              }
            },
          ),
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
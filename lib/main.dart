import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

Future<Map<String, dynamic>> loadStudentData() async {
  await Future.delayed(const Duration(seconds: 1));
  final String jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // --- TAHAP 5: FUNGSI UNTUK MENENTUKAN JUMLAH KOLOM GRID ---
  int columnsFor(double width) {
    if (width < 600) return 1; // Layar HP (Portrait) = 1 Kolom
    if (width < 840) return 2; // Layar Tablet/Landscape = 2 Kolom
    return 3;                  // Layar Desktop/Sangat Lebar = 3 Kolom
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Gagal memuat data: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            }

            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;
            
            // Variabel totalCredits dikembalikan karena kita pakai SummaryCard lagi
            final int totalCredits = courses.fold<int>(
              0,
              (sum, item) => sum + (item['credits'] as int? ?? 0),
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pastikan Nama dan NIM tetap terlihat di header sesuai instruksi
                  ProfileCard(name: student['name'] as String, nim: student['nim'] as String, avatarPath: student['avatar'] as String?),
                  const SizedBox(height: 12),

                  // Summary Cards Row dikembalikan agar UI rapi
                  Row(
                    children: [
                      Expanded(child: SummaryCard(title: 'Total Topik', value: '${courses.length} Course', icon: Icons.book_outlined, color: Colors.deepPurple.shade100)),
                      const SizedBox(width: 12),
                      Expanded(child: SummaryCard(title: 'Total SKS', value: '$totalCredits SKS', icon: Icons.school_outlined, color: Colors.purple.shade100)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  const Text('Daftar Mata Kuliah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // ==========================================
                  // TAHAP 5: GRIDVIEW RESPONSIF
                  // ==========================================
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columnsFor(constraints.maxWidth), // Memanggil fungsi kolom
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 90, // Mencegah grid menjadi kotak persegi raksasa (menjaga tinggi card)
                          ),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index] as Map<String, dynamic>;
                            return CourseItemCard(
                              index: index + 1,
                              title: course['title'] as String,
                              code: course['code'] as String,
                              credits: course['credits'] as int,
                              status: course['status'] as String,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // ==========================================
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// REUSABLE WIDGETS
// -----------------------------------------------------------------------------
class ProfileCard extends StatelessWidget {
  final String name; 
  final String nim; 
  final String? avatarPath;
  const ProfileCard({super.key, required this.name, required this.nim, this.avatarPath});
  
  @override
  Widget build(BuildContext context) {
    return Card(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), color: Theme.of(context).colorScheme.primaryContainer, child: Padding(padding: const EdgeInsets.all(14.0), child: Row(children: [CircleAvatar(radius: 28, backgroundColor: Theme.of(context).colorScheme.primary, backgroundImage: avatarPath != null ? AssetImage(avatarPath!) : null, child: avatarPath == null ? const Icon(Icons.person, size: 32, color: Colors.white) : null), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text('NIM: $nim', style: TextStyle(fontSize: 13, color: Colors.grey.shade800))]))])));
  }
}

class SummaryCard extends StatelessWidget {
  final String title; final String value; final IconData icon; final Color color;
  const SummaryCard({super.key, required this.title, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, size: 28, color: Colors.deepPurple.shade900), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 11, color: Colors.black87)), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))]))]));
  }
}

class CourseItemCard extends StatelessWidget {
  final int index; final String title; final String code; final int credits; final String status;
  const CourseItemCard({super.key, required this.index, required this.title, required this.code, required this.credits, required this.status});
  @override
  Widget build(BuildContext context) {
    // Margin dibuat 0 karena jarak antar card sekarang diatur oleh crossAxisSpacing & mainAxisSpacing di GridView
    return Card(margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Text('$index', style: const TextStyle(fontWeight: FontWeight.bold))), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), subtitle: Padding(padding: const EdgeInsets.only(top: 4.0), child: Text('Kode: $code  •  $credits SKS')), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)), child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade800)))));
  }
}
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
      title: 'Course Explorer - Tahap 8',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// Fungsi load JSON
Future<Map<String, dynamic>> loadStudentData() async {
  await Future.delayed(const Duration(seconds: 1));
  final String jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString);
}

// ==========================================
// TAHAP 8: HALAMAN DAFTAR (LIST)
// ==========================================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil Singkat
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('NIM: ${student['nim']}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Pilih Mata Kuliah:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // Daftar Course yang bisa diklik
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade100,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${course['code']} • ${course['credits']} SKS'),
                            trailing: const Icon(Icons.chevron_right, color: Colors.deepPurple), // Ikon panah
                            
                            // Aksi saat list ditekan
                            onTap: () {
                              // Mengirim data Map 'course' ke DetailPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailPage(
                                    course: course, // <-- MENGIRIM DATA
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// TAHAP 8: HALAMAN DETAIL (MENERIMA DATA)
// ==========================================
class CourseDetailPage extends StatelessWidget {
  // Constructor untuk menerima Map data
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course, // Wajib diisi saat dipanggil
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan Nama dan NIM Mahasiswa di header detail
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200)
              ),
              child: Column(
                children: [
                  const Text('Data Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 4),
                  Text(studentName, style: const TextStyle(fontSize: 16)),
                  Text(studentId, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text('Informasi Mata Kuliah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 8),
            
            // Menampilkan Data yang dikirim dari halaman sebelumnya
            ListTile(
              leading: const Icon(Icons.book, color: Colors.deepPurple),
              title: const Text('Judul / Nama', style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(course['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.deepPurple),
              title: const Text('Kode', style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(course['code'], style: const TextStyle(fontSize: 16, color: Colors.black)),
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Beban SKS', style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text('${course['credits']} SKS', style: const TextStyle(fontSize: 16, color: Colors.black)),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.deepPurple),
              title: const Text('Status Pengambilan', style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(
                course['status'], 
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: course['status'] == 'Selesai' ? Colors.green : Colors.orange
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
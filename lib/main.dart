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
      title: 'Course Explorer - Tahap 4',
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

  // Daftar skill untuk pengujian Wrap
  final List<String> skills = [
    'Figma', 'HTML/CSS', 'Flutter', 'Dart', 'Laravel', 'Wireshark', 'Python'
  ];

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            
            // Variabel totalCredits sudah DIBUANG dari sini agar tidak warning

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCard(name: student['name'] as String, nim: student['nim'] as String, avatarPath: student['avatar'] as String?),
                  const SizedBox(height: 12),

                  // ==========================================
                  // TAHAP 4: EXPANDED (FLEX) DAN WRAP
                  // ==========================================
                  const Text('Pengujian Expanded (Flex 2:1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Panel A (Flex 2)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.deepPurple.shade200, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Panel A (Flex 2)', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('$studentId\n$studentName', style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Panel B (Flex 1)
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.deepPurple.shade100, borderRadius: BorderRadius.circular(8)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Panel B', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('(Flex 1)', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text('Pengujian Wrap (Skill Chips)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  // Menggunakan Wrap agar Chip otomatis turun baris
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: skills.map((skill) {
                      return Chip(
                        label: Text(skill, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.purple.shade50,
                        side: BorderSide(color: Colors.purple.shade200),
                      );
                    }).toList(),
                  ),
                  // ==========================================

                  const SizedBox(height: 16),
                  const Text('Daftar Mata Kuliah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        return CourseItemCard(index: index + 1, title: course['title'] as String, code: course['code'] as String, credits: course['credits'] as int, status: course['status'] as String);
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

// -----------------------------------------------------------------------------
// REUSABLE WIDGETS (Sudah dirapikan formatnya)
// -----------------------------------------------------------------------------
class ProfileCard extends StatelessWidget {
  final String name; 
  final String nim; 
  final String? avatarPath;
  
  const ProfileCard({super.key, required this.name, required this.nim, this.avatarPath});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      color: Theme.of(context).colorScheme.primaryContainer, 
      child: Padding(
        padding: const EdgeInsets.all(14.0), 
        child: Row(
          children: [
            CircleAvatar(
              radius: 28, 
              backgroundColor: Theme.of(context).colorScheme.primary, 
              backgroundImage: avatarPath != null ? AssetImage(avatarPath!) : null, 
              child: avatarPath == null ? const Icon(Icons.person, size: 32, color: Colors.white) : null
            ), 
            const SizedBox(width: 14), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                  const SizedBox(height: 2), 
                  Text('NIM: $nim', style: TextStyle(fontSize: 13, color: Colors.grey.shade800))
                ]
              )
            )
          ]
        )
      )
    );
  }
}

class CourseItemCard extends StatelessWidget {
  final int index; 
  final String title; 
  final String code; 
  final int credits; 
  final String status;
  
  const CourseItemCard({super.key, required this.index, required this.title, required this.code, required this.credits, required this.status});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), 
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer, 
          child: Text('$index', style: const TextStyle(fontWeight: FontWeight.bold))
        ), 
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), 
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0), 
          child: Text('Kode: $code  •  $credits SKS')
        ), 
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), 
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)), 
          child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade800))
        )
      )
    );
  }
}
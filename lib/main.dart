import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pemrograman Seluler - Tahap 14',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// Fungsi asynchronous untuk membaca data dari assets/data/student_data.json
Future<Map<String, dynamic>> loadStudentData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulasi loading delay
  final String jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  final Map<String, dynamic> data = jsonDecode(jsonString);
  return data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Memuat Learning Dashboard...'),
                  ],
                ),
              );
            }

            // 2. Error State
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Gagal memuat data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            // 3. Data Loaded State
            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            // Menghitung Total SKS dari JSON secara dinamis
            final int totalCredits = courses.fold<int>(
              0,
              (sum, item) => sum + (item['credits'] as int? ?? 0),
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reusable Widget 1: Profile Card
                  ProfileCard(
                    name: student['name'] as String,
                    nim: student['nim'] as String,
                    avatarPath: student['avatar'] as String?,
                  ),
                  const SizedBox(height: 16),

                  // Summary Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Topik',
                          value: '${courses.length} Course',
                          icon: Icons.book_outlined,
                          color: Colors.deepPurple.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Total SKS',
                          value: '$totalCredits SKS',
                          icon: Icons.school_outlined,
                          color: Colors.purple.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Daftar Mata Kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // List Mata Kuliah
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        // Reusable Widget 2: Course Item Card
                        return CourseItemCard(
                          index: index + 1,
                          title: course['title'] as String,
                          code: course['code'] as String,
                          credits: course['credits'] as int,
                          status: course['status'] as String,
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

// -----------------------------------------------------------------------------
// REUSABLE WIDGETS
// -----------------------------------------------------------------------------

// Reusable Widget 1: Identity / Profile Card
class ProfileCard extends StatelessWidget {
  final String name;
  final String nim;
  final String? avatarPath;

  const ProfileCard({
    super.key,
    required this.name,
    required this.nim,
    this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage:
                  avatarPath != null ? AssetImage(avatarPath!) : null,
              child: avatarPath == null
                  ? const Icon(Icons.person, size: 36, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: $nim',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget 2: Summary Card
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.deepPurple.shade900),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget 3: Course Item Card dengan Conditional Status
class CourseItemCard extends StatelessWidget {
  final int index;
  final String title;
  final String code;
  final int credits;
  final String status;

  const CourseItemCard({
    super.key,
    required this.index,
    required this.title,
    required this.code,
    required this.credits,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade100;
      case 'Sedang Berjalan':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade900;
      case 'Sedang Berjalan':
        return Colors.orange.shade900;
      default:
        return Colors.grey.shade800;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'Selesai':
        return Icons.check_circle_outline;
      case 'Sedang Berjalan':
        return Icons.timelapse;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$index',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Text('Kode: $code  •  $credits SKS'),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStatusIcon(), size: 14, color: _getStatusTextColor()),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _getStatusTextColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
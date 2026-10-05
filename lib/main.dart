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
      title: 'Course Explorer - Tahap 6',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

            // ==========================================
            // TAHAP 6: SINGLE CHILD SCROLL VIEW & KEYBOARD
            // ==========================================
            
            // CARA MENGUJI ERROR (Tanpa SingleChildScrollView):
            // Ganti "return SingleChildScrollView(" di bawah ini menjadi "return Container("
            // Lalu klik salah satu kotak input di paling bawah untuk memunculkan keyboard.
            // Pasti akan error overflow kuning-hitam di layar bawah!

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identitas untuk screenshot
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '$studentId - $studentName',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ProfileCard(
                    name: student['name'] as String,
                    nim: student['nim'] as String,
                    avatarPath: student['avatar'] as String?,
                  ),
                  const SizedBox(height: 24),

                  const Text('Formulir Lengkap (Scroll ke Bawah)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Deretan TextField (Form) yang memakan banyak ruang vertikal
                  const TextField(
                    decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'NIM', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Fakultas', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Program Studi', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Alamat Tempat Tinggal', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Nomor HP', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Aksi tombol simpan
                        FocusScope.of(context).unfocus(); // Menutup keyboard saat ditekan
                      },
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                  // Ruang tambahan agar bisa discroll lebih jauh saat keyboard aktif
                  const SizedBox(height: 300),
                ],
              ),
            );
            // ==========================================
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
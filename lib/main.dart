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
      title: 'Course Explorer - Tahap 14',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

Future<Map<String, dynamic>> loadStudentData() async {
  await Future.delayed(const Duration(seconds: 1));
  final String jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString);
}

// ==========================================
// TAHAP 14: SNACKBAR, DIALOG, DAN LOADING
// ==========================================
class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _komentarController = TextEditingController();
  
  // State untuk melacak status loading
  bool _isLoading = false;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  // Fungsi untuk memunculkan dialog konfirmasi dan memproses data
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Tutup keyboard
      
      // 1. Tampilkan AlertDialog untuk konfirmasi
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Konfirmasi Pengiriman'),
            content: const Text('Apakah Anda yakin ingin mengirim feedback ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Tutup dialog (Batal)
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(dialogContext); // Tutup dialog
                  
                  // Mulai proses loading
                  setState(() {
                    _isLoading = true;
                  });

                  // 2. Simulasi proses loading ke server selama 2 detik
                  await Future.delayed(const Duration(seconds: 2));

                  if (mounted) {
                    // Hentikan loading
                    setState(() {
                      _isLoading = false;
                      _komentarController.clear(); // Kosongkan form komentar
                    });

                    // 3. Tampilkan SnackBar sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Data berhasil disimpan. Terima kasih, $studentName!'),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text('Ya, Kirim'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.feedback, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Form Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                
                TextFormField(
                  initialValue: studentName,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  initialValue: studentId,
                  decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'NIM wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _komentarController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Komentar Praktikum', border: OutlineInputBorder(), alignLabelWithHint: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Komentar wajib diisi';
                    if (value.length < 5) return 'Komentar minimal 5 karakter';
                    return null;
                  },
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
                    // Nonaktifkan tombol saat sedang loading
                    onPressed: _isLoading ? null : _submitFeedback,
                    // Tampilkan indikator loading atau teks biasa
                    child: _isLoading 
                        ? const SizedBox(
                            width: 24, 
                            height: 24, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text('Kirim Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SHELL NAVIGASI
// ==========================================
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> studentFuture;
  Set<String> favoriteCourseCodes = {};

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (snapshot.hasError) return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));

        final data = snapshot.data!;
        final courses = data['courses'] as List<dynamic>;

        final List<Widget> screens = [
          const FeedbackFormScreen(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daftar Mata Kuliah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final courseCode = course['code'] as String;
                      final isFavorite = favoriteCourseCodes.contains(courseCode);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {},
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade100, child: Text('${index + 1}')),
                            title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('$courseCode • ${course['credits']} SKS'),
                            trailing: IconButton(
                              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                              onPressed: () => setState(() => isFavorite ? favoriteCourseCodes.remove(courseCode) : favoriteCourseCodes.add(courseCode)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 16),
                const Text(studentName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('NIM: $studentId', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 840) {
              return Scaffold(
                appBar: AppBar(title: const Text('Tahap 14 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
                body: screens[currentIndex],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => setState(() => currentIndex = index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Form'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(title: const Text('Tahap 14 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) => setState(() => currentIndex = index),
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Form')),
                      NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                      NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: screens[currentIndex]),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
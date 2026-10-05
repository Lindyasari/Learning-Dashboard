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
      title: 'Course Explorer - Tahap 13',
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
// TAHAP 13: WIDGET FORM FEEDBACK (DENGAN VALIDASI)
// ==========================================
class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  // 1. Membuat GlobalKey untuk mengontrol state dari Form
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk mengambil teks komentar
  final TextEditingController _komentarController = TextEditingController();

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
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
          // 2. Membungkus input dengan Form dan memasang Key
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
                
                // Input Nama (Sudah terisi default)
                TextFormField(
                  initialValue: studentName,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap', 
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Input NIM (Sudah terisi default)
                TextFormField(
                  initialValue: studentId,
                  decoration: const InputDecoration(
                    labelText: 'NIM', 
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'NIM wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Input Komentar (Minimal 5 Karakter)
                TextFormField(
                  controller: _komentarController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Komentar Praktikum', 
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Komentar wajib diisi';
                    } else if (value.length < 5) {
                      // 3. Validasi minimal 5 karakter
                      return 'Komentar minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // 4. Memvalidasi form sebelum menampilkan hasil
                      if (_formKey.currentState!.validate()) {
                        // Menutup keyboard
                        FocusScope.of(context).unfocus();
                        
                        // Menampilkan hasil jika validasi lolos
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Terima kasih $studentName! Feedback terkirim.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('Kirim Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
// SHELL NAVIGASI (MENAMPUNG FORM DI TAB HOME)
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final data = snapshot.data!;
        final courses = data['courses'] as List<dynamic>;

        final List<Widget> screens = [
          const FeedbackFormScreen(), // Index 0: Diganti dengan Form Feedback
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
                              onPressed: () {
                                setState(() {
                                  isFavorite ? favoriteCourseCodes.remove(courseCode) : favoriteCourseCodes.add(courseCode);
                                });
                              },
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
                appBar: AppBar(title: const Text('Tahap 13 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
                body: screens[currentIndex],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => setState(() => currentIndex = index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home / Form'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(title: const Text('Tahap 13 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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
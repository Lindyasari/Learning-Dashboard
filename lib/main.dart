import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- KONSTANTA IDENTITAS MAHASISWA ---
const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(), 
    );
  }
}

// Fungsi Load Data JSON
Future<Map<String, dynamic>> loadStudentData() async {
  await Future.delayed(const Duration(seconds: 1)); 
  final String jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString);
}

// ==========================================
// 1. RESPONSIVE SHELL (PENGENDALI NAVIGASI UTAMA)
// ==========================================
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> _studentFuture;
  
  // Variabel sudah ditambahkan 'final' agar bersih dari warning biru
  final Set<String> _favoriteCourseCodes = {};

  @override
  void initState() {
    super.initState();
    _studentFuture = loadStudentData();
  }

  void _toggleFavorite(String code) {
    setState(() {
      if (_favoriteCourseCodes.contains(code)) {
        _favoriteCourseCodes.remove(code);
      } else {
        _favoriteCourseCodes.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Gagal memuat data: ${snapshot.error}')));
        }

        final data = snapshot.data!;
        final courses = data['courses'] as List<dynamic>;

        // Daftar Halaman (Tabs)
        final List<Widget> pages = [
          HomePage(studentData: data['student'], coursesCount: courses.length),
          CoursesPage(courses: courses, favorites: _favoriteCourseCodes, onToggleFavorite: _toggleFavorite),
          const ProfilePage(),
        ];

        // Adaptive Layout Logic
        return LayoutBuilder(
          builder: (context, constraints) {
            // COMPACT / MEDIUM LAYOUT (< 840px)
            if (constraints.maxWidth < 840) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Course Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: pages[_currentIndex],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) => setState(() => _currentIndex = index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              );
            }

            // EXPANDED LAYOUT (>= 840px)
            return Scaffold(
              appBar: AppBar(
                title: const Text('Course Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (index) => setState(() => _currentIndex = index),
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                      NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: pages[_currentIndex]),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// 2. HALAMAN HOME
// ==========================================
class HomePage extends StatelessWidget {
  final dynamic studentData;
  final int coursesCount;

  const HomePage({super.key, required this.studentData, required this.coursesCount});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat Datang,', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(studentName, style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700)),
          const SizedBox(height: 24),
          ProfileSummaryCard(studentId: studentId, studentName: studentName),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoBox(context, 'Total Topik', '$coursesCount Courses', Icons.library_books)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoBox(context, 'Status', 'Aktif', Icons.check_circle_outline)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ==========================================
// 3. HALAMAN COURSES (LIST/GRID OTOMATIS)
// ==========================================
class CoursesPage extends StatelessWidget {
  final List<dynamic> courses;
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const CoursesPage({super.key, required this.courses, required this.favorites, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Katalog Mata Kuliah', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) => _buildCourseItem(context, courses[index], index),
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
                itemCount: courses.length,
                itemBuilder: (context, index) => _buildCourseItem(context, courses[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, dynamic courseData, int index) {
    final course = courseData as Map<String, dynamic>;
    final isFav = favorites.contains(course['code']);

    return CourseCard(
      index: index + 1,
      course: course,
      isFavorite: isFav,
      onFavoriteTap: () => onToggleFavorite(course['code']),
    );
  }
}

// ==========================================
// 4. HALAMAN DETAIL (MENERIMA DATA)
// ==========================================
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['code']), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['title'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(leading: const Icon(Icons.school), title: const Text('Beban Studi'), subtitle: Text('${course['credits']} SKS')),
            ListTile(leading: const Icon(Icons.info), title: const Text('Status'), subtitle: Text(course['status'])),
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

// ==========================================
// 5. HALAMAN PROFILE & FORM FEEDBACK
// ==========================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _komentarController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Kirim feedback ini ke server?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 2)); 
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _komentarController.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback berhasil dikirim!'), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text('Ya, Kirim'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 40, color: Colors.white)),
          const SizedBox(height: 16),
          const Text(studentName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('NIM: $studentId', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 32),
          
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kirim Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _komentarController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Tulis Komentar (Min. 5 karakter)', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Wajib diisi';
                        if (value.length < 5) return 'Minimal 5 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                        child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// REUSABLE WIDGETS
// ==========================================

class ProfileSummaryCard extends StatelessWidget {
  final String studentId;
  final String studentName;
  const ProfileSummaryCard({super.key, required this.studentId, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade800]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 50, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kartu Mahasiswa', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(studentName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(studentId, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const CourseCard({super.key, required this.index, required this.course, required this.isFavorite, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)));
        },
        child: Center(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade100, child: Text('$index')),
            title: Text(course['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${course['code']} • ${course['credits']} SKS'),
            trailing: IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
              onPressed: onFavoriteTap,
            ),
          ),
        ),
      ),
    );
  }
}
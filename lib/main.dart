import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'course_provider.dart';
import 'models/course.dart'; 
import 'services/course_service.dart'; // TAHAP 9: Import Service

const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: const CourseExplorerApp(),
    ),
  );
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

// ==========================================
// 1. RESPONSIVE SHELL
// ==========================================
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;
  
  // TAHAP 9: Future sekarang langsung mengambil List<Course> dari Service
  late Future<List<Course>> _courseFuture;
  
  @override
  void initState() {
    super.initState();
    // TAHAP 9: Menggunakan CourseService untuk load data
    _courseFuture = CourseService().loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    // TAHAP 9: FutureBuilder diubah menyesuaikan tipe kembalian service
    return FutureBuilder<List<Course>>(
      future: _courseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Gagal memuat data: ${snapshot.error}')));
        }

        // Snapshot langsung berupa List<Course> karena sudah diolah oleh Service
        final courses = snapshot.data!;

        final List<Widget> pages = [
          HomePage(coursesCount: courses.length),
          CoursesPage(courses: courses), 
          const ProfilePage(), 
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
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
      }
    );
  }
}

// ==========================================
// 2. HALAMAN HOME
// ==========================================
class HomePage extends StatelessWidget {
  final int coursesCount;

  const HomePage({super.key, required this.coursesCount});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat Datang,', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(studentName, style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700)),
          const SizedBox(height: 24),
          const ProfileSummaryCard(studentId: studentId, studentName: studentName),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoBox(context, 'Total Topik', '$coursesCount Courses', Icons.library_books)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoBox(context, 'Total Favorit', '$favoriteCount Disukai', Icons.favorite)),
            ],
          ),
          const SizedBox(height: 24),
          const LocalStateCard(),
          const SizedBox(height: 16),
          const ValueNotifierCard(),
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
// 3. HALAMAN COURSES
// ==========================================
class CoursesPage extends StatelessWidget {
  final List<Course> courses;
  const CoursesPage({super.key, required this.courses}); 

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

  Widget _buildCourseItem(BuildContext context, Course course, int index) {
    return CourseCard(
      index: index + 1,
      course: course,
    );
  }
}

// ==========================================
// 4. HALAMAN DETAIL
// ==========================================
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.code), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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

// ==========================================
// 5. HALAMAN PROFILE
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
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _komentarController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback berhasil dikirim!'), backgroundColor: Colors.green),
          );
        }
      });
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
                      validator: (value) => (value == null || value.trim().isEmpty) ? 'Wajib diisi' : (value.length < 5 ? 'Minimal 5 karakter' : null),
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
  final Course course;

  const CourseCard({super.key, required this.index, required this.course});

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
            title: Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${course.code} | ${course.credits} SKS'),
            trailing: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFavorite = provider.favorites.contains(course.code);
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                  onPressed: () {
                    context.read<CourseProvider>().toggleFavorite(course.code);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocalStateCard extends StatefulWidget {
  const LocalStateCard({super.key});

  @override
  State<LocalStateCard> createState() => _LocalStateCardState();
}

class _LocalStateCardState extends State<LocalStateCard> {
  bool isFavorite = false; 

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.deepPurple),
        title: const Text('Materi Provider'),
        subtitle: const Text('Belajar Local vs Shared State'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ),
    );
  }
}

class ValueNotifierCard extends StatefulWidget {
  const ValueNotifierCard({super.key});

  @override
  State<ValueNotifierCard> createState() => _ValueNotifierCardState();
}

class _ValueNotifierCardState extends State<ValueNotifierCard> {
  final ValueNotifier<int> _favoriteCount = ValueNotifier<int>(0);

  @override
  void dispose() {
    _favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.numbers, color: Colors.deepPurple),
        title: const Text('Tahap 4: ValueNotifier'),
        subtitle: ValueListenableBuilder<int>(
          valueListenable: _favoriteCount,
          builder: (context, value, child) {
            return Text('Jumlah di-klik: $value kali');
          },
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _favoriteCount.value++; 
          },
          child: const Text('Klik Saya'),
        ),
      ),
    );
  }
}
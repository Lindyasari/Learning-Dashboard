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
      title: 'Course Explorer - Tahap 11',
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
// TAHAP 11: ADAPTIVE NAVIGATION (RAIL & BAR)
// ==========================================
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> studentFuture;

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

        // Kumpulan halaman
        final List<Widget> screens = [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text('Selamat Datang di Home', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('$studentId - $studentName', style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
              ],
            ),
          ),
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
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${course['code']} • ${course['credits']} SKS'),
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
                const CircleAvatar(
                  radius: 50, 
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(studentName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('NIM: $studentId', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ];

        // MENGGUNAKAN LAYOUTBUILDER UNTUK RESPONSIVITAS
        return LayoutBuilder(
          builder: (context, constraints) {
            // JIKA LAYAR SEMPIT (< 840), GUNAKAN BOTTOM NAVIGATION BAR
            if (constraints.maxWidth < 840) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Tahap 11 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                body: screens[currentIndex],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => setState(() => currentIndex = index),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              );
            }

            // JIKA LAYAR LEBAR (>= 840), GUNAKAN NAVIGATION RAIL (SAMPING)
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tahap 11 - $studentName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) => setState(() => currentIndex = index),
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                      NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // Layar konten menggunakan Expanded agar mengisi sisa ruang
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
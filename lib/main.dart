import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TopicListDashboard(),
    );
  }
}

class TopicListDashboard extends StatefulWidget {
  const TopicListDashboard({super.key});

  @override
  State<TopicListDashboard> createState() => _TopicListDashboardState();
}

class _TopicListDashboardState extends State<TopicListDashboard> {
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Git & GitHub',
      'subtitle': 'Version control',
      'done': true,
    },
    {
      'title': 'Dart Fundamentals',
      'subtitle': 'Language basics',
      'done': true,
    },
    {
      'title': 'Flutter UI Fundamentals',
      'subtitle': 'Widgets & layout',
      'done': false,
    },
    {
      'title': '$studentId - $studentName',
      'subtitle': 'Prodi Pendidikan Teknik Informatika',
      'done': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 3. Hitung jumlah item selesai menggunakan where().length sesuai worksheet
    final int completed = topics.where((item) => item['done'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      body: Column(
        children: [
          // Header Profil & Statistik
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Card Profil
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          studentName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          studentId,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school, size: 16, color: Colors.blue),
                            SizedBox(width: 6),
                            Text(
                              'Prodi Pendidikan Teknik Informatika',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Reusable Stat Cards
                Row(
                  children: [
                    _buildStatCard('8', 'Widget', Icons.widgets),
                    const SizedBox(width: 8),
                    _buildStatCard('4', 'Layout', Icons.view_quilt),
                    const SizedBox(width: 8),
                    _buildStatCard('1', 'State', Icons.sync),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 4. Tampilkan teks ringkasan di atas list: "x dari y topik selesai"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Topik Pembelajaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '$completed dari ${topics.length} topik selesai',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // 1. Menggunakan ListView.separated
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: topics.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = topics[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    // 2. Tampilkan status Selesai/Belum menggunakan warna dan icon yang berbeda
                    leading: Icon(
                      item['done'] == true ? Icons.check_circle : Icons.schedule,
                      color: item['done'] == true ? Colors.green : Colors.orange,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                    trailing: Text(
                      item['done'] == true ? 'Selesai' : 'Belum',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item['done'] == true ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Stat Card
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
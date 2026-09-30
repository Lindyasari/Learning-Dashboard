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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TopicListDashboard(),
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

          // Judul Seksi Daftar Topik
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Topik Pembelajaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ),

          // ListView.builder dibungkus Expanded
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemBuilder: (context, index) {
                final item = topics[index];
                final bool isDone = item['done'] == true;

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isDone ? Icons.check_circle : Icons.circle_outlined,
                      color: isDone ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration:
                            isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.black87 : Colors.black,
                      ),
                    ),
                    subtitle: Text(item['subtitle'] as String),
                    trailing: Icon(
                      isDone ? Icons.done : Icons.pending,
                      size: 18,
                      color: isDone ? Colors.green : Colors.orange,
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
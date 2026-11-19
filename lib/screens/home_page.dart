import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../services/profile_service.dart';
import '../widgets/course_widgets.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final int coursesCount;
  const HomePage({super.key, required this.coursesCount});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selamat Datang,',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            studentName,
            style: TextStyle(fontSize: 18, color: Colors.deepPurple.shade700),
          ),
          const SizedBox(height: 16),

          // Kartu Informasi Akun & Role (Praktik 3)
          FutureBuilder<UserProfile?>(
            future: _profileFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              if (snap.hasError || snap.data == null) {
                return const Card(
                  child: ListTile(
                    leading: Icon(Icons.error_outline, color: Colors.red),
                    title: Text('Gagal memuat profil pengguna'),
                  ),
                );
              }
              final p = snap.data!;
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Nama'),
                      subtitle: Text(p.name.isEmpty ? '-' : p.name),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(p.email),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Role'),
                      subtitle: Text(p.role),
                      trailing: Chip(
                        label: Text(
                          p.role.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          const ProfileSummaryCard(studentId: studentId, studentName: studentName),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Total Topik',
                  '${widget.coursesCount} Courses',
                  Icons.library_books,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Total Favorit',
                  '$favoriteCount Disukai',
                  Icons.favorite,
                ),
              ),
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

  Widget _buildInfoBox(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
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
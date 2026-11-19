import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../services/notification_service.dart'; // <-- TAMBAHKAN INI
import '../services/profile_service.dart';
import '../widgets/course_widgets.dart';
import '../widgets/role_guard.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final int coursesCount;
  final UserProfile? profile;

  const HomePage({
    super.key,
    required this.coursesCount,
    this.profile,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Meminta izin notifikasi saat HomePage dibuka
    NotificationService.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;
    final p = widget.profile;
    final role = p?.role ?? 'seeker';

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

          // Kartu Informasi Akun & Role
          if (p == null)
            const Card(
              child: ListTile(
                leading: Icon(Icons.error_outline, color: Colors.red),
                title: Text('Gagal memuat profil pengguna'),
              ),
            )
          else
            Card(
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
            ),

          const SizedBox(height: 16),

          // Menu Berdasarkan Hak Akses (Praktik 4)
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Daftar Course'),
                  subtitle: Text('Tersedia untuk semua pengguna'),
                ),
                RoleGuard(
                  role: role,
                  allowed: const ['owner', 'admin'],
                  child: const Column(
                    children: [
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.library_books),
                        title: Text('My Courses'),
                        subtitle: Text('Tambah, edit, dan hapus course'),
                      ),
                    ],
                  ),
                ),
                RoleGuard(
                  role: role,
                  allowed: const ['admin'],
                  child: const Column(
                    children: [
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.admin_panel_settings),
                        title: Text('Kelola Data (Admin)'),
                        subtitle: Text('Hak akses penuh administrator'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          const SizedBox(height: 72), // ruang agar tidak tertutup FAB
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'add_course_page.dart';
import 'courses_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});
  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout(); // Session Removed
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snap.data;
        final role = profile?.role ?? 'seeker';

        return Consumer<CourseProvider>(
          builder: (context, provider, child) {
            final courses = provider.courses;
            final List<Widget> pages = [
              HomePage(coursesCount: courses.length, profile: profile),
              CoursesPage(userRole: role),
              const FavoritesPage(),
              const ProfilePage(),
            ];

            final logoutAction = IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            );

            // Tombol Tambah Course hanya tampil untuk owner & admin
            final addCourseFab = RoleGuard(
              role: role,
              allowed: const ['owner', 'admin'],
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCoursePage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Course'),
              ),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 840) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Course Explorer ($role)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      centerTitle: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      actions: [logoutAction],
                    ),
                    body: pages[_currentIndex],
                    floatingActionButton: addCourseFab,
                    bottomNavigationBar: NavigationBar(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) =>
                          setState(() => _currentIndex = index),
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.school_outlined),
                          selectedIcon: Icon(Icons.school),
                          label: 'Courses',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.favorite_outline),
                          selectedIcon: Icon(Icons.favorite),
                          label: 'Favorites',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outlined),
                          selectedIcon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  );
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Course Explorer ($role)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    actions: [logoutAction],
                  ),
                  floatingActionButton: addCourseFab,
                  body: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (index) =>
                            setState(() => _currentIndex = index),
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.school_outlined),
                            selectedIcon: Icon(Icons.school),
                            label: Text('Courses'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite_outline),
                            selectedIcon: Icon(Icons.favorite),
                            label: Text('Favorites'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.person_outlined),
                            selectedIcon: Icon(Icons.person),
                            label: Text('Profile'),
                          ),
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
      },
    );
  }
}
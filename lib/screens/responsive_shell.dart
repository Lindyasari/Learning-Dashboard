import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'home_page.dart';
import 'courses_page.dart';
import 'profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});
  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (provider.error != null) return Scaffold(body: Center(child: Text('Gagal memuat data: ${provider.error}')));

        final courses = provider.courses;
        final List<Widget> pages = [
          HomePage(coursesCount: courses.length),
          CoursesPage(courses: courses), 
          const ProfilePage(), 
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 840) {
              return Scaffold(
                appBar: AppBar(title: const Text('Course Explorer', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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
              appBar: AppBar(title: const Text('Course Explorer', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
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
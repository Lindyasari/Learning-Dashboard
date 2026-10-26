import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/course_api_service.dart'; // 1. Ubah import ini
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/responsive_shell.dart';

void main() {
  final service = CourseApiService('https://course-api-pearl.vercel.app');
  final repository = CourseRepository(service);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(repository)..loadCourses(),
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
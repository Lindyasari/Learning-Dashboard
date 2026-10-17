import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/responsive_shell.dart';

void main() {
  final service = CourseService();
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
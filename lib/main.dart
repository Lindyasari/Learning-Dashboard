import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // <-- TAMBAHAN PRAKTIK 10
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_keys.dart';
import 'firebase_options.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/login_page.dart';
import 'screens/responsive_shell.dart';
import 'services/auth_service.dart';
import 'services/course_supabase_service.dart';
import 'services/notification_service.dart'; // <-- TAMBAHAN PRAKTIK 10

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  ); // <-- TAMBAHAN PRAKTIK 10

  // Inisialisasi izin notifikasi, FCM token, dan listener foreground
  await NotificationService.instance.init();

  await Supabase.initialize(
    url: 'https://uoyixnszxovttndyodyf.supabase.co',
    publishableKey: 'sb_publishable_FOJnVixg06R12U_6LjZlTw_adatZlQH',
  );

  // Mendengarkan perubahan session (misalnya saat logout atau session habis)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint('Auth event: ${data.event}');

    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  final service = CourseSupabaseService();
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
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      home: AuthService.instance.isLoggedIn
          ? const ResponsiveShell() // Session Exists -> Home
          : const LoginPage(), // No Session -> Login
    );
  }
}
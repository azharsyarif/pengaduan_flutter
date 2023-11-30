import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard/home_screen.dart';
import 'package:flutter_application_1/screens/dashboard/profile_screen.dart';
import 'package:flutter_application_1/screens/form/create_complaint_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaduan Masyarakat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/pengaduan': (context) => CreateComplaintScreen(),
        // Menambahkan route untuk CreateComplaintScreen
        '/profile': (context) => const UserProfileScreen(),
      },
    );
  }
}

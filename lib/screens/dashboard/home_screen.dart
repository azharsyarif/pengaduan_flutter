import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard/profile_screen.dart';
// import 'package:flutter_application_1/screens/dashboard/profile_screen.dart';
import 'package:flutter_application_1/screens/form/create_complaint_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      initialRoute: '/', // Tentukan route awal
      routes: {
        '/': (context) => const HomeScreen(), // Route untuk HomeScreen
        '/login': (context) => const LoginScreen(), // Route untuk LoginScreen
        // Ganti userId dengan ID pengguna yang sesuai
        '/pengaduan': (context) =>
            CreateComplaintScreen(), // Route untuk CreateComplaintScreen
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId'); // Remove userId from SharedPreferences

    // Navigate to the login page after logout
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('UserId not found'); // Handle when userId is not found
        } else {
          int userId = snapshot.data!; // Get the userId from SharedPreferences
          return Scaffold(
            appBar: AppBar(
              title: const Text('Your App Title'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pengaduan');
                    },
                    child: const Text('Tambah Pengaduan'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/profile',
                        arguments: {
                          'userId':
                              userId, // Pastikan userId sudah terisi dengan nilai yang benar
                        },
                      );
                    },
                    child: const Text('Profil Pengguna'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _logout(
                          context); // Panggil fungsi logout saat tombol logout ditekan
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class ViewComplaintsScreen extends StatelessWidget {
  const ViewComplaintsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Pengaduan Saya'),
      ),
      body: const Center(
        child: Text('Daftar pengaduan yang dibuat oleh pengguna ini'),
      ),
    );
  }
}

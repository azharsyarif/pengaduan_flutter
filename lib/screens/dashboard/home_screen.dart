import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard/profile_screen.dart';
// import 'package:flutter_application_1/screens/dashboard/profile_screen.dart';
import 'package:flutter_application_1/screens/form/create_complaint_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('UserId not found'); // Handle when userId is not found
        } else {
          int userId = snapshot.data!; // Get the userId from SharedPreferences
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pengaduan Masyarakat'),
            ),
            body: Center( // Atau ganti dengan mainAxisAlignment: MainAxisAlignment.center pada Column
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Ubah menjadi MainAxisAlignment.center jika tidak menggunakan Center di atas
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/pengaduan');
                        },
                        child: const Text('Tambah Pengaduan'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/viewComplaint', // Gunakan nama rute untuk ViewComplaintScreen
                          );
                        },
                        child: const Text('Lihat Pengaduan'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _logout(context); // Call logout function when logout button is pressed
                        },
                        child: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
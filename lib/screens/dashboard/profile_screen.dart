import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/network/api_service.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int userId = args['userId'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: FutureBuilder(
        future: APIService().getUserProfile(userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data not found'));
          } else {
            final userProfile = snapshot.data;
            return UserProfileWidget(
              name: userProfile['name'],
              email: userProfile['email'],
              bio: userProfile['bio'],
            );
          }
        },
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String bio;

  const UserProfileWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nama: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Bio: $bio',
              style: TextStyle(fontSize: 16),
            ),
            // Tambahkan elemen lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}

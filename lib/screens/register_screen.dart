import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import untuk json.decode

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _register() async {
    const apiUrl = 'http://127.0.0.1:8000/api/register';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'nik': _nikController.text,
        'nama': _nameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'telp': _phoneController.text,
      },
    );

    if (response.statusCode == 200) {
      // Registrasi berhasil, ambil data yang diperlukan dari respons
      final responseData = json.decode(response.body);
      final registeredUsername = responseData['username'];
      final registeredUserId = responseData['user_id'];

      // Simpan data di SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', registeredUsername);
      prefs.setInt('user_id', registeredUserId);

      // Redirect ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Registrasi gagal, tangani kesalahan
      print('Registrasi gagal: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi gagal. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _nikController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'NIK',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _register,
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

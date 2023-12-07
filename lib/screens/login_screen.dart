import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/api_service.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class APIService {
  Future<http.Response> login(String username, String password) async {
    final Uri loginUri = Uri.parse('http://127.0.0.1:8000/api/login');
    // Ganti URL dengan endpoint login dari API Anda

    final response = await http.post(
      loginUri,
      body: {
        'username': username,
        'password': password,
      },
    );

    return response;
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username and password cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

     try {
      final response = await APIService().login(username, password);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final userId = responseData['user']['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setInt('userId', userId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      }
      // ... kode lainnya
    } catch (error) {
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _isLoading ? null : _login,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: _goToRegister,
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

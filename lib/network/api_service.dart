import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final apiUrl = '$baseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final apiUrl = '$baseUrl/masyarakat/id/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}

  // Future<Map<String, dynamic>> getUserById(int userId) async {
  //   try {
  //     final userProfile = await getUserProfile(userId);
  //     if (userProfile != null) {
  //       return userProfile;
  //     } else {
  //       throw Exception('User profile not found');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to get user by ID: $e');
  //   }
  // }


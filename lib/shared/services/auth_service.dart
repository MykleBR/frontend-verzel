import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static String? authToken;
  static String? csrfToken;
  static const String baseUrl = 'http://10.0.2.2:8000'; // Seu endereço backend

  static Future<bool> authenticate(String username, String password) async {
    final Uri loginUrl = Uri.parse('$baseUrl/login/');

    try {
      final response = await http.post(
        loginUrl,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('access')) {
        }

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  
}

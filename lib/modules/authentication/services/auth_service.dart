import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Seu endereço backend
  static String? authToken;
  static String? csrfToken;

  static Future<bool> login(String username, String password) async {
    final Uri loginUrl = Uri.parse('$baseUrl/login/');
    final Map<String, String> data = {
      'username': username,
      'password': password
    };

    try {
      final response = await http.post(loginUrl, body: data);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('access')) {
          String authToken = responseData['access'];
          setAccessToken(authToken);
          bool csrfSuccess = await loginCrsf();
          return csrfSuccess;
        }
        return false; // Retorna falso para indicar um login mal-sucedido
      } else {
        return false; // Retorna falso para indicar um login mal-sucedido
      }
    } catch (error) {
      return false; // Retorna falso para indicar um login mal-sucedido
    }
  }

  static Future<bool> loginCrsf() async {
    final Uri csrfUrl = Uri.parse(
        '$baseUrl/login/'); // Defina a URL correta para obter o csrfToken

    try {
      final response = await http.get(csrfUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('csrf_token')) {
          String csrfToken = responseData['csrf_token'];
          setCsrfToken(csrfToken);
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> signUp(String username, String password) async {
    final Uri signUpUrl = Uri.parse('$baseUrl/signup/');
    final Map<String, String> data = {
      'username': username,
      'password': password
    };

    try {
      final response = await http.post(signUpUrl, body: data);

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static String? getAccessToken() {
    return authToken;
  }

  static String? getCsrfToken() {
    return csrfToken;
  }

  static void setAccessToken(String? accessToken) {
    authToken = accessToken;
  }

  static void setCsrfToken(String? tokenCsrf) {
    csrfToken = tokenCsrf;
  }
}

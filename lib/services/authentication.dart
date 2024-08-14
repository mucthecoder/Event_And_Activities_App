import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      "http://localhost:3000/api/auth"; // Update this with your actual API base URL

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response;
  }

  Future<http.Response> signup(
      String fullname, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
        'role': role
      }),
    );
    return response;
  }

  Future<http.Response> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
    );
    return response;
  }

  Future<http.Response> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  Future<http.Response> resetPassword(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password/$token'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<http.Response> setNewPassword(
      String userId, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/set-new-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'newPassword': newPassword}),
    );
    return response;
  }
}

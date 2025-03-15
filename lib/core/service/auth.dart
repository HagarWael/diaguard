import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final storage = FlutterSecureStorage();

  Future<String> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print("Login response status code: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['response']['token'];
        if (token == null) {
          throw Exception('Token is null in the response');
        }
        await storeToken(token);
        return 'successful';
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print("Error in login: $e");
      throw Exception('An error occurred during login: $e');
    }
  }

  Future<String> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': fullName,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print(
        "Signup response status code: ${response.statusCode}",
      ); // Debug print
      print("Signup response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['response']['token'];
        if (token == null) {
          throw Exception('Token is null in the response');
        }
        await storeToken(token);
        return 'successful';
      } else {
        throw Exception('Failed to sign up: ${response.body}');
      }
    } catch (e) {
      print("Error in signup: $e");
      throw Exception('An error occurred during signup: $e');
    }
  }

  Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}

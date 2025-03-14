import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final storage = FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await storeToken(token);
      return 'successful';
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> signup(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'fullName': fullName,
      }),
    );
    print(response.statusCode);
    //   if (response.statusCode == 200) {
    //     final token = jsonDecode(response.body)['token'];

    //   } else {
    //     throw Exception('Failed to sign up');
    //   }
    // }
    if (response.statusCode == 200) {
      return 'successful';
    } else {
      throw Exception('Failed to sign up');
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

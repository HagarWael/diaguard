import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
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
        }),
      );

      print("Login response status code: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['response']['token'];
        final user = responseBody['response']['user'];

        if (token == null || user == null) {
          throw Exception('Token or user is null in the response');
        }

        await storeToken(token);
        return {
          'status': 'successful',
          'token': token,
          'user': {
            'email': user['email'],
            'role': user['role'],
            'fullname': user['fullname'],
          },
        };
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print("Error in login: $e");
      throw Exception('An error occurred during login: $e');
    }
  }

  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? doctorCode,
    String? emergencyName,
    String? emergencyPhone,
    String? emergencyRelationship,
  }) async {
    try {
      if (role == 'patient') {
        if (doctorCode == null || doctorCode.isEmpty) {
          throw Exception('Doctor code is required for patient registration');
        }

        if (emergencyName == null ||
            emergencyName.isEmpty ||
            emergencyPhone == null ||
            emergencyPhone.isEmpty) {
          throw Exception(
            'Emergency contact name and phone are required for patient registration',
          );
        }
      }

      final Map<String, dynamic> body = {
        'fullname': fullName,
        'email': email,
        'password': password,
        'role': role,
      };

      if (role == 'patient') {
        body['Code'] = doctorCode!;
        body['emergencyContact'] = {
          'name': emergencyName,
          'phone': emergencyPhone,
          'relationship': emergencyRelationship ?? 'Family Member',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      print("Signup response status code: ${response.statusCode}");
      print("Signup response body: ${response.body}");

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final responseData = responseBody['response'];
        final token = responseData['token'];
        final user = responseData['user'];

        if (token == null || user == null) {
          throw Exception('Token or user is null in the response');
        }

        await storeToken(token);
        return {
          'status': 'successful',
          'token': token,
          'user': {
            'email': user['email'],
            'role': user['role'],
            'fullname': user['fullname'],
          },
        };
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

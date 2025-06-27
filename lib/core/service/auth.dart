import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000';
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role
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
          'role': role
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
      } else if (response.statusCode == 500) {
        // Handle 500 error specifically for wrong credentials
        return {
          'status': 'failed',
          'message': 'Wrong credentials. Please check your email and password.',
        };
      } else {
        // For other error status codes, try to parse the error message from response
        try {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? 'Failed to login';
          return {
            'status': 'failed',
            'message': errorMessage,
          };
        } catch (parseError) {
          return {
            'status': 'failed',
            'message': 'Failed to login. Please try again.',
          };
        }
      }
    } catch (e) {
      print("Error in login: $e");
      // For network errors or other exceptions, return a generic message
      return {
        'status': 'failed',
        'message': 'Network error. Please check your connection and try again.',
      };
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
    List<Map<String, String>>? questions,
  }) async {
    try {
      if (role == 'patient') {
        if (doctorCode == null || doctorCode.isEmpty) {
          return {
            'status': 'failed',
            'message': 'Doctor code is required for patient registration',
          };
        }

        if (emergencyName == null ||
            emergencyName.isEmpty ||
            emergencyPhone == null ||
            emergencyPhone.isEmpty) {
          return {
            'status': 'failed',
            'message': 'Emergency contact name and phone are required for patient registration',
          };
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
        if (questions != null) {
          body['questions'] = questions;
        }
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
        print('Parsed responseBody: ' + responseBody.toString());
        final responseData = responseBody['response'];
        final token = responseData['token'];
        final user = responseData['user'];

        if (token == null || user == null) {
          return {
            'status': 'failed',
            'message': 'Invalid response from server. Please try again.',
          };
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
      } else if (response.statusCode == 500) {
        // Handle 500 error specifically
        return {
          'status': 'failed',
          'message': 'Registration failed. Please try again.',
        };
      } else {
        // For other error status codes, try to parse the error message from response
        try {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? 'Failed to sign up';
          return {
            'status': 'failed',
            'message': errorMessage,
          };
        } catch (parseError) {
          return {
            'status': 'failed',
            'message': 'Failed to sign up. Please try again.',
          };
        }
      }
    } catch (e) {
      print("Error in signup: $e");
      // For network errors or other exceptions, return a generic message
      return {
        'status': 'failed',
        'message': 'Network error. Please check your connection and try again.',
      };
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
    try {
      // Get the current token
      final token = await getToken();
      
      if (token != null) {
        // Make logout request to backend with token
        final response = await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        print("Logout response status code: ${response.statusCode}");
        print("Logout response body: ${response.body}");

        // Even if the backend request fails, we still want to clear the local token
        // This ensures the user is logged out locally regardless of backend response
      }
    } catch (e) {
      print("Error during logout request: $e");
      // Continue with local logout even if backend request fails
    } finally {
      // Always delete the token from local storage
      await storage.delete(key: 'jwt_token');
    }
  }

  Future<String?> getDoctorId() async {
  try {
    final token = await getToken();
    if (token == null) return null;
    
    final decoded = JwtDecoder.decode(token);
    final role = decoded['role']?.toString();
    
    // If the user is a doctor, return their own ID from the token
    if (role == 'doctor') {
      return decoded['userId']?.toString();
    }
    
    // If the user is a patient, fetch their doctor ID from the backend
    if (role == 'patient') {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/users/doctor-id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody['success'] == true) {
            return responseBody['data']['doctorId']?.toString();
          }
        }
      } catch (e) {
        print("Error fetching doctor ID: $e");
        return null;
      }
    }
    
    return null;
  } catch (e) {
    print("Error in getDoctorId: $e");
    return null;
  }
}
}

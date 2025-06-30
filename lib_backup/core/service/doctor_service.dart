import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class DoctorService {
  final String baseUrl = 'http://localhost:3000'; // Fixed: removed duplicate path
  final AuthService authService;

  DoctorService({required this.authService});

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      // Try this format first (without Bearer)
      'Authorization': '$token'
      
      // If that doesn't work, try:
      // 'Authorization': 'Bearer $token'
      // 'x-auth-token': '$token'
      // 'token': '$token'
    };
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      // Debug: Check token and headers
      final token = await authService.getToken();
      print('Token being sent: $token');
      print('Token length: ${token?.length}');
      
      final headers = await _getHeaders();
      print('Headers being sent: $headers');
      print('Fetching patients from: $baseUrl/doctors/patients');
      
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/patients'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // This will show the server error message

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle different response structures
        if (data is List) {
          // If response is directly an array
          return data.whereType<Map<String, dynamic>>().toList();
        } else if (data is Map && data.containsKey('patients')) {
          // If response has 'patients' key
          final patients = data['patients'];
          if (patients is List) {
            return patients.whereType<Map<String, dynamic>>().toList();
          }
        }
        
        return []; // Fallback
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Detailed error in getPatients: $e');
      print('Error type: ${e.runtimeType}');
      rethrow; // Re-throw to let the UI handle it
    }
  }

  // Temporary method to test without authentication
  Future<void> testWithoutAuth() async {
    try {
      print('Testing without auth...');
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/patients'),
        // No headers - test if endpoint works without auth
      );
      
      print('No-auth response status: ${response.statusCode}');
      print('No-auth response body: ${response.body}');
    } catch (e) {
      print('No-auth error: $e');
    }
  }
}
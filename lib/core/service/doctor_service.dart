import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class DoctorService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final AuthService authService;

  DoctorService({required this.authService});

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {'Content-Type': 'application/json', 'Authorization': '$token'};
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    final response = await http.get(
      Uri.parse('$baseUrl/doctors/patients'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final patients = data['patients'];

      if (patients is List<dynamic>) {
        return patients.whereType<Map<String, dynamic>>().toList();
      }

      return []; // Fallback in case result isn't a list
    } else {
      throw Exception('Failed to load patients');
    }
  }
}

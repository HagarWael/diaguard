import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class DoctorService {
  final String baseUrl = 'http://localhost:3000';
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

  Future<Map<String, dynamic>> getPatientDetails(String patientId) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final response = await http.get(
      Uri.parse('$baseUrl/doctors/patients/$patientId/?startDate=${sevenDaysAgo.toIso8601String()}&endDate=${now.toIso8601String()}'),
      headers: await _getHeaders(),
    );

    print("Patient details response status: "+response.statusCode.toString());
    print("Patient details response body: "+response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['patient'];
    } else {
      throw Exception('Failed to load patient details');
    }
  }

  Future<List<Map<String, dynamic>>> getPatientGlucoseReadings(String patientId) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final response = await http.get(
      Uri.parse('$baseUrl/doctors/patients/$patientId/?startDate=${sevenDaysAgo.toIso8601String()}&endDate=${now.toIso8601String()}'),
      headers: await _getHeaders(),
    );

    print("Glucose readings response status: "+response.statusCode.toString());
    print("Glucose readings response body: "+response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final readings = data['glucoseReadings'] ?? [];
      if (readings is List) {
        return readings.whereType<Map<String, dynamic>>().toList();
      }
      return [];
    } else {
      throw Exception('Failed to load glucose readings');
    }
  }
}

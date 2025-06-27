import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class GlucoseService {
  final String baseUrl = 'http://localhost:3000';
  final AuthService authService;

  GlucoseService({required this.authService});

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {'Content-Type': 'application/json', 'Authorization': '$token'};
  }

  Future<Map<String, dynamic>> saveReading(double value, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/save-reading'),
      headers: await _getHeaders(),
      body: jsonEncode({'value': value, 'type': type}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Save reading error: \\n${response.body}');
      throw Exception('Failed to save reading: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getReadings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/get-readings'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['result'];

      // Handle case where result is a List of Lists
      if (result is List<dynamic>) {
        // Flatten nested lists and filter for Maps
        return result.expand((item) {
          if (item is List<dynamic>) {
            return item.whereType<Map<String, dynamic>>();
          }
          return [if (item is Map<String, dynamic>) item];
        }).toList();
      }

      return []; // Fallback for unexpected formats
    } else {
      throw Exception('Failed to get readings');
    }
  }
}

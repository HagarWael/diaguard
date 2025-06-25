import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class QuestionService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final AuthService authService;

  QuestionService({required this.authService});

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {'Content-Type': 'application/json', 'Authorization': '$token'};
  }

  Future<Map<String, dynamic>> saveAnswers(Map<int, String> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/questions/save-answers'),
      headers: await _getHeaders(),
      body: jsonEncode({'answers': answers}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Save answers error: \n${response.body}');
      throw Exception('Failed to save answers: ${response.body}');
    }
  }

  Future<Map<int, String>> getAnswers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/questions/get-answers'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Convert the JSON response to a Map<int, String>
      final Map<int, String> answers = {};
      if (data['answers'] != null) {
        data['answers'].forEach((key, value) {
          answers[int.parse(key)] = value;
        });
      }
      return answers;
    } else {
      throw Exception('Failed to get answers');
    }
  }
}

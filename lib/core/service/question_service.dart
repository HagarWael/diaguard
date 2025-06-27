import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'package:diaguard1/features/questionnaire/data/question_data.dart';

class QuestionService {
  final String baseUrl = 'http://localhost:3000';
  final AuthService authService;

  QuestionService({required this.authService});

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {'Content-Type': 'application/json', 'Authorization': '$token'};
  }

  Future<Map<String, dynamic>> saveAnswers(Map<int, String> answers) async {
    // Convert answers to a List<Map<String, String>> with questionText and answer
    final answerList = answers.entries.map((entry) => {
      'questionText': questions[entry.key],
      'answer': entry.value,
    }).toList();

    final response = await http.post(
      Uri.parse('$baseUrl/questions/save-answers'),
      headers: await _getHeaders(),
      body: jsonEncode({'answers': answerList}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Save answers error: \n${response.body}');
      throw Exception('Failed to save answers: ${response.body}');
    }
  }

  Future<List<Map<String, String>>> getAnswers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/questions/get-answers'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, String>> answers = [];
      if (data['question'] != null) {
        for (var q in data['question']) {
          answers.add({
            'questionText': q['questionText'],
            'answer': q['answer'],
          });
        }
      }
      return answers;
    } else {
      throw Exception('Failed to get answers');
    }
  }
}

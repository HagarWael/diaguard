import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotService {
  //final String baseUrl = 'http://localhost:5000'; // Use LAN IP if testing on device
  //final url = Uri.parse('http://192.168.1.10:5000/chat');
  final String baseUrl = 'http://172.20.10.2:5000';

  Future<String> askQuestion(String question) async {
    final uri = Uri.parse('$baseUrl/ask');
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'];
      } else {
        return 'Server error';
      }
    } catch (e) {
      return 'Could not reach server';
    }
  }
}

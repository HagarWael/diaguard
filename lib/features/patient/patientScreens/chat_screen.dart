import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/chat_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diaguard1/core/service/auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  const ChatScreen({Key? key, required this.doctorId, required this.doctorName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadOldMessages(); // Wait for old messages to load first
    _chatService.connect();
    _messageSubscription = _chatService.messageStream.listen((data) {
      if (mounted) {
        setState(() {
          final newMsg = data['message'] ?? data;
          if (!_messages.any((msg) => msg['_id'] == newMsg['_id'])) {
            _messages.add(newMsg);
          }
        });
      }
    });
    _chatService.typingStream.listen((data) {
      if (mounted && data['userId'] == widget.doctorId) {
        setState(() {
          _isTyping = data['type'] == 'start';
        });
      }
    });
  }

  Future<void> _loadOldMessages() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        print('No token found');
        setState(() {
          _isLoading = false;
          _errorMessage = 'No authentication token found.';
        });
        return;
      }

      print('Loading messages for doctor: \\${widget.doctorId}');
      print('\\${_authService.baseUrl}/chat/conversations/\\${widget.doctorId}/history');
      final response = await http.get(
        Uri.parse('${_authService.baseUrl}/chat/conversations/${widget.doctorId}/history'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: \\${response.statusCode}');
      print('Response body: \\${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true && responseBody['data'] != null) {
          final messages = responseBody['data']['messages'] ?? [];
          print('Loaded \\${messages.length} messages');
          setState(() {
            _messages.clear();
            _messages.addAll(List<Map<String, dynamic>>.from(messages));
            _isLoading = false;
            _errorMessage = null;
          });
          return;
        } else {
          print('No messages found or response not successful.');
          setState(() {
            _isLoading = false;
            _errorMessage = 'No messages found or response not successful.';
          });
          return;
        }
      } else {
        print('HTTP error: \\${response.statusCode}');
        setState(() {
          _isLoading = false;
          _errorMessage = 'HTTP error: ${response.statusCode}';
        });
        return;
      }
    } catch (e) {
      print('Error loading old messages: \\${e.toString()}');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading messages: $e';
      });
      return;
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _chatService.disconnect();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _chatService.sendMessage(receiverId: widget.doctorId, content: text);
    _controller.clear();
  }

  void _onChanged(String value) {
    if (value.isNotEmpty) {
      _chatService.startTyping(widget.doctorId);
    } else {
      _chatService.stopTyping(widget.doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.doctorName}')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Expanded(
                      child: _messages.isEmpty
                          ? Center(child: Text('لا توجد رسائل بعد'))
                          : FutureBuilder<String?>(
                              future: _authService.getToken().then((token) => token != null ? JwtDecoder.decode(token)['userId'] as String? : null),
                              builder: (context, snapshot) {
                                final currentUserId = snapshot.data;
                                if (currentUserId == null) {
                                  return Center(child: Text('تعذر تحديد المستخدم الحالي'));
                                }
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = _messages[_messages.length - 1 - index];
                                    final senderId = msg['sender'] is Map ? (msg['sender']['_id'] ?? msg['sender']['id']) : msg['sender'];
                                    final isMe = senderId == currentUserId;
                                    return Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isMe ? Colors.teal[100] : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(msg['content'] ?? ''),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    if (_isTyping)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${widget.doctorName} is typing...', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: _onChanged,
                            decoration: const InputDecoration(hintText: 'Type a message...'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
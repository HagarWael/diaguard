import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  IO.Socket? _socket;
  final _storage = FlutterSecureStorage();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _statusController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;
  Stream<Map<String, dynamic>> get statusStream => _statusController.stream;

  Future<void> connect() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return;
    if (_socket != null && _socket!.connected) return;
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });
    _socket!.connect();
    _socket!.on('connect', (_) => print('Connected to chat server'));
    _socket!.on('new_message', (data) => _messageController.add(data));
    _socket!.on('message_sent', (data) => _messageController.add(data));
    _socket!.on('typing_start', (data) => _typingController.add({'type': 'start', ...data}));
    _socket!.on('typing_stopped', (data) => _typingController.add({'type': 'stop', ...data}));
    _socket!.on('messages_read', (data) => _messageController.add({'type': 'read', ...data}));
    _socket!.on('user_status_change', (data) => _statusController.add(data));
    _socket!.on('error', (data) => print('Socket error: ${data['message']}'));
  }

  void sendMessage({
    required String receiverId,
    required String content,
    String messageType = 'text',
    String? fileUrl,
    String? fileName,
  }) {
    _socket?.emit('send_message', {
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'fileName': fileName,
    });
  }

  void startTyping(String receiverId) {
    _socket?.emit('typing_start', {'receiverId': receiverId});
  }

  void stopTyping(String receiverId) {
    _socket?.emit('typing_stop', {'receiverId': receiverId});
  }

  void markRead(String senderId) {
    _socket?.emit('mark_read', {'senderId': senderId});
  }

  void setStatus(String status) {
    _socket?.emit('set_status', {'status': status});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
    _statusController.close();
    disconnect();
  }
} 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:diaguard1/core/service/chat_bot.dart';   

class ChatbotPatientPage extends StatefulWidget {
  @override
  _ChatbotPatientPageState createState() => _ChatbotPatientPageState();
}

class _ChatbotPatientPageState extends State<ChatbotPatientPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final int _currentIndex = 3; // index of the Chatbot tab
  final ChatBotService _chatBot = ChatBotService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final welcomeText = isArabic
          ? " اسألني عن السكر أو الإنسولين أو التغذية 🌱"
          : " Ask me anything about glucose, insulin, or nutrition 🌱";
      final helloHero = isArabic ? "أهلاً بالبطل 👋" : "Hello Hero 👋";
      _addWelcomeMessage("$helloHero $welcomeText");
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Add user bubble
    setState(() =>
        _messages.add(Message(text: userMessage, isUser: true)));

    _controller.clear();

    // Ask backend
    final botReply = await _chatBot.askQuestion(userMessage);

    // Typing animation
    String currentText = "";
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 30), (Timer timer) {
      if (i < botReply.length) {
        currentText += botReply[i];
        if (_messages.isNotEmpty && !_messages.last.isUser) {
          setState(() =>
              _messages[_messages.length - 1] =
                  Message(text: currentText, isUser: false));
        } else {
          setState(() =>
              _messages.add(Message(text: currentText, isUser: false)));
        }
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  void _addWelcomeMessage(String botReply) {
    String currentText = "";
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 30), (Timer timer) {
      if (i < botReply.length) {
        currentText += botReply[i];
        if (_messages.isNotEmpty && !_messages.last.isUser) {
          setState(() =>
              _messages[_messages.length - 1] =
                  Message(text: currentText, isUser: false));
        } else {
          setState(() =>
              _messages.add(Message(text: currentText, isUser: false)));
        }
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/chart_patient');
        break;
      case 2:
        Navigator.pushNamed(context, '/insulin_calc');
        break;
      case 3:
        Navigator.pushNamed(context, '/chatbot_patient');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'مساعد التغذية' : 'Chatbot'),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 270),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.teal[100]
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.text, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('yyyy/MM/dd HH:mm')
                              .format(msg.timestamp),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          isArabic ? 'اكتب الرسالة' : 'Write message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal[700]),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: isArabic ? 'الرئيسية' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.show_chart),
            label: isArabic ? 'مخطط جلوكوز' : 'Graph',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medical_services),
            label: isArabic ? 'الإنسولين' : 'Dose',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: isArabic ? 'مساعد' : 'Chatbot',
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

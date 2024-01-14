import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _chatMessages = [];

  List<String> _developerResponses = [
    "Halo kami dari Developer Resepku!",
    "Tanyakan apa saja seputar resep makanan!",
    "Saya merekomendasikan Ayam Goreng Lengkuas",
    "Lebih lengkapnya bisa cek di menu olahan Ayam",
  ];

  int _currentResponseIndex = 0;

  void _sendMessage(String message) {
    setState(() {
      _chatMessages.add("User: $message");
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _chatMessages.add("Developer: ${_getNextDeveloperResponse()}");
      });
    });
    _messageController.clear();
  }

  String _getNextDeveloperResponse() {
    String response = _developerResponses[_currentResponseIndex];
    _currentResponseIndex =
        (_currentResponseIndex + 1) % _developerResponses.length;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan Developer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(_chatMessages[index]),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

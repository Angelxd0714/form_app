import 'package:flutter/material.dart';
import 'package:form_app/widgets/chat_widget.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      body: const ChatWidget(),
    );
  }
}

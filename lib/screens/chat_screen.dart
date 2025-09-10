import 'package:flutter/material.dart';
import 'package:form_app/services/gemini_service.dart';
import 'package:form_app/widgets/chat_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GeminiService _geminiService;

  @override
  void initState() {
    super.initState();
    // WARNING: This is not a secure way to store API keys.
    // Please use a secure method like a secret manager for production apps.
    const apiKey = String.fromEnvironment('API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('API_KEY environment variable not set.');
    }
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    _geminiService = GeminiServiceImpl(model: model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      body: ChatWidget(geminiService: _geminiService), // Inject the service
    );
  }
}

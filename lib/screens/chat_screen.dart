import 'package:flutter/material.dart';
import 'package:form_app/services/gemini_service.dart';
import 'package:form_app/widgets/chat_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GeminiService _geminiService;
  String? _apiKey;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGeminiService();
  }

  Future<void> _initializeGeminiService() async {
    try {
      await dotenv.load();
      final apiKey = dotenv.env['API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API_KEY environment variable not set.');
      }

      final model = GenerativeModel(model: 'gemini-1.5-pro-latest', apiKey: apiKey);
      _geminiService = GeminiServiceImpl(model: model);

      setState(() {
        _apiKey = apiKey;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Manejar el error adecuadamente
      print('Error initializing Gemini Service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_apiKey == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('API_KEY not configured. Please set the API_KEY environment variable.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      body: ChatWidget(geminiService: _geminiService),
    );
  }
}

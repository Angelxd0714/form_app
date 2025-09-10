import 'package:google_generative_ai/google_generative_ai.dart';

// Abstract class defining the contract for our chat service.
// The UI will depend on this, not on the concrete implementation.
abstract class GeminiService {
  Future<String?> sendMessage(String text);
}

// Concrete implementation that uses the google_generative_ai package.
class GeminiServiceImpl implements GeminiService {
  final ChatSession _chat;

  GeminiServiceImpl({required GenerativeModel model}) : _chat = model.startChat();

  @override
  Future<String?> sendMessage(String text) async {
    final response = await _chat.sendMessage(Content.text(text));
    return response.text;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/services/gemini_service.dart';
import 'package:form_app/widgets/chat_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'chat_widget_test.mocks.dart';

@GenerateMocks([GeminiService])
void main() {
  group('ChatWidget Tests', () {
    late MockGeminiService mockGeminiService;
    setUp(() {
      mockGeminiService = MockGeminiService();
    });
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: ChatWidget(geminiService: mockGeminiService),
        ),
      );
    }
    testWidgets('should send message and receive response', (WidgetTester tester) async {
      const userMessage = 'Hello, Gemini!';
      const geminiResponse = 'Hello there! How can I help you today?';
      when(mockGeminiService.sendMessage(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 10), () => geminiResponse),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), userMessage);
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.text(userMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text(geminiResponse), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(userMessage), findsOneWidget);
    });
    testWidgets('should display error when sending message fails', (WidgetTester tester) async {
      const userMessage = 'This will fail';
      final exception = Exception('API Error');
      when(mockGeminiService.sendMessage(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 10), () => throw exception),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), userMessage);
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed to send message: $exception'), findsOneWidget);
    });
  });
}

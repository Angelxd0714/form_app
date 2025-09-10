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
      // Arrange
      const userMessage = 'Hello, Gemini!';
      const geminiResponse = 'Hello there! How can I help you today?';

      // Configure the mock to return a delayed response, simulating a network call.
      when(mockGeminiService.sendMessage(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 10), () => geminiResponse),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), userMessage);
      await tester.tap(find.byIcon(Icons.send));
      
      // Pump the first frame to show the user message and trigger the loading state.
      await tester.pump(); 

      // Assert: Check that the loading indicator is now visible.
      expect(find.text(userMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump and settle to complete the delayed future and rebuild with the response.
      await tester.pumpAndSettle();

      // Assert: Check for the final state.
      expect(find.text(geminiResponse), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(userMessage), findsOneWidget); 
    });

    testWidgets('should display error when sending message fails', (WidgetTester tester) async {
      // Arrange
      const userMessage = 'This will fail';
      final exception = Exception('API Error');

      // Configure the mock to throw a delayed error.
      when(mockGeminiService.sendMessage(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 10), () => throw exception),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), userMessage);
      await tester.tap(find.byIcon(Icons.send));

      // Pump the first frame to show the user message and trigger the loading state.
      await tester.pump();

      // Assert: Check that the loading indicator is visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump and settle to handle the exception and show the SnackBar.
      await tester.pumpAndSettle();

      // Assert: Check for the final error state.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed to send message: $exception'), findsOneWidget);
    });
  });
}

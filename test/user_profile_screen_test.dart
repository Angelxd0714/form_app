import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/models/user_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/user_profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const String userKey = 'user_data';

  Future<void> pumpUserProfileScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: const MaterialApp(
          home: UserProfileScreen(),
        ),
      ),
    );
  }

  group('UserProfileScreen Widget Tests', () {
    testWidgets('Should display message when no user profile exists', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await pumpUserProfileScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump once to process async operations like loadUser.
      await tester.pump(Duration.zero);
      // Pump again to rebuild the widget tree with the new state.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No hay información de usuario'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Crear Perfil'), findsOneWidget);
    });

    testWidgets('Should display user information when a profile exists', (WidgetTester tester) async {
      final testUser = User(
        id: '1',
        firstName: 'Jane',
        lastName: 'Doe',
        dateOfBirth: DateTime(1995, 8, 28),
        addresses: [],
      );
      final userData = json.encode(testUser.toJson());
      SharedPreferences.setMockInitialValues({userKey: userData});

      await pumpUserProfileScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Pump once to clear the async microtask queue (for SharedPreferences).
      await tester.pump(Duration.zero);
      // Pump again to let the UI rebuild after the data is loaded and setState is called.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No hay información de usuario'), findsNothing);
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text(DateFormat('dd/MM/yyyy').format(testUser.dateOfBirth)), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Añadir nueva'), findsOneWidget);
    });
  });
}

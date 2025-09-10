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
  // Define the key used in the UserProvider
  const String userKey = 'user_data';

  // Helper function to pump the UserProfileScreen with a UserProvider
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
      // Arrange: Set up mock SharedPreferences with no user data
      SharedPreferences.setMockInitialValues({});

      // Act: Pump the initial widget.
      await pumpUserProfileScreen(tester);

      // Assert: Initially, it should show a loading indicator as the initState future is running.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act: Pump the widget again to let the Future in initState complete and the UI to update.
      await tester.pump();

      // Assert: After loading, it should show the 'no user' message and no loading indicator.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No hay información de usuario'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Crear Perfil'), findsOneWidget);
    });

    testWidgets('Should display user information when a profile exists', (WidgetTester tester) async {
      // Arrange: Create a test user and set up mock SharedPreferences.
      final testUser = User(
        id: '1',
        firstName: 'Jane',
        lastName: 'Doe',
        dateOfBirth: DateTime(1995, 8, 28),
        addresses: [],
      );
      final userData = json.encode(testUser.toJson());
      SharedPreferences.setMockInitialValues({userKey: userData});

      // Act: Pump the initial widget.
      await pumpUserProfileScreen(tester);

      // Assert: Initially, a loading indicator should be visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act: Pump the widget again to process the completion of the `loadUser` Future.
      await tester.pump();

      // Assert: After loading, it should display the user's data and no loading indicator.
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

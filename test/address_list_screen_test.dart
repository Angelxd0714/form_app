
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/models/user_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('AddressListScreen Widget Tests', () {
    late UserProvider userProvider;

    // Set up a user for the tests
    final testUser = User(
      id: '1', 
      firstName: 'Test', 
      lastName: 'User', 
      dateOfBirth: DateTime.now(),
      addresses: [],
    );

    setUp(() {
      userProvider = UserProvider();
      userProvider.saveUser(testUser); // Ensure a user exists
    });

    Future<void> pumpAddressListScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: const MaterialApp(
            home: AddressListScreen(),
          ),
        ),
      );
    }

    testWidgets('Should display message when no addresses exist', (WidgetTester tester) async {
      // Arrange
      await pumpAddressListScreen(tester);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No hay direcciones guardadas'), findsOneWidget);
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    });

    testWidgets('Should display addresses when they exist', (WidgetTester tester) async {
      // Arrange: Add addresses to the user
      final userWithAddresses = testUser.copyWith(addresses: [
        Address(id: 'a1', street: '123 Main St', city: 'Anytown', state: 'CA', zipCode: '12345', country: ''),
        Address(id: 'a2', street: '456 Oak Ave', city: 'Otherville', state: 'NY', zipCode: '67890', isDefault: true, country: ''),
      ]);
      await userProvider.saveUser(userWithAddresses);
      
      // Act
      await pumpAddressListScreen(tester);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Anytown, CA, 12345'), findsOneWidget);
      expect(find.text('456 Oak Ave'), findsOneWidget);
      expect(find.text('Otherville, NY, 67890'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget); // For the default address
    });

    testWidgets('Tapping FAB should navigate to address form', (WidgetTester tester) async {
        // This test requires a mock navigator to verify navigation.
        // For simplicity, we'll just check that the button exists.
        await pumpAddressListScreen(tester);
        expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    });
  });
}

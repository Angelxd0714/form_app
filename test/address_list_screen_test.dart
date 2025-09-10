import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/models/user_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const String userKey = 'user_data';

  Widget createWidgetUnderTest(UserProvider provider) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(
        home: AddressListScreen(),
      ),
    );
  }

  group('AddressListScreen Widget Tests', () {
    testWidgets('Should display message when no addresses exist', (WidgetTester tester) async {
      final testUser = User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        dateOfBirth: DateTime.now(),
        addresses: [],
      );
      SharedPreferences.setMockInitialValues({userKey: json.encode(testUser.toJson())});

      final userProvider = UserProvider();
      await userProvider.loadUser();

      await tester.pumpWidget(createWidgetUnderTest(userProvider));
      await tester.pump();

      expect(find.text('No hay direcciones guardadas'), findsOneWidget);
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    });

    testWidgets('Should display addresses when they exist', (WidgetTester tester) async {
      final address1 = Address(id: 'a1', street: '123 Main St', city: 'Anytown', state: 'CA', zipCode: '12345', country: 'USA');
      final address2 = Address(id: 'a2', street: '456 Oak Ave', city: 'Otherville', state: 'NY', zipCode: '67890', country: 'USA', isDefault: true);
      
      final userWithAddresses = User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        dateOfBirth: DateTime.now(),
        addresses: [address1, address2],
      );
      SharedPreferences.setMockInitialValues({userKey: json.encode(userWithAddresses.toJson())});
      
      final userProvider = UserProvider();
      await userProvider.loadUser();
      
      await tester.pumpWidget(createWidgetUnderTest(userProvider));
      await tester.pump();

      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text(address1.fullAddress), findsOneWidget);
      expect(find.text('456 Oak Ave'), findsOneWidget);
      expect(find.text(address2.fullAddress), findsOneWidget);
      
      final defaultAddressTile = find.ancestor(
        of: find.text('456 Oak Ave'), 
        matching: find.byType(ListTile),
      );
      expect(find.descendant(of: defaultAddressTile, matching: find.byIcon(Icons.star)), findsOneWidget);
    });

    testWidgets('Tapping FAB should navigate to address form', (WidgetTester tester) async {
      final testUser = User(
        id: '1',
        firstName: 'Test',
        lastName: 'User',
        dateOfBirth: DateTime.now(),
        addresses: [],
      );
      SharedPreferences.setMockInitialValues({userKey: json.encode(testUser.toJson())});

      final userProvider = UserProvider();
      await userProvider.loadUser();

      await tester.pumpWidget(createWidgetUnderTest(userProvider));
      await tester.pump();

      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    });
  });
}

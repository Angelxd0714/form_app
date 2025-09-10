
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_form_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('AddressFormScreen Widget Tests', () {
    Future<void> pumpAddressFormScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          child: const MaterialApp(
            home: AddressFormScreen(),
          ),
        ),
      );
    }

    testWidgets('Should show validation errors when saving with empty fields', (WidgetTester tester) async {
      // Arrange
      await pumpAddressFormScreen(tester);

      // Act: Tap the save button without entering any text
      await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar Dirección'));
      await tester.pump();

      // Assert: Verify that all validation messages are displayed
      expect(find.text('Ingresa una calle'), findsOneWidget);
      expect(find.text('Ingresa una ciudad'), findsOneWidget);
      expect(find.text('Ingresa un estado o provincia'), findsOneWidget);
      expect(find.text('Ingresa un código postal'), findsOneWidget);
    });

    testWidgets('Should not show validation errors when fields are filled', (WidgetTester tester) async {
      // Arrange
      await pumpAddressFormScreen(tester);

      // Act: Fill in all the fields
      await tester.enterText(find.byKey(const Key('street_field')), '123 Main St');
      await tester.enterText(find.byKey(const Key('city_field')), 'Anytown');
      await tester.enterText(find.byKey(const Key('state_field')), 'CA');
      await tester.enterText(find.byKey(const Key('zip_code_field')), '12345');

      // Tap the save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar Dirección'));
      await tester.pump();

      // Assert: Verify that no validation messages are shown
      expect(find.text('Ingresa una calle'), findsNothing);
      expect(find.text('Ingresa una ciudad'), findsNothing);
      expect(find.text('Ingresa un estado o provincia'), findsNothing);
      expect(find.text('Ingresa un código postal'), findsNothing);
    });
  });
}

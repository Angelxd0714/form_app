
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/user_form_screen.dart';
import 'package:form_app/widgets/date_picker_field.dart';

void main() {
  group('UserFormScreen Widget Tests', () {
    
    Future<void> pumpUserFormScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          child: const MaterialApp(
            home: UserFormScreen(),
          ),
        ),
      );
    }

    testWidgets('Should show validation errors when saving with empty fields', (WidgetTester tester) async {
      // Arrange
      await pumpUserFormScreen(tester);

      // Act
      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pump();

      // Assert
      expect(find.text('Por favor ingresa tu nombre'), findsOneWidget);
      expect(find.text('Por favor ingrese su apellido'), findsOneWidget);
      expect(find.text('Por favor selecciona tu fecha de nacimiento'), findsOneWidget);
    });

    testWidgets('Should not show validation errors when fields are filled', (WidgetTester tester) async {
      // Arrange
      await pumpUserFormScreen(tester);

      // Act
      await tester.enterText(find.byKey(const Key('nombre_field')), 'John');
      await tester.enterText(find.byKey(const Key('apellido_field')), 'Doe');
      
      // Tap on the custom date picker field to open the dialog
      await tester.tap(find.byType(DatePickerField));
      await tester.pumpAndSettle(); // Wait for the dialog to appear
      
      // Confirm the date selection
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle(); // Wait for the dialog to close

      // Tap the save button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(find.text('Por favor ingresa tu nombre'), findsNothing);
      expect(find.text('Por favor ingrese su apellido'), findsNothing);
      expect(find.text('Por favor selecciona tu fecha de nacimiento'), findsNothing);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/user_profile_screen.dart';
import 'package:form_app/widgets/country_state_city_picker.dart';
import 'package:provider/provider.dart';

class AddressFormScreen extends StatefulWidget {
  static const routeName = '/address-form';

  const AddressFormScreen({super.key});

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _isDefault = false;

  @override
  void dispose() {
    _streetController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountry == null || _selectedState == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa toda la información de ubicación')),
      );
      return;
    }

    final address = Address(
      street: _streetController.text.trim(),
      city: _selectedCity!,
      state: _selectedState!,
      country: _selectedCountry!,
      additionalInfo: _additionalInfoController.text.trim().isNotEmpty
          ? _additionalInfoController.text.trim()
          : null,
      isDefault: _isDefault,
    );

    Provider.of<UserProvider>(context, listen: false)
        .addAddress(address)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dirección guardada exitosamente')),
      );
      Navigator.of(context).pushReplacementNamed(UserProfileScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Dirección'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CountryStateCityPicker(
                onCountryChanged: (value) => _selectedCountry = value,
                onStateChanged: (value) => _selectedState = value,
                onCityChanged: (value) => _selectedCity = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Calle y Número',
                  hintText: 'Ej: Av. Principal #123',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la calle y número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _additionalInfoController,
                decoration: const InputDecoration(
                  labelText: 'Información Adicional (Opcional)',
                  hintText: 'Ej: Edificio, Piso, Depto, etc.',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Establecer como dirección principal'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar Dirección'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    UserProfileScreen.routeName,
                  );
                },
                child: const Text('Omitir por ahora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

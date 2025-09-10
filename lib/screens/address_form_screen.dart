import 'package:flutter/material.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class AddressFormScreen extends StatefulWidget {
  static const routeName = '/address-form';

  const AddressFormScreen({super.key});

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  bool _isDefault = false;
  Address? _editingAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final address = ModalRoute.of(context)!.settings.arguments as Address?;
    if (address != null) {
      _editingAddress = address;
      _streetController.text = address.street;
      _cityController.text = address.city;
      _stateController.text = address.state;
      _zipCodeController.text = address.zipCode;
      _isDefault = address.isDefault;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = Address(
      id: _editingAddress?.id, 
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      isDefault: _isDefault, country: '',
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_editingAddress != null) {
      userProvider.updateAddress(newAddress);
    } else {
      userProvider.addAddress(newAddress);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingAddress != null ? 'Editar Dirección' : 'Nueva Dirección'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ChatScreen.routeName);
        },
        child: const Icon(Icons.chat),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('street_field'),
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Calle'),
                validator: (value) => value!.isEmpty ? 'Ingresa una calle' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('city_field'),
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (value) => value!.isEmpty ? 'Ingresa una ciudad' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('state_field'),
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'Estado/Provincia'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un estado o provincia' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('zip_code_field'),
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Código Postal'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un código postal' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Marcar como dirección principal'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar Dirección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

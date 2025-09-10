import 'package:flutter/material.dart';
import 'package:form_app/models/user_model.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/user_profile_screen.dart';
import 'package:form_app/widgets/date_picker_field.dart';
import 'package:provider/provider.dart';

class UserFormScreen extends StatefulWidget {
  static const routeName = '/user-form';

  const UserFormScreen({super.key});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isEditMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isEditMode = ModalRoute.of(context)!.settings.arguments as bool? ?? false;
    if (isEditMode) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.hasUser) {
        final user = userProvider.currentUser!;
        _isEditMode = true;
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _selectedDate = user.dateOfBirth;
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor corrige los errores antes de continuar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final user = User(
      id: _isEditMode ? userProvider.currentUser!.id : null,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _selectedDate!,
      addresses: _isEditMode ? userProvider.currentUser!.addresses : [],
    );

    userProvider.saveUser(user).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Perfil actualizado exitosamente'
                : 'Perfil creado exitosamente',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacementNamed(UserProfileScreen.routeName);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al guardar el perfil: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Perfil' : 'Crear Cuenta'),
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
                key: const Key('nombre_field'),
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingresa tu nombre',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  if (value.trim().length < 2) {
                    return 'El nombre debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('apellido_field'),
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  hintText: 'Ingresa tu apellido',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  if (value.trim().length < 2) {
                    return 'El apellido debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: 'Fecha de Nacimiento',
                selectedDate: _selectedDate,
                onDateSelected: _selectDate,
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Por favor selecciona tu fecha de nacimiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isEditMode ? 'Guardar Cambios' : 'Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

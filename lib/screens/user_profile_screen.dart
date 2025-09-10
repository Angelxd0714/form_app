import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_list_screen.dart';
import 'package:form_app/screens/user_form_screen.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user-profile';

  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(UserFormScreen.routeName);
            },
            tooltip: 'Editar perfil',
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (!userProvider.hasUser) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No hay información de usuario'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        UserFormScreen.routeName,
                      );
                    },
                    child: const Text('Crear Perfil'),
                  ),
                ],
              ),
            );
          }

          final user = userProvider.currentUser!;
          final formatter = DateFormat('dd/MM/yyyy');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información Personal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Nombre'),
                          subtitle: Text(user.firstName),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Apellido'),
                          subtitle: Text(user.lastName),
                        ),
                        ListTile(
                          leading: const Icon(Icons.cake),
                          title: const Text('Fecha de Nacimiento'),
                          subtitle: Text(formatter.format(user.dateOfBirth)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Direcciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AddressListScreen.routeName,
                        );
                      },
                      child: const Text('Añadir nueva'),
                    ),
                  ],
                ),
                if (user.addresses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text('No hay direcciones guardadas'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: user.addresses.length,
                    itemBuilder: (context, index) {
                      final address = user.addresses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(
                            address.street,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(address.fullAddress),
                          trailing: address.isDefault
                              ? const Chip(
                                  label: Text('Primaria'),
                                  backgroundColor: Colors.green,
                                  labelStyle: TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Direcciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        currentIndex: 2, // Perfil
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed(UserFormScreen.routeName, arguments: null);
              break;
            case 1:
              Navigator.of(context).pushNamed(AddressListScreen.routeName);
              break;
            case 2:
              // Ya estamos en la pantalla de perfil
              break;
          }
        },
      ),
    );
  }
}

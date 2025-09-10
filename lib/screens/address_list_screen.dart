import 'package:flutter/material.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_form_screen.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatelessWidget {
  static const routeName = '/address-list';

  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (!userProvider.hasUser || userProvider.currentUser!.addresses.isEmpty) {
            return const Center(
              child: Text('No hay direcciones guardadas'),
            );
          }

          final addresses = userProvider.currentUser!.addresses;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    address.street,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(address.fullAddress),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AddressFormScreen.routeName,
                            arguments: address,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(context, address.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(AddressFormScreen.routeName);
        },
        label: const Text('Agregar nueva dirección'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Dirección'),
        content: const Text('¿Estás seguro de que quieres eliminar esta dirección?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<UserProvider>(context, listen: false)
                  .removeAddress(addressId);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

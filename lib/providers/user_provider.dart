import 'package:flutter/foundation.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/models/user_model.dart';
import 'package:form_app/services/storage_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final StorageService _storageService = StorageService();

  User? get currentUser => _currentUser;
  bool get hasUser => _currentUser != null;

  Future<void> loadUser() async {
    _currentUser = await _storageService.getUser();
    notifyListeners();
  }

  Future<void> saveUser(User user) async {
    _currentUser = user;
    await _storageService.saveUser(user);
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    if (_currentUser == null) return;
    
    final updatedUser = User(
      id: _currentUser!.id,
      firstName: _currentUser!.firstName,
      lastName: _currentUser!.lastName,
      dateOfBirth: _currentUser!.dateOfBirth,
      addresses: [..._currentUser!.addresses, address],
    );
    
    await saveUser(updatedUser);
  }

  Future<void> removeAddress(String addressId) async {
    if (_currentUser == null) return;
    
    final updatedAddresses = _currentUser!.addresses
        .where((address) => address.id != addressId)
        .toList();
        
    final updatedUser = User(
      id: _currentUser!.id,
      firstName: _currentUser!.firstName,
      lastName: _currentUser!.lastName,
      dateOfBirth: _currentUser!.dateOfBirth,
      addresses: updatedAddresses,
    );
    
    await saveUser(updatedUser);
  }
}

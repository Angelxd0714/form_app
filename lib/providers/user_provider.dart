import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_app/models/address_model.dart';
import 'package:form_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  static const String _userKey = 'user_data';

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get hasUser => _currentUser != null;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      _currentUser = User.fromJson(json.decode(userData));
    }
    notifyListeners();
  }

  Future<void> saveUser(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    notifyListeners();
  }

  Future<void> clearUser() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }

  void addAddress(Address address) {
    if (_currentUser == null) return;
    var updatedAddresses = List<Address>.from(_currentUser!.addresses);
    if (address.isDefault) {
      updatedAddresses = updatedAddresses.map((addr) => addr.copyWith(isDefault: false)).toList();
    }
    updatedAddresses.add(address);
    saveUser(_currentUser!.copyWith(addresses: updatedAddresses));
  }

  void removeAddress(String addressId) {
    if (_currentUser != null) {
      final updatedAddresses = _currentUser!.addresses.where((address) => address.id != addressId).toList();
      saveUser(_currentUser!.copyWith(addresses: updatedAddresses));
    }
  }

  void updateAddress(Address newAddress) {
    if (_currentUser == null) return;
    final updatedAddresses = _currentUser!.addresses.map((address) {
      if (address.id == newAddress.id) {
        return newAddress;
      }
      if (newAddress.isDefault) {
        return address.copyWith(isDefault: false);
      }
      return address;
    }).toList();
    saveUser(_currentUser!.copyWith(addresses: updatedAddresses));
  }

  void updateDefaultAddress(Address newDefaultAddress) {
    if (_currentUser != null) {
      final updatedAddresses = _currentUser!.addresses
          .map((address) => address.id == newDefaultAddress.id
              ? address.copyWith(isDefault: true)
              : address.copyWith(isDefault: false))
          .toList();
      saveUser(_currentUser!.copyWith(addresses: updatedAddresses));
    }
  }
}

import 'package:flutter/material.dart';
import '../models/auth_model.dart'; // ✅ Import the correct User model
import 'local_storage.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  void setUser(User user, String token) {
    _user = user;
    _token = token;

    // Save user data to local storage
    LocalStorage.saveUser(
      token: token,
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      role: user.role,
    );

    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    final data = await LocalStorage.getUser();

    if (data['token'] != null &&
        data['name'] != null &&
        data['email'] != null &&
        data['id'] != null) {
      _user = User(
        id: data['id']!,
        name: data['name']!,
        email: data['email']!,
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        role: data['role'] ?? '',
      );

      _token = data['token'];
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _token = null;
    LocalStorage.clearUser();
    notifyListeners();
  }
}

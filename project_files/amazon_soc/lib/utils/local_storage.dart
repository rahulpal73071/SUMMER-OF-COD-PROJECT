import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUser({
    required String token,
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('id', id);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('role', role);
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'id': prefs.getString('id'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'phone': prefs.getString('phone'),
      'address': prefs.getString('address'),
      'role': prefs.getString('role'),
    };
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}

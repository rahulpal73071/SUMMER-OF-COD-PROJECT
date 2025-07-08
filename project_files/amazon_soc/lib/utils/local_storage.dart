import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUser(String token, String name, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('role', role); // ✅ Save role
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'role': prefs.getString('role'), // ✅ Get role
    };
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('role'); // ✅ Remove role
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class AuthService {
  final String baseUrl = 'http://10.21.145.117:5000/api/auth'; // For Android emulator

  // ✅ UPDATED register method (includes address)
  Future<AuthResponse> register(String name, String email, String password, String phone, String address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address, // ✅ Include address here
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<AuthResponse> registerAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'role': 'admin', // explicitly setting role
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<User> updateUserProfile({
    required String token,
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}

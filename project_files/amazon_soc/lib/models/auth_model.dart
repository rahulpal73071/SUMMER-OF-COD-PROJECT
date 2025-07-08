// lib/models/auth_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String address;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
      );
}

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        user: User.fromJson(json['user']),
        token: json['token'],
      );
}

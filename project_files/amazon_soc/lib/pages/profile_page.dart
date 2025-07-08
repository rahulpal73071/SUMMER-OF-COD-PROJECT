// lib/views/profile/profile_page.dart
import 'package:amazon_soc/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import '../../utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  void logout(BuildContext context) async {
    await LocalStorage.clearUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (_) => false,
    );
  }



  void _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _role = prefs.getString('role') ?? 'user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            Text("Role: $_role", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            if (_role == 'admin') // ✅ Show only for admin
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add New Product"),
                onPressed: () {
                  Navigator.pushNamed(context, '/add-product');
                },
              ),
              SizedBox(
                height: 200,
              ),
              ElevatedButton.icon(
          onPressed: () => logout(context),
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
        ),
          ],
        ),
      ),
    );
  }
}

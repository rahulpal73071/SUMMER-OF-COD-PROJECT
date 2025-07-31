import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/local_storage.dart';
import '../../screens/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _role = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? 'user';
      _name = prefs.getString('name') ?? 'Admin';
    });
  }

  void _logout(BuildContext context) async {
    await LocalStorage.clearUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome, $_name!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Role: $_role',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),

            // Admin and Superuser common options
            if (_role == 'admin' || _role == 'superuser') ...[
              Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.add, color: Colors.blue),
                  title: const Text("Add New Product"),
                  onTap: () => Navigator.pushNamed(context, '/add-product'),
                ),
              ),
              Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.inventory, color: Colors.green),
                  title: const Text("Your Products"),
                  onTap: () => Navigator.pushNamed(context, '/your-products'),
                ),
              ),
            ],

            // Superuser-only option
            if (_role == 'superuser') ...[
              Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                  title: const Text("Add Admin"),
                  onTap: () => Navigator.pushNamed(context, '/register-admin'),
                ),
              ),
            ],

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

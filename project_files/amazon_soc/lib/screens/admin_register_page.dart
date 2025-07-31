import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? error;

  Future<void> _registerAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _authService.registerAdmin(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin registered successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Register Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFc9d6ff),
              Color(0xFFe2e2e2),
              Color(0xFFfbc2eb),
              Color(0xFFa6c1ee),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Admin Registration",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (error != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.redAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                error!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    CustomTextField(
                      hint: "Name",
                      controller: _nameController,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hint: "Email",
                      controller: _emailController,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hint: "Phone",
                      controller: _phoneController,
                      prefixIcon: Icons.phone,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hint: "Address",
                      controller: _addressController,
                      prefixIcon: Icons.home,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hint: "Password",
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Register Admin",
                            onTap: _registerAdmin,
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            borderRadius: 30,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

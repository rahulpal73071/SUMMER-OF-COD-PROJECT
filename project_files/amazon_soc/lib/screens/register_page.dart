import 'package:amazon_soc/utils/root_app.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
// import 'home_page.dart';
import '../../utils/local_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final authService = AuthService();

  bool isLoading = false;
  String? error;

  void registerUser() async {
    setState(() => isLoading = true);
    try {
      final response = await authService.register(
        nameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
      );

      await LocalStorage.saveUser(
        response.token,
        response.user.name,
        response.user.email,
        response.user.role,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootApp()),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)),
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Account",
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
                    controller: nameController,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hint: "Email",
                    controller: emailController,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hint: "Phone",
                    controller: phoneController,
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hint: "Password",
                    controller: passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Register",
                          onTap: registerUser,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          borderRadius: 30,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

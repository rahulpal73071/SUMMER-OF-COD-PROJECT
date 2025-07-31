import 'package:flutter/material.dart';
import '../../models/auth_model.dart';
import '../../services/auth_service.dart';

class UpdateProfilePage extends StatefulWidget {
  final User user;
  final String token;
  final Function(User) onProfileUpdated;

  const UpdateProfilePage({
    super.key,
    required this.user,
    required this.token,
    required this.onProfileUpdated,
  });

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    super.initState();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final updatedUser = await AuthService().updateUserProfile(
          token: widget.token,
          userId: widget.user.id,
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        );

        widget.onProfileUpdated(updatedUser);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context); // Close the update page
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (val) => val == null || val.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

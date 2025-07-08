// lib/views/admin/add_product_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '', desc = '', category = '';
  double price = 0;
  int quantity = 0;
  List<File> images = [];

  void _pickImages() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => images = picked.map((e) => File(e.path)).toList());
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ProductService().createProduct(
        title: title,
        description: desc,
        price: price,
        quantity: quantity,
        category: category,
        images: images,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (v) => title = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (v) => desc = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (v) => price = double.tryParse(v) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (v) => quantity = int.tryParse(v) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (v) => category = v,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text("Pick Images"),
                  ),
                  Text("${images.length} selected"),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

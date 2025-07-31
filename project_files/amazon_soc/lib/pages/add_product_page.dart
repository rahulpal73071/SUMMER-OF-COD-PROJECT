import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/product_service.dart';

const List<String> filterCategories = [
  "Electronics",
  "Fashion",
  "Grocery",
  "Accessory",
  "Men Fashion",
  "Women Fashion",
];

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '', desc = '', category = filterCategories.first;
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

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Product Uploaded!'),
          content: const Text('What would you like to do next?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _formKey.currentState?.reset();
                setState(() {
                  images.clear();
                  category = filterCategories.first;
                });
              },
              child: const Text('Add More'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.teal.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Product Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 🔤 Title
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (v) => title = v,
                validator: (v) => v!.isEmpty ? 'Title is required' : null,
              ),

              // 📄 Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onChanged: (v) => desc = v,
              ),

              // 💵 Price
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (v) => price = double.tryParse(v) ?? 0,
                validator: (v) => (double.tryParse(v!) ?? 0) <= 0
                    ? 'Enter valid price'
                    : null,
              ),

              // 📦 Quantity
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (v) => quantity = int.tryParse(v) ?? 0,
              ),

              // 🔽 Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: category,
                items: filterCategories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              const Text(
                "Images",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo),
                    label: const Text("Pick Images"),
                  ),
                  Text("${images.length} selected"),
                ],
              ),

              if (images.isNotEmpty)
                GridView.builder(
                  itemCount: images.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text("Submit Product"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

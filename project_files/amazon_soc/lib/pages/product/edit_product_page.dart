import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final ProductService _productService = ProductService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;

  List<File> _newImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
    _categoryController = TextEditingController(text: widget.product.category);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _newImages = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _productService.updateProduct(
        id: widget.product.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        category: _categoryController.text,
        newImages: _newImages,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product updated')));
      Navigator.pop(context, true); // ✅ return true to notify refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _imagePreview() {
    if (_newImages.isNotEmpty) {
      return SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _newImages.map((file) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
            );
          }).toList(),
        ),
      );
    } else if (widget.product.images.isNotEmpty) {
      return SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.product.images.map((url) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 16),
                    _imagePreview(),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Pick New Images"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _updateProduct,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

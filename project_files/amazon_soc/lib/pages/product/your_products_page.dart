import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import 'edit_product_page.dart';

class YourProductsPage extends StatefulWidget {
  const YourProductsPage({super.key});

  @override
  State<YourProductsPage> createState() => _YourProductsPageState();
}

class _YourProductsPageState extends State<YourProductsPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);

      final updatedProducts = _productService.fetchProducts();
      setState(() {
        _productsFuture = updatedProducts;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Products")),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 60),
                  title: Text(product.title),
                  subtitle: Text("₹${product.price} | Qty: ${product.quantity}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductPage(product: product),
                          ),
                        );
                        if (updated == true) {
                          final refreshed = _productService.fetchProducts();
                          setState(() {
                            _productsFuture = refreshed;
                          });
                        }
                      } else if (value == 'delete') {
                        _deleteProduct(product.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

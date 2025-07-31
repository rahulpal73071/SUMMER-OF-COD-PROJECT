import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
// import '../../models/product_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1E1E),
        title: const Text('My Cart', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => cart.clearCart(),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDF6EC), Color(0xFFFCEBD5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            items.isEmpty
                ? const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final product = items[index];
                          final quantity = cart.getQuantity(product);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            color: const Color(0xFFF8F1E7),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        product.images.isNotEmpty &&
                                                product.images[0].isNotEmpty
                                            ? Image.network(
                                              product.images[0],
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                  ),
                                            )
                                            : const Icon(Icons.image, size: 40),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.brown,
                                            ),
                                            onPressed:
                                                quantity > 1
                                                    ? () =>
                                                        cart.decreaseQuantity(
                                                          product,
                                                        )
                                                    : null,
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.brown,
                                            ),
                                            onPressed:
                                                quantity < 5
                                                    ? () =>
                                                        cart.increaseQuantity(
                                                          product,
                                                        )
                                                    : null,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '₹${(product.price * quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDED0B6),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, -3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(
                                '₹${cart.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: const Color(0xFFBFA27A),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/checkout');
                              },

                              child: const Text("Checkout"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'payment_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  Future<void> _saveCheckoutDataToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = Provider.of<CartProvider>(context, listen: false);
    final items = cart.items;

    List<Map<String, dynamic>> cartItems = items.map((product) {
      final qty = cart.getQuantity(product);
      return {
        'id': product.id,
        'title': product.title,
        'image': product.images.isNotEmpty ? product.images[0] : '',
        'price': product.price,
        'quantity': qty,
        'totalPrice': (product.price * qty),
      };
    }).toList();

    // Save cart details
    prefs.setString('cart', jsonEncode(cartItems));
    prefs.setDouble('total', cart.totalAmount);

    // Save user details again in case they are needed
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('phone', phone);
    prefs.setString('address', address);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF2C1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("User Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _infoRow("Name", name),
            _infoRow("Email", email),
            _infoRow("Phone", phone),
            _infoRow("Address", address),
            const SizedBox(height: 24),
            const Text("Cart Items", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...items.map((product) {
              final qty = cart.getQuantity(product);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product.images.isNotEmpty
                        ? Image.network(
                            product.images[0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                  ),
                  title: Text(product.title),
                  subtitle: Text('Qty: $qty'),
                  trailing: Text(
                    '₹${(product.price * qty).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ₹${cart.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBFA27A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  await _saveCheckoutDataToLocalStorage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentPage()),
                  );
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/order_service.dart'; // Your service
import '../models/order_model.dart'; // Your model

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String name = '', email = '', phone = '', address = '';
  String paymentMethod = 'Card';
  final cardController = TextEditingController();
  final upiController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  Future<void> _processPayment() async {
    bool isValid = false;

    if (paymentMethod == 'Card' && cardController.text.length == 16) {
      isValid = true;
    } else if (paymentMethod == 'UPI' && upiController.text.contains('@')) {
      isValid = true;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid payment details")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await OrderService().placeOrder();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Payment Successful"),
          content: const Text("Your order has been placed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Choose Payment Method:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text("Card"),
                    leading: Radio(
                      value: 'Card',
                      groupValue: paymentMethod,
                      onChanged: (val) {
                        setState(() => paymentMethod = val!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("UPI"),
                    leading: Radio(
                      value: 'UPI',
                      groupValue: paymentMethod,
                      onChanged: (val) {
                        setState(() => paymentMethod = val!);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (paymentMethod == 'Card')
                    TextField(
                      controller: cardController,
                      decoration: const InputDecoration(
                        labelText: "Card Number",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                    )
                  else
                    TextField(
                      controller: upiController,
                      decoration: const InputDecoration(
                        labelText: "UPI ID",
                        hintText: "example@upi",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 30),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

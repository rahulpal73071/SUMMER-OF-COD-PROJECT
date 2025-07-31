import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderService.getMyOrders();
  }

  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Date: ${order.createdAt.toLocal().toString().split('.')[0]}"),
            Text("Shipping Address: ${order.shippingAddress}"),
            Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
            Text("Payment Status: ${order.paymentStatus}"),
            Text("Order Status: ${order.status}"),
            const SizedBox(height: 10),
            const Text("Products:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.products.map((product) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: product.image != null && product.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(product.productName ?? 'Unnamed Product',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text("Quantity: ${product.quantity}"),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found."));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) =>
                  buildOrderCard(orders[index]),
            );
          }
        },
      ),
    );
  }
}

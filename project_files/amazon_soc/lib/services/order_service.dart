import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderService {
  final String baseUrl = 'http://10.21.145.117:5000/api/orders';

  Future<void> placeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userName = prefs.getString('userEmail') ?? 'Unknown User';
    final address = prefs.getString('address') ?? 'Unknown Address';

    final cart = jsonDecode(prefs.getString('cart') ?? '[]');
    final total = prefs.getDouble('total') ?? 0.0;

    final List<Map<String, dynamic>> products = List.from(cart).map((item) {
      return {
        'productName': item['name'],
        'quantity': item['quantity'],
        'Image': item['image'],
      };
    }).toList();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userName': userName,
        'products': products,
        'shippingAddress': address,
        'totalAmount': total,
        'paymentStatus': 'Completed',
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }

    prefs.remove('cart');
    prefs.remove('total');
  }

  Future<List<Order>> getMyOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load orders');
    }
  }
}

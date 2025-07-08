import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _quantities = {};
  final List<Product> _cartItems = [];

  List<Product> get items => _cartItems;

  void addToCart(Product product) {
    if (!_cartItems.contains(product)) {
      _cartItems.add(product);
      _quantities[product.id] = 1;
    } else {
      increaseQuantity(product);
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    if (_quantities.containsKey(product.id) && _quantities[product.id]! < 5) {
      _quantities[product.id] = _quantities[product.id]! + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    if (_quantities.containsKey(product.id) && _quantities[product.id]! > 1) {
      _quantities[product.id] = _quantities[product.id]! - 1;
      notifyListeners();
    }
  }

  int getQuantity(Product product) {
    return _quantities[product.id] ?? 1;
  }

  double get totalAmount {
    double total = 0;
    for (final product in _cartItems) {
      total += product.price * (_quantities[product.id] ?? 1);
    }
    return total;
  }

  void clearCart() {
    _cartItems.clear();
    _quantities.clear();
    notifyListeners();
  }
}

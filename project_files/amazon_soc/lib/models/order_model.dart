class Order {
  final String id;
  final String userEmail;
  final List<ProductOrder> products;
  final double totalAmount;
  final String shippingAddress;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userEmail,
    required this.products,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userEmail: json['userEmail'],
      products: (json['products'] as List)
          .map((p) => ProductOrder.fromJson(p))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      shippingAddress: json['shippingAddress'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ProductOrder {
  final String productName;
  final int quantity;
  final String image;

  ProductOrder({
    required this.productName,
    required this.quantity,
    required this.image,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      productName: json['productName'],
      quantity: json['quantity'],
      image: json['Image'],
    );
  }
}

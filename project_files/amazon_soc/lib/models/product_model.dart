class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final List<String> images;
  final String category;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.category,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      images: List<String>.from(json['images']),
      category: json['category'],
      rating: json['rating']?['rate']?.toDouble() ?? 0.0,
      ratingCount: json['rating']?['count'] ?? 0,
    );
  }
}

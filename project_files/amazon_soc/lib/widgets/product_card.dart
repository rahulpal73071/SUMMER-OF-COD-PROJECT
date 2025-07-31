import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 280, // ✅ Constrain height to avoid overflow
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📷 Image
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: (product.images.isNotEmpty && product.images[0].isNotEmpty)
                    ? Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                      )
                    : _fallbackImage(),
              ),
            ),

            // 📝 Info
            Expanded( // ✅ Fill remaining space without overflowing
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008000),
                      ),
                    ),
                     // ✅ Pushes rating to bottom
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported, color: Colors.grey[500], size: 40),
    );
  }
}

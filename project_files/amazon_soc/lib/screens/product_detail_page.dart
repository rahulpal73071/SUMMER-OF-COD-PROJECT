import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../pages/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Product> _recommendations = [];
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
    _checkCart();
  }

  void _checkCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      _isInCart = cart.items.any((item) => item.id == widget.product.id);
    });
  }

  void _fetchRecommendations() async {
    try {
      final all = await ProductService().fetchProducts(
        category: widget.product.category,
      );
      setState(() {
        _recommendations =
            all.where((p) => p.id != widget.product.id).take(5).toList();
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  void _showImageZoom(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showImageZoom(product.images[index]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Title & Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(label: Text(product.category.toUpperCase())),
              ],
            ),
            const SizedBox(height: 8),

            // Price & Rating
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                
              ],
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(product.description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),

            // Add to Cart Button
            ElevatedButton.icon(
              icon: Icon(
                _isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
              ),
              label: Text(_isInCart ? 'Go to Cart' : 'Add to Cart'),
              onPressed: () {
                if (_isInCart) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                } else {
                  cart.addToCart(product);
                  setState(() => _isInCart = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                }
              },
            ),
            const SizedBox(height: 24),

            // Recommendations
            if (_recommendations.isNotEmpty)
              const Text(
                'You May Also Like',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            if (_recommendations.isNotEmpty)
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = _recommendations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: rec),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  rec.images.isNotEmpty ? rec.images[0] : '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rec.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('₹${rec.price.toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

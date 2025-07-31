import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_search_bar.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Product> _products = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final _categories = [
    'all',
    'grocery',
    'electronics',
    'fashion',
    'men fashion',
    'women fashion',
    'accessory',
  ];

  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _fetchProducts();
  }

  void _fetchProducts() async {
    final data = await ProductService().fetchProducts(
      category: _selectedCategory == 'all' ? null : _selectedCategory,
      search: _searchQuery,
    );
    setState(() => _products = data);
  }

  void _onSearch(String value) {
    setState(() => _searchQuery = value);
    _fetchProducts();
  }

  void _onCategorySelected(int index) {
    setState(() => _selectedCategory = _categories[index]);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "BAJAAR",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              IconButton(
                icon: Icon(_showSearchBar ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _showSearchBar = !_showSearchBar;
                    if (!_showSearchBar) {
                      _searchController.clear();
                      _searchQuery = '';
                      _fetchProducts();
                    }
                  });
                },
              )
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_showSearchBar ? 100 : 48),
            child: Column(
              children: [
                if (_showSearchBar)
                  ProductSearchBar(
                    controller: _searchController,
                    onSubmitted: _onSearch,
                    autofocus: true,
                  ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  onTap: _onCategorySelected,
                  tabs: _categories
                      .map((cat) => Tab(child: Text(cat.toUpperCase())))
                      .toList(),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF5F5DC), // Beige
                Color(0xFFFFE4C4), // Bisque
                Color(0xFFFFF8DC), // Cornsilk
                Color(0xFFFFDAB9), // Peach Puff
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: _products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: _products[index],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                  product: _products[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

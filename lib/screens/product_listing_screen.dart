import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/product_service.dart';
import '../utils/app_constants.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String category;
  const ProductListingScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late Future<List<Product>> _future;
  bool _isGrid = true;
  String _sortBy = 'Default';
  final List<String> _sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    _future = ProductService.fetchByCategory(widget.category);
  }

  List<Product> _sortProducts(List<Product> products) {
    final sorted = List<Product>.from(products);
    switch (_sortBy) {
      case 'Price: Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        sorted.sort((a, b) => b.ratingRate.compareTo(a.ratingRate));
        break;
    }
    return sorted;
  }

  String get _screenTitle {
    if (widget.category.isEmpty) return 'All Products';
    switch (widget.category) {
      case "women's clothing": return "Women's Clothing";
      case "men's clothing":   return "Men's Clothing";
      case 'accessories':      return 'Accessories';
      case 'footwear':         return 'Footwear';
      default:                 return widget.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_screenTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (_) => _sortOptions
                .map((o) => PopupMenuItem(value: o, child: Text(o)))
                .toList(),
          ),
          IconButton(
            icon: Icon(
              _isGrid ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.textGrey),
                  const SizedBox(height: 12),
                  const Text('Failed to load products.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _future =
                          ProductService.fetchByCategory(widget.category);
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final products = _sortProducts(snapshot.data ?? []);

          if (products.isEmpty) {
            return const Center(
              child: Text('No products found.',
                  style: TextStyle(color: AppColors.textGrey)),
            );
          }

          if (_isGrid) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => ProductCard(product: products[i]),
            );
          }

          // List view
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (_, i) {
              final p = products[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      p.imageAsset,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  title: Text(p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.gold),
                      const SizedBox(width: 2),
                      Text(p.ratingRate.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                  trailing: Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: p),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
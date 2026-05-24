import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/product_service.dart';
import '../utils/app_constants.dart';
import '../widgets/product_card.dart';
import 'product_listing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final PageController _bannerController = PageController();

  // Categories now match what is stored in Firestore
  final List<Map<String, dynamic>> _categories = [
    {'label': "All",       'icon': Icons.apps,            'key': ''},
    {'label': "Women's",   'icon': Icons.woman,           'key': "women's clothing"},
    {'label': "Men's",     'icon': Icons.man,             'key': "men's clothing"},
    {'label': "Accessories",'icon': Icons.watch,          'key': "accessories"},
    {'label': "Footwear",  'icon': Icons.snowshoeing,     'key': "footwear"},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'New Arrivals',
      'subtitle': 'Up to 50% Off',
      'color1': const Color(0xFF1A1A2E),
      'color2': const Color(0xFFE94560),
    },
    {
      'title': "Women's Collection",
      'subtitle': 'Exclusive Styles',
      'color1': const Color(0xFF6A0572),
      'color2': const Color(0xFFAB83A1),
    },
    {
      'title': 'Summer Sale',
      'subtitle': 'Shop Now & Save',
      'color1': const Color(0xFF0F3460),
      'color2': const Color(0xFF533483),
    },
  ];

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async {
          setState(() {
            _productsFuture = ProductService.fetchProducts();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              _buildBanner(),
              const SizedBox(height: 8),
              _buildCategories(),
              _buildSectionHeader('🔥 Featured Products', 'See All', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductListingScreen(category: ''),
                  ),
                );
              }),
              _buildFeaturedProducts(),
              _buildSectionHeader("✨ New Arrivals", 'See All', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductListingScreen(category: ''),
                  ),
                );
              }),
              _buildNewArrivals(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'F-Dilu Fashion Store',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'Style Redefined',
            style: TextStyle(color: AppColors.accent, fontSize: 11),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search, color: AppColors.textGrey),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Search products, brands...',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final b = _banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [b['color1'], b['color2']],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b['subtitle'],
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProductListingScreen(category: ''),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Shop Now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductListingScreen(category: cat['key'] as String),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(cat['icon'] as IconData,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, String actionLabel, VoidCallback onAction) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid(4);
        }
        if (snapshot.hasError) {
          return _buildError();
        }
        final products = snapshot.data!.take(4).toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(product: products[i]),
        );
      },
    );
  }

  Widget _buildNewArrivals() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (_, __) => Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) return const SizedBox();
        // Show last 6 as "new arrivals"
        final products = snapshot.data!.reversed.take(6).toList();
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (_, i) => SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ProductCard(product: products[i]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid(int count) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: count,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Failed to load products. Pull to refresh.',
            style: TextStyle(color: AppColors.textGrey)),
      ),
    );
  }
}
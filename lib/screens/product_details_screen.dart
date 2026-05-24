import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../utils/app_constants.dart';
import '../utils/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _qty = 1;
  String _selectedSize = 'M';
  String _selectedColor = 'Black';

  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<String> _colors = ['Black', 'White', 'Navy', 'Grey'];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE ──────────────────────────────────────────────────────
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  product.imageAsset,
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── TITLE ──────────────────────────────────────────────────────
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            // ── PRICE ──────────────────────────────────────────────────────
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),

            const SizedBox(height: 12),

            // ── RATING ─────────────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.gold, size: 18),
                const SizedBox(width: 4),
                Text(
                  product.ratingRate.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${product.ratingCount} reviews)',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── SIZE SELECTOR ──────────────────────────────────────────────
            const Text('Size',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: _sizes.map((s) {
                final selected = s == _selectedSize;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = s),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ── COLOR SELECTOR ─────────────────────────────────────────────
            const Text('Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: _colors.map((c) {
                final selected = c == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ── QUANTITY ───────────────────────────────────────────────────
            const Text('Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: [
                _qtyButton(Icons.remove, () {
                  if (_qty > 1) setState(() => _qty--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_qty',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _qtyButton(Icons.add, () => setState(() => _qty++)),
              ],
            ),

            const SizedBox(height: 24),

            // ── DESCRIPTION ────────────────────────────────────────────────
            const Text('Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ── BOTTOM BUTTONS ─────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    product,
                    qty: _qty,
                    size: _selectedSize,
                    color: _selectedColor,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Add to Cart',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    product,
                    qty: _qty,
                    size: _selectedSize,
                    color: _selectedColor,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                child: const Text(
                  'Buy Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/cart_provider.dart';
import '../utils/app_constants.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart (${cart.items.length})'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text(
                        'Remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear',
                  style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  const Text('Add some items to get started!',
                      style: TextStyle(color: AppColors.textGrey)),
                ],
              ),
            )
          : Column(
              children: [
                // ── CART ITEMS ──────────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                item.product.imageAsset,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 72,
                                  height: 72,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.size} / ${item.color}',
                                    style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Qty controls
                            Column(
                              children: [
                                _circleBtn(
                                  Icons.add,
                                  () => cart.increaseQty(item),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                _circleBtn(
                                  item.quantity > 1
                                      ? Icons.remove
                                      : Icons.delete_outline,
                                  () => cart.decreaseQty(item),
                                  color: item.quantity == 1
                                      ? Colors.red.shade300
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── SUMMARY + CHECKOUT ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal',
                              style: TextStyle(color: AppColors.textGrey)),
                          Text(
                            '\$${cart.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping',
                              style: TextStyle(color: AppColors.textGrey)),
                          Text('\$5.99',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(
                            '\$${(cart.subtotal + 5.99).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                    cartItems: cart.items),
                              ),
                            );
                          },
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? AppColors.primary).withOpacity(0.1),
        ),
        child: Icon(icon,
            size: 16, color: color ?? AppColors.primary),
      ),
    );
  }
}
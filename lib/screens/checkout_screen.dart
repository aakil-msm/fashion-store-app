import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../utils/app_constants.dart';
import '../utils/auth_service.dart';
import '../utils/cart_provider.dart';
import '../utils/order_service.dart';
import 'my_orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _formKey     = GlobalKey<FormState>();

  String _paymentMethod = 'Cash on Delivery';
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _nameCtrl.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  double get _subtotal =>
      widget.cartItems.fold(0.0, (s, i) => s + i.totalPrice);

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placing = true);

    try {
      final orderId = await OrderService.placeOrder(
        items: widget.cartItems,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        paymentMethod: _paymentMethod,
      );

      if (mounted) {
        await Provider.of<CartProvider>(context, listen: false).clearCart();
      }
      if (!mounted) return;
      _showSuccess(orderId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  void _showSuccess(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text('Order Placed!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: Text(
          'Your order has been placed successfully.\n\nOrder ID: #${orderId.substring(0, 8).toUpperCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textGrey),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close checkout
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyOrdersScreen()),
                );
              },
              child: const Text('View My Orders',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const shipping = 5.99;
    final total = _subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── DELIVERY DETAILS ──────────────────────────────────────
                _sectionTitle('Delivery Details'),
                const SizedBox(height: 12),
                _buildField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _phoneCtrl,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Phone number is required'
                      : null,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _addressCtrl,
                  label: 'Delivery Address',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Delivery address is required'
                      : null,
                ),

                const SizedBox(height: 24),

                // ── PAYMENT METHOD ────────────────────────────────────────
                _sectionTitle('Payment Method'),
                const SizedBox(height: 10),
                Container(
                  decoration: _boxDecoration(),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Cash on Delivery',
                        groupValue: _paymentMethod,
                        title: const Text('Cash on Delivery'),
                        secondary: const Icon(Icons.money,
                            color: AppColors.primary),
                        activeColor: AppColors.accent,
                        onChanged: (v) =>
                            setState(() => _paymentMethod = v!),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'Credit / Debit Card',
                        groupValue: _paymentMethod,
                        title: const Text('Credit / Debit Card'),
                        secondary: const Icon(Icons.credit_card,
                            color: AppColors.primary),
                        activeColor: AppColors.accent,
                        onChanged: (v) =>
                            setState(() => _paymentMethod = v!),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── ORDER SUMMARY ─────────────────────────────────────────
                _sectionTitle('Order Summary'),
                const SizedBox(height: 10),
                ...widget.cartItems.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: _boxDecoration(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.product.imageAsset,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                    '${item.size} / ${item.color}  ×${item.quantity}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent),
                          ),
                        ],
                      ),
                    )),

                const Divider(height: 24),
                _priceRow('Subtotal', _subtotal),
                _priceRow('Shipping', shipping),
                const SizedBox(height: 4),
                _priceRow('Total', total, isTotal: true),

                const SizedBox(height: 28),

                // ── PLACE ORDER BUTTON ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _placing ? null : _placeOrder,
                    child: const Text(
                      'Place Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Busy overlay while placing order
          if (_placing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // ── UI helpers ────────────────────────────────────────────────────────────

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight:
                    isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              )),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight:
                  isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.accent : Colors.black87,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
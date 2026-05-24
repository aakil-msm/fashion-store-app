import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/order_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                setState(() => _ordersFuture = OrderService.fetchOrders()),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading orders: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textGrey)),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No orders yet',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  const Text('Your order history will appear here.',
                      style: TextStyle(color: AppColors.textGrey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => _buildOrderCard(orders[i]),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = (order['orderId'] as String?) ?? '';
    final shortId = orderId.length >= 8
        ? '#${orderId.substring(0, 8).toUpperCase()}'
        : '#$orderId';
    final status = order['status'] as String? ?? 'Pending';
    final total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final payment = order['paymentMethod'] as String? ?? '';
    final address = order['deliveryAddress'] as String? ?? '';
    final items = (order['items'] as List<dynamic>?) ?? [];

    final statusColor = switch (status) {
      'Delivered' => Colors.green,
      'Cancelled' => Colors.red,
      _ => Colors.orange,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shopping_bag_outlined,
              color: AppColors.primary),
        ),
        title: Text(
          shortId,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        children: [
          const Divider(),

          // Delivery info
          _infoRow(Icons.location_on_outlined, address),
          const SizedBox(height: 4),
          _infoRow(Icons.payment_outlined, payment),

          const SizedBox(height: 12),

          // Items
          const Text('Items',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) {
            final imageAsset =
                item['imageAsset'] as String? ?? 'images/products/im1.png';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imageAsset,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image,
                            color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String? ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${item['size']} / ${item['color']}  ×${item['quantity']}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${((item['itemTotal'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        fontSize: 13),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppColors.textGrey, fontSize: 13)),
          ),
        ],
      );
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Place an order — writes to users/{uid}/orders/{auto-id}
  static Future<String> placeOrder({
    required List<CartItem> items,
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
  }) async {
    final uid = _uid;
    if (uid == null) throw Exception('Not logged in');

    final subtotal =
        items.fold(0.0, (s, i) => s + i.totalPrice);
    const shipping = 5.99;
    final total = subtotal + shipping;

    final orderData = {
      'uid': uid,
      'status': 'Pending',
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
      'deliveryName': name,
      'deliveryPhone': phone,
      'deliveryAddress': address,
      'items': items.map((i) => {
            'productId': i.product.id,
            'title': i.product.title,
            'imageAsset': i.product.imageAsset,
            'price': i.product.price,
            'quantity': i.quantity,
            'size': i.size,
            'color': i.color,
            'itemTotal': i.totalPrice,
          }).toList(),
    };

    final ref = await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .add(orderData);

    return ref.id;
  }

  /// Fetch all orders for the current user, newest first.
  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    final uid = _uid;
    if (uid == null) return [];

    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      data['orderId'] = d.id;
      return data;
    }).toList();
  }
}
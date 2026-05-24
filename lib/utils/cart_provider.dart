import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// CartProvider now syncs every change to Firestore under
/// users/{uid}/cart/{productId_size_color}
/// so the cart survives logout and reinstalls.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _loaded = false;

  List<CartItem> get items => _items;
  bool get isLoaded => _loaded;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  // ── Firestore ref helpers ────────────────────────────────────────────────

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static CollectionReference? get _cartCol {
    final uid = _uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  /// Unique document key per cart item (product + size + color combo).
  static String _docKey(String productId, String size, String color) =>
      '${productId}_${size}_$color';

  // ── Load cart from Firestore on login ───────────────────────────────────

  Future<void> loadCart() async {
    final col = _cartCol;
    if (col == null) return;

    final snap = await col.get();
    _items.clear();
    for (final doc in snap.docs) {
      try {
        _items.add(
            CartItem.fromFirestore(doc.data() as Map<String, dynamic>));
      } catch (_) {}
    }
    _loaded = true;
    notifyListeners();
  }

  /// Call this on logout to wipe the in-memory cart.
  void clearLocal() {
    _items.clear();
    _loaded = false;
    notifyListeners();
  }

  // ── Cart mutations (all write to Firestore) ──────────────────────────────

  Future<void> addToCart(
    Product product, {
    int qty = 1,
    String size = 'M',
    String color = 'Black',
  }) async {
    final index = _items.indexWhere((e) =>
        e.product.id == product.id &&
        e.size == size &&
        e.color == color);

    if (index >= 0) {
      _items[index].quantity += qty;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: qty,
        size: size,
        color: color,
      ));
    }
    notifyListeners();
    await _syncItem(product.id, size, color);
  }

  Future<void> increaseQty(CartItem item) async {
    item.quantity++;
    notifyListeners();
    await _syncItem(item.product.id, item.size, item.color);
  }

  Future<void> decreaseQty(CartItem item) async {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
      await _syncItem(item.product.id, item.size, item.color);
    } else {
      await removeItem(item);
    }
  }

  Future<void> removeItem(CartItem item) async {
    _items.remove(item);
    notifyListeners();
    await _cartCol
        ?.doc(_docKey(item.product.id, item.size, item.color))
        .delete();
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    // Delete all Firestore cart docs
    final col = _cartCol;
    if (col == null) return;
    final snap = await col.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Internal: write single item to Firestore ─────────────────────────────

  Future<void> _syncItem(
      String productId, String size, String color) async {
    final col = _cartCol;
    if (col == null) return;

    final index = _items.indexWhere((e) =>
        e.product.id == productId && e.size == size && e.color == color);
    if (index < 0) return;

    await col
        .doc(_docKey(productId, size, color))
        .set(_items[index].toFirestore());
  }
}
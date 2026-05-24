import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;
  String color;

  CartItem({
    required this.product,
    required this.quantity,
    required this.size,
    required this.color,
  });

  double get totalPrice => product.price * quantity;

  /// Convert to a Map for storing in Firestore (users/{uid}/cart).
  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'imageAsset': product.imageAsset,
      'title': product.title,
      'price': product.price,
      'category': product.category,
      'ratingRate': product.ratingRate,
      'ratingCount': product.ratingCount,
      'description': product.description,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  /// Rebuild a CartItem from a Firestore cart document.
  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    final product = Product(
      id: data['productId'] ?? '',
      imageAsset: data['imageAsset'] ?? 'images/products/im1.png',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ratingRate: (data['ratingRate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
    );
    return CartItem(
      product: product,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      size: data['size'] ?? 'M',
      color: data['color'] ?? 'Black',
    );
  }
}
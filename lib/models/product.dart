import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;           // Firestore document ID
  final String imageAsset;   // e.g. "images/products/im1.png"
  final String title;
  final String description;
  final double ratingRate;
  final int ratingCount;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.ratingRate,
    required this.ratingCount,
    required this.price,
    required this.category,
  });

  /// Build a Product from a Firestore document snapshot.
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      imageAsset: data['imageAsset'] ?? 'images/products/im1.png',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ratingRate: (data['ratingRate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
    );
  }

  /// Convert to a Map for writing to Firestore (used by the seed script).
  Map<String, dynamic> toFirestore() {
    return {
      'imageAsset': imageAsset,
      'title': title,
      'description': description,
      'ratingRate': ratingRate,
      'ratingCount': ratingCount,
      'price': price,
      'category': category,
    };
  }
}
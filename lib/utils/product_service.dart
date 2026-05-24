import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

/// Reads product data from Firestore.
/// Replaces the old ApiService that used fakestoreapi.com.
/// 
/// Firestore collection structure:
///   products/{auto-id}
///     ├── title        : String
///     ├── description  : String
///     ├── price        : number
///     ├── category     : String  ("women's clothing" | "men's clothing" | "accessories" | "footwear")
///     ├── imageAsset   : String  ("images/products/im1.png")
///     ├── ratingRate   : number
///     └── ratingCount  : number
class ProductService {
  static final _col = FirebaseFirestore.instance.collection('products');

  /// Fetch all products.
  static Future<List<Product>> fetchProducts() async {
    final snap = await _col.orderBy('title').get();
    return snap.docs.map((d) => Product.fromFirestore(d)).toList();
  }

  /// Fetch products filtered by category.
  /// Pass an empty string to get all products.
  static Future<List<Product>> fetchByCategory(String category) async {
    if (category.isEmpty) return fetchProducts();
    final snap = await _col
        .where('category', isEqualTo: category)
        .orderBy('title')
        .get();
    return snap.docs.map((d) => Product.fromFirestore(d)).toList();
  }

  /// Fetch a single product by its Firestore document ID.
  static Future<Product?> fetchById(String productId) async {
    final doc = await _col.doc(productId).get();
    if (!doc.exists) return null;
    return Product.fromFirestore(doc);
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  static Future<List<Product>> fetchByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }
}

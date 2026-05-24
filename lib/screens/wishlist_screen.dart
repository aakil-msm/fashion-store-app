import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: ListView(
        children: const [
          ListTile(title: Text('Kids Jacket')),
          ListTile(title: Text('Formal Shoes')),
          ListTile(title: Text('Handbag')),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Home Address:\n'
          'No 15, Main Street,\n'
          'Kinniya,\n'
          'Sri Lanka',
        ),
      ),
    );
  }
}
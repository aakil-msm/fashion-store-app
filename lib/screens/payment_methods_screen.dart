import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Visa Card'),
            subtitle: Text('**** **** **** 2345'),
          ),
          ListTile(
            title: Text('Cash On Delivery'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'For support contact:\n\n'
          '📞 +94 77 123 4567\n'
          '📧 support@fdilu.com',
        ),
      ),
    );
  }
}
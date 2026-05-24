import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About F‑Dilu')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'F‑Dilu Fashion Store\n\n'
          'The best online fashion shopping app.\n'
          'Version: 1.0.0',
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fdilu_fashion_store/main.dart';

void main() {
  testWidgets('FDiluFashionApp builds successfully',
      (WidgetTester tester) async {

    // Build the app
    await tester.pumpWidget(const FDiluFashionApp());

    // Verify MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
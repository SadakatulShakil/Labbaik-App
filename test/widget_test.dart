import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:labbaik_project/main.dart';

void main() {
  testWidgets('App launches to the placeholder splash', (tester) async {
    await tester.pumpWidget(const LabbaikApp());
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
  });
}

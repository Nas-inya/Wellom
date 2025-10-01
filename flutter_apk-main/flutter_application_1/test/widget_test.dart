// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../../lib/main.dart';
import '../../lib/providers/auth_provider.dart';
import '../../lib/screens/auth/login_screen.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify that login screen elements are present
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}

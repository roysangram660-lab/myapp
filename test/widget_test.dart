import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This will fail until firebase_options.dart is generated.
    await tester.pumpWidget(const MyApp());

    // Verify that the landing screen shows up with its title.
    // This is a basic check to ensure the app starts.
    expect(find.text('Welcome to UnityLink'), findsOneWidget);
  });
}

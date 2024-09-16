import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_and_activities_app/main.dart'; // Your main file
import 'package:event_and_activities_app/screens/welcome.dart'; // Your WelcomeScreen file

void main() {
  testWidgets('MyApp renders WelcomeScreen', (WidgetTester tester) async {
    // Build MyApp and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify if the WelcomeScreen is present in the widget tree.
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}

import 'package:event_and_activities_app/screens/home.dart';
import 'package:event_and_activities_app/screens/onboarding/onboarding3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastOnboarding renders correctly and navigates to Home',
      (WidgetTester tester) async {
    // Build the LastOnboarding widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: LastOnboarding(),
      ),
    );

    // Verify that the onboarding image is displayed.
    expect(find.byType(Image), findsOneWidget);

    // Check if the title and description are displayed.
    expect(find.text('Meet with new folks'), findsOneWidget);
    expect(
        find.textContaining('Never miss out with EasyFind!'), findsOneWidget);

    // Verify that the "Get Started" button is displayed.
    expect(find.text('Get Started'), findsOneWidget);

    // Tap on the "Get Started" button and navigate to the Home screen.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Ensure the Home screen is displayed after tapping "Get Started".
    expect(find.byType(Home), findsOneWidget);
  });
}

import 'package:event_and_activities_app/screens/onboarding/onboarding2.dart';
import 'package:event_and_activities_app/screens/onboarding/onboarding3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets(
      'SecondOnboarding renders correctly and navigates to LastOnboarding',
      (WidgetTester tester) async {
    // Build the SecondOnboarding widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: SecondOnboarding(),
      ),
    );

    // Verify that the onboarding image is displayed.
    expect(find.byType(Image), findsOneWidget);

    // Check if the title and description are displayed.
    expect(find.text('Fixed a Date for Event'), findsOneWidget);
    expect(
        find.textContaining('Stay in the loop with EasyFind!'), findsOneWidget);

    // Verify that the two SvgPictures (loading and next) are displayed.
    expect(find.byType(SvgPicture),
        findsNWidgets(2)); // One for the loader, one for the next button.

    // Tap on the "Next" button and navigate to the LastOnboarding.
    await tester.tap(find
        .byType(SvgPicture)
        .last); // The "Next" button is the second SvgPicture.
    await tester.pumpAndSettle();

    // Ensure the LastOnboarding screen is displayed.
    expect(find.byType(LastOnboarding), findsOneWidget);
  });
}

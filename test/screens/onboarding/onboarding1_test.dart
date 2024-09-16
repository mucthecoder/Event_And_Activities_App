import 'package:event_and_activities_app/screens/onboarding/onboarding2.dart';
import 'package:event_and_activities_app/screens/onboarding/onboarding1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets('FirstOnboarding renders images, text, and Next button',
      (WidgetTester tester) async {
    // Build the FirstOnboarding widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: FirstOnboarding(),
      ),
    );

    // Check for the onboarding image.
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Easy to find events'), findsOneWidget);
    expect(find.textContaining('Discover events effortlessly'), findsOneWidget);

    // Check that the "Next" button is present.
    expect(
        find.byType(SvgPicture),
        findsNWidgets(
            2)); // One for the loading image and one for the next button.

    // Tap on the "Next" button and verify navigation to the next onboarding screen.
    await tester.tap(find
        .byType(SvgPicture)
        .last); // The "Next" button is the second SvgPicture.
    await tester.pumpAndSettle();

    // Ensure the SecondOnboarding screen is displayed.
    expect(find.byType(SecondOnboarding), findsOneWidget);
  });
}

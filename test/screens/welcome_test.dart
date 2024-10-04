import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_and_activities_app/screens/welcome.dart'; // Import your WelcomeScreen
import 'package:event_and_activities_app/screens/onboarding/onboarding1.dart'; // Import FirstOnboarding

void main() {
  testWidgets('WelcomeScreen navigates to FirstOnboarding after delay',
          (WidgetTester tester) async {
        // Build the WelcomeScreen.
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeScreen(),
          ),
        );

        // Verify the initial widgets (you can check for images, text, etc.).
        expect(find.text('Eventos'), findsOneWidget);

        // Fast-forward time by 2 seconds to trigger the navigation.
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle(); // Let the navigation complete.

        // Verify that after 2 seconds, FirstOnboarding is pushed.
        expect(find.byType(FirstOnboarding), findsOneWidget);
      });

  testWidgets('WelcomeScreen displays the correct images',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: WelcomeScreen(),
          ),
        );

        // Verify if all the expected images are present in the widget tree.
        expect(find.byType(Image), findsNWidgets(5)); // Checks for all Image assets.

        // Verify specific image assets.
        expect(find.image(const AssetImage('assets/rectAllBlue.png')), findsOneWidget);
        expect(find.image(const AssetImage('assets/splash.png')), findsOneWidget);
        expect(find.image(const AssetImage('assets/rect24.png')), findsOneWidget);
        expect(find.image(const AssetImage('assets/wits1.png')), findsOneWidget);
        expect(find.image(const AssetImage('assets/secondBottomRect.png')), findsOneWidget);
      });
}

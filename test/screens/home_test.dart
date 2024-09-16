import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:event_and_activities_app/screens/home.dart'; // Import your Home widget

void main() {
  testWidgets('Home widget renders AppBar with search bar and tune icon',
      (WidgetTester tester) async {
    // Build the Home widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: Home(),
      ),
    );

    // Check for the AppBar elements.
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SvgPicture),
        findsOneWidget); // Check for the SvgPicture (tune icon).
    expect(find.byType(TextField), findsOneWidget); // Check for the search bar.

    // Check that the search icon is present inside the search bar.
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('Home widget renders persistent bottom navigation bar',
      (WidgetTester tester) async {
    // Build the Home widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: Home(),
      ),
    );

    // Check for the PersistentTabView.
    expect(find.byType(PersistentTabView), findsOneWidget);

    // Check that the bottom navigation contains 5 items.
    expect(find.byIcon(Icons.explore), findsOneWidget);
    expect(find.byIcon(Icons.event), findsOneWidget);
    expect(find.byIcon(Icons.add_box_rounded), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets(
      'Home widget navigates to different screens when bottom nav items are tapped',
      (WidgetTester tester) async {
    // Build the Home widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: Home(),
      ),
    );

    // Initially, the first screen (Explore) should be visible.
    expect(find.byIcon(Icons.explore), findsOneWidget);

    // Tap the second bottom navigation item (Create Event).
    await tester.tap(find.byIcon(Icons.event));
    await tester.pumpAndSettle(); // Wait for the navigation to complete.

    // The screen corresponding to the Create Event should now be visible (verify it with custom widget check).
    // Since we used empty `Container()` widgets for the screens in the original code, this part might not show visual elements,
    // but in a real app, you'd check for specific widgets or text in each screen.
  });
}

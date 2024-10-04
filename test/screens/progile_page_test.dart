import 'package:event_and_activities_app/screens/authentication/login_page.dart';
import 'package:event_and_activities_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // This will be run before every test
  setUp(() async {
    // Initialize SharedPreferences
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ProfilePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    // Verify that the profile picture, name, and email are displayed
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('johndoe@email.com'), findsOneWidget);

    // Check if buttons are rendered
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('My Events'), findsOneWidget);
    expect(find.text('My Tickets'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Logout dialog appears on logout tap', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    // Tap the logout ListTile
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Verify that the dialog appears
    expect(find.text('Are you sure you want to logout?'), findsOneWidget);
  });

  testWidgets('Logout clears SharedPreferences', (WidgetTester tester) async {
    final mockSharedPreferences = MockSharedPreferences();

    // Set up the mock to return a value for the clear method
    when(mockSharedPreferences.clear()).thenAnswer((_) async => true);
    SharedPreferences.setMockInitialValues({}); // Initialize SharedPreferences

    // Create a ProfilePage with the mock SharedPreferences
    await tester.pumpWidget(MaterialApp(
      home: ProfilePage(),
    ));

    // Tap the logout ListTile
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap the 'Yes' button to confirm logout
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle(); // Wait for the logout to process

    // Verify that clear() was called on SharedPreferences
    verify(mockSharedPreferences.clear()).called(1);
  });

  testWidgets('Logout navigates to LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    // Tap the logout ListTile
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Tap the 'Yes' button to confirm logout
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify that we are on the LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
  });
}

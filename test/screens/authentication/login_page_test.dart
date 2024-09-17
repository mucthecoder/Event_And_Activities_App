import 'package:event_and_activities_app/screens/authentication/forgot_password.dart';
import 'package:event_and_activities_app/screens/welcome.dart';
import 'package:event_and_activities_app/screens/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocking HTTP and SharedPreferences for testing purposes
class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LoginPage Tests', () {
    late MockHttpClient mockHttpClient;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockSharedPreferences = MockSharedPreferences();
    });

    // Helper method to pump the LoginPage widget
    Future<void> pumpLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );
    }

    testWidgets('Displays validation errors if email and password are empty',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Tap on the Login button without entering any data
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Check if validation errors are displayed
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Displays validation error for invalid email format',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap on the Login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Check for email validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Successful login navigates to WelcomeScreen',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Enter valid email and password
      await tester.enterText(
          find.byType(TextFormField).first, 'test@wits.ac.za');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Mock successful login response from server
      when(mockHttpClient.post(any as Uri,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('{"token": "valid_token"}', 201));

      // Tap on the Login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify if it navigates to the WelcomeScreen
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets('Failed login shows error message',
        (WidgetTester tester) async {
      await pumpLoginPage(tester);

      // Enter valid email and password
      await tester.enterText(
          find.byType(TextFormField).first, 'test@wits.ac.za');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');

      // Mock failed login response from server
      when(mockHttpClient.post(any as Uri,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async =>
              http.Response('{"error": "Invalid credentials"}', 400));

      // Tap on the Login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify if error message is shown
      expect(find.text('Login failed: Invalid credentials'), findsOneWidget);
    });
  });
}

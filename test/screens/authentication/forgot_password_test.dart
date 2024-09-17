import 'package:event_and_activities_app/screens/authentication/forgot_password.dart';
import 'package:event_and_activities_app/screens/authentication/verify_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';

// Mocking HTTP Client
class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  group('ForgotPasswordPage Tests', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    // Helper function to pump the ForgotPasswordPage widget
    Future<void> pumpForgotPasswordPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );
    }

    testWidgets('Displays validation error if email is empty',
        (WidgetTester tester) async {
      await pumpForgotPasswordPage(tester);

      // Tap on the "Send Reset Instruction" button without entering an email
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Expect validation error to be shown
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Displays validation error for invalid email format',
        (WidgetTester tester) async {
      await pumpForgotPasswordPage(tester);

      // Enter an invalid email address
      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Expect validation error to be shown
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets(
        'Displays success message and navigates to VerifyTokenScreen on success',
        (WidgetTester tester) async {
      await pumpForgotPasswordPage(tester);

      // Enter a valid email address
      await tester.enterText(find.byType(TextFormField), 'test@wits.ac.za');

      // Mock successful response from server
      when(mockHttpClient.post(any as Uri,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('{"message": "success"}', 200));

      // Tap on the "Send Reset Instruction" button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Expect success message and navigation
      expect(find.text('Password reset email sent'), findsOneWidget);
      expect(find.byType(VerifyTokenScreen), findsOneWidget);
    });

    testWidgets('Displays error message on failed password reset request',
        (WidgetTester tester) async {
      await pumpForgotPasswordPage(tester);

      // Enter a valid email address
      await tester.enterText(find.byType(TextFormField), 'test@wits.ac.za');

      // Mock failed response from server
      when(mockHttpClient.post(any as Uri,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response('{"error": "Email not found"}', 400));

      // Tap on the "Send Reset Instruction" button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Expect error message
      expect(find.text('Failed: Email not found'), findsOneWidget);
    });
  });
}

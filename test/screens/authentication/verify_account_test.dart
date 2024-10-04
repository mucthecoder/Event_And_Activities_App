import 'package:event_and_activities_app/screens/authentication/set_password.dart';
import 'package:event_and_activities_app/screens/authentication/verify_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Adjust with your actual file path

// Mocking the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('VerifyTokenScreen', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    testWidgets('displays token input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VerifyTokenScreen(email: 'test@example.com'),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('validates input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VerifyTokenScreen(email: 'test@example.com'),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Trigger a rebuild

      expect(find.text('Invalid or expired token'), findsNothing); // Initially should not show error
    });

    testWidgets('submits token and navigates on success', (WidgetTester tester) async {
      when(mockHttpClient.post(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/auth/reset-password/1234'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'userId': '1'}), 200));

      await tester.pumpWidget(
        MaterialApp(
          home: VerifyTokenScreen(email: 'test@example.com'),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), '1');
      await tester.enterText(find.byType(TextFormField).at(1), '2');
      await tester.enterText(find.byType(TextFormField).at(2), '3');
      await tester.enterText(find.byType(TextFormField).at(3), '4');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      expect(find.byType(SetNewPasswordScreen), findsOneWidget);
    });

    testWidgets('shows error message on failure', (WidgetTester tester) async {
      when(mockHttpClient.post(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/auth/reset-password/1234'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Invalid token', 400));

      await tester.pumpWidget(
        MaterialApp(
          home: VerifyTokenScreen(email: 'test@example.com'),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), '1');
      await tester.enterText(find.byType(TextFormField).at(1), '2');
      await tester.enterText(find.byType(TextFormField).at(2), '3');
      await tester.enterText(find.byType(TextFormField).at(3), '4');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Trigger a rebuild

      expect(find.text('Invalid or expired token'), findsOneWidget);
    });
  });
}

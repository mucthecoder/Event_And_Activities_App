import 'dart:convert';
import 'package:event_and_activities_app/screens/myEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // Initialize SharedPreferences Mock
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MyEvents displays loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyEvents()));

    // Verify that the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MyEvents displays no events message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyEvents()));

    // Simulate no events response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching events
    http.Client client = MockHttpClient();
    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/myevents'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response('[]', 200));

    // Run the fetch function
    await tester.pumpAndSettle();

    // Verify that no events message is displayed
    expect(find.text('No events found.'), findsOneWidget);
  });

  testWidgets('MyEvents displays event details', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences and HTTP response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching events
    http.Client client = MockHttpClient();
    final mockResponse = jsonEncode([
      {
        "_id": "1",
        "event_id": "event_1",
        "title": "Sample Event",
        "date": "2024-10-10",
        "start_time": "10:00",
        "end_time": "12:00",
        "location": "Event Location",
        "description": "Sample Description",
        "ticket_price": "10",
        "max_attendees": "100",
        "current_attendees": "50",
        "images": [],
        "isCancelled": false,
      },
    ]);

    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/myevents'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: MyEvents()));
    await tester.pumpAndSettle();

    // Verify that event details are displayed
    expect(find.text('Sample Event'), findsOneWidget);
    expect(find.text('Date: 2024-10-10'), findsOneWidget);
    expect(find.text('Location: Event Location'), findsOneWidget);
    expect(find.text('Price: \$10.00'), findsOneWidget);
  });

  testWidgets('MyEvents shows event cancelled message', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences and HTTP response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching events
    http.Client client = MockHttpClient();
    final mockResponse = jsonEncode([
      {
        "_id": "1",
        "event_id": "event_1",
        "title": "Cancelled Event",
        "date": "2024-10-10",
        "start_time": "10:00",
        "end_time": "12:00",
        "location": "Event Location",
        "description": "Sample Description",
        "ticket_price": "10",
        "max_attendees": "100",
        "current_attendees": "50",
        "images": [],
        "isCancelled": true, // This event is cancelled
      },
    ]);

    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/myevents'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: MyEvents()));
    await tester.pumpAndSettle();

    // Verify that cancelled event is not displayed
    expect(find.text('Cancelled Event'), findsNothing);
  });

  testWidgets('MyEvents handles error in fetching events', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching events
    http.Client client = MockHttpClient();
    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/myevents'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response('Error', 500));

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: MyEvents()));
    await tester.pumpAndSettle();

    // Verify that error handling works
    expect(find.text('Failed to load events'), findsOneWidget);
  });
}

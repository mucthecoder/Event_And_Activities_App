import 'dart:convert';
import 'package:event_and_activities_app/screens/myTickets.dart';
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

  testWidgets('myTickets displays loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: myTickets()));

    // Verify that the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('myTickets displays no tickets message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: myTickets()));

    // Simulate an empty tickets response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching tickets
    http.Client client = MockHttpClient();
    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/tickets'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response('[]', 200));

    // Run the fetchTickets function
    await tester.pumpAndSettle();

    // Verify that no tickets message is displayed
    expect(find.text('No tickets found.'), findsOneWidget);
  });

  testWidgets('myTickets displays ticket details', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences and HTTP response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching tickets
    http.Client client = MockHttpClient();
    final mockResponse = jsonEncode([
      {
        "_id": "1",
        "user_id": "user_1",
        "ticket_type": "VIP",
        "price": 100.0,
        "event_date": "2024-10-10T00:00:00Z",
        "stripe_payment_intent_id": "stripe_id_1",
        "payment_status": "Paid",
        "qr_code": "some_qr_code",
        "refund_status": "Not Requested",
        "used": null,
      },
    ]);

    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/tickets'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: myTickets()));
    await tester.pumpAndSettle();

    // Verify that ticket details are displayed
    expect(find.text('VIP - \$100.0'), findsOneWidget);
    expect(find.text('Event Date: 2024-10-10 00:00:00.000Z'), findsOneWidget);
    expect(find.text('Status: Paid'), findsOneWidget);
  });

  testWidgets('myTickets shows QR code dialog on QR icon press', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences and HTTP response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching tickets
    http.Client client = MockHttpClient();
    final mockResponse = jsonEncode([
      {
        "_id": "1",
        "user_id": "user_1",
        "ticket_type": "VIP",
        "price": 100.0,
        "event_date": "2024-10-10T00:00:00Z",
        "stripe_payment_intent_id": "stripe_id_1",
        "payment_status": "Paid",
        "qr_code": "some_qr_code",
        "refund_status": "Not Requested",
        "used": null,
      },
    ]);

    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/tickets'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: myTickets()));
    await tester.pumpAndSettle();

    // Press the QR code button
    await tester.tap(find.byIcon(Icons.qr_code));
    await tester.pumpAndSettle();

    // Verify that the QR code dialog is shown
    expect(find.text('Ticket ID: 1'), findsOneWidget);
  });

  testWidgets('myTickets handles fetch buses failure', (WidgetTester tester) async {
    // Setup the mock for SharedPreferences and HTTP response
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'test_token');

    // Mock the HTTP response for fetching tickets
    http.Client client = MockHttpClient();
    final mockResponse = jsonEncode([
      {
        "_id": "1",
        "user_id": "user_1",
        "ticket_type": "VIP",
        "price": 100.0,
        "event_date": "2024-10-10T00:00:00Z",
        "stripe_payment_intent_id": "stripe_id_1",
        "payment_status": "Paid",
        "qr_code": "some_qr_code",
        "refund_status": "Not Requested",
        "used": null,
      },
    ]);

    when(client.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/tickets'),
      headers: {'Authorization': 'Bearer test_token'},
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    when(client.get(
      Uri.parse('https://gateway.tandemworkflow.com/api/v1/bus-schedule/?date=2024-10-10T00:00:00Z'),
    )).thenAnswer((_) async => http.Response('[]', 404)); // Simulating failure

    // Run the widget test
    await tester.pumpWidget(MaterialApp(home: myTickets()));
    await tester.pumpAndSettle();

    // Check for a snackbar message or error handling
    expect(find.text('Failed to fetch buses'), findsOneWidget);
  });
}

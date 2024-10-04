import 'package:event_and_activities_app/screens/eventlisting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
 // Update with the correct import
import 'dart:convert';

// Mock class for the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('EventListingPage Tests', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    testWidgets('fetches and displays events', (WidgetTester tester) async {
      // Mock the response
      when(mockHttpClient.get(Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/')))
          .thenAnswer((_) async => http.Response(json.encode({
        'success': true,
        'data': [
          {
            'id': 1,
            'title': 'Event 1',
            'eventAuthor': 'Author 1',
            'description': 'Description 1',
            'location': 'Location 1',
            'startTime': '2024-10-01T10:00:00Z',
            'endTime': '2024-10-01T12:00:00Z',
            'date': '2024-10-01',
            'categories': ['Education'],
            'isPaid': false,
            'ticket_price': 0,
          },
          {
            'id': 2,
            'title': 'Event 2',
            'eventAuthor': 'Author 2',
            'description': 'Description 2',
            'location': 'Location 2',
            'startTime': '2024-10-02T14:00:00Z',
            'endTime': '2024-10-02T16:00:00Z',
            'date': '2024-10-02',
            'categories': ['Technology'],
            'isPaid': true,
            'ticket_price': 10.0,
          },
        ],
      }), 200));

      // Build the widget
      await tester.pumpWidget(MaterialApp(home: EventListingPage()));

      // Wait for the events to be fetched
      await tester.pumpAndSettle();

      // Verify if the events are displayed
      expect(find.text('Event 1'), findsOneWidget);
      expect(find.text('Event 2'), findsOneWidget);
    });

    testWidgets('displays error message on fetch failure', (WidgetTester tester) async {
     // when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      await tester.pumpWidget(MaterialApp(home: EventListingPage()));

      await tester.pumpAndSettle();

      expect(find.text('Error: Not Found'), findsOneWidget);
    });

    testWidgets('searches for events based on query', (WidgetTester tester) async {
      // Mock the initial fetch response
      when(mockHttpClient.get(Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/')))
          .thenAnswer((_) async => http.Response(json.encode({
        'success': true,
        'data': [
          {
            'id': 1,
            'title': 'Event 1',
            'eventAuthor': 'Author 1',
            'description': 'Description 1',
            'location': 'Location 1',
            'startTime': '2024-10-01T10:00:00Z',
            'endTime': '2024-10-01T12:00:00Z',
            'date': '2024-10-01',
            'categories': ['Education'],
            'isPaid': false,
            'ticket_price': 0,
          },
        ],
      }), 200));

      await tester.pumpWidget(MaterialApp(home: EventListingPage()));

      await tester.pumpAndSettle();

      // Simulate typing in the search field
      await tester.enterText(find.byType(TextField), 'Event 1');
      await tester.pumpAndSettle();

      // Verify that the correct event is displayed
      expect(find.text('Event 1'), findsOneWidget);
    });

    testWidgets('filters events by category', (WidgetTester tester) async {
      // Mock the fetch response for the 'Education' category
      when(mockHttpClient.get(Uri.parse('https://eventsapi3a.azurewebsites.net/api/events?category=Education')))
          .thenAnswer((_) async => http.Response(json.encode({
        'success': true,
        'data': [
          {
            'id': 1,
            'title': 'Event 1',
            'eventAuthor': 'Author 1',
            'description': 'Description 1',
            'location': 'Location 1',
            'startTime': '2024-10-01T10:00:00Z',
            'endTime': '2024-10-01T12:00:00Z',
            'date': '2024-10-01',
            'categories': ['Education'],
            'isPaid': false,
            'ticket_price': 0,
          },
        ],
      }), 200));

      await tester.pumpWidget(MaterialApp(home: EventListingPage()));

      // Simulate selecting a category
      await tester.tap(find.text('Education'));
      await tester.pumpAndSettle();

      // Verify that the filtered events are displayed
      expect(find.text('Event 1'), findsOneWidget);
    });
  });
}

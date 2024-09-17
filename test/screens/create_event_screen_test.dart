import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_and_activities_app/screens/create_event_screen.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    SharedPreferences.setMockInitialValues({
      'token': 'dummy_token',
      'userId': 'dummy_userId',
    });
  });

  testWidgets('should create a new event successfully',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNewEventPage(),
      ),
    );

    // Enter form data
    await tester.enterText(find.byKey(const Key('titleField')), 'Test Event');
    await tester.enterText(
        find.byKey(const Key('descriptionField')), 'Test Description');
    await tester.enterText(
        find.byKey(const Key('locationField')), 'Test Location');
    await tester.enterText(find.byKey(const Key('dateField')), '2024-09-25');

    // Simulate Dio's success response
    when(() => mockDio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/api/events/new'),
              statusCode: 201,
              data: {'message': 'Event created successfully'},
            ));

    // Tap the create button
    await tester.tap(find.text('CREATE'));
    await tester.pump(); // Rebuild the widget

    // Verify Dio's call
    verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);

    // Check for success message
    expect(find.text('Event created successfully'), findsOneWidget);
  });

  testWidgets('should fail to create a new event', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: CreateNewEventPage(),
      ),
    );

    // Enter form data
    await tester.enterText(find.byKey(const Key('titleField')), 'Test Event');
    await tester.enterText(
        find.byKey(const Key('descriptionField')), 'Test Description');
    await tester.enterText(
        find.byKey(const Key('locationField')), 'Test Location');
    await tester.enterText(find.byKey(const Key('dateField')), '2024-09-25');

    // Simulate Dio's failure response
    when(() => mockDio.post(any(), data: any(named: 'data')))
        .thenThrow(DioError(
      requestOptions: RequestOptions(path: '/api/events/new'),
      error: 'Failed to create event',
    ));

    // Tap the create button
    await tester.tap(find.text('CREATE'));
    await tester.pump(); // Rebuild the widget

    // Verify Dio's call
    verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);

    // Check for failure message
    expect(find.textContaining('Failed'), findsOneWidget);
  });
}

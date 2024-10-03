import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package for making requests
import 'package:shared_preferences/shared_preferences.dart';
import 'Event.dart';
import 'authentication/login_page.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({required this.event});

  // Function to cancel the event
  Future<void> cancelEvent(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final eventId = event.event_id; // Replace with the actual property for event ID
    final response = await http.patch(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/$eventId/cancel'),
      headers: {
        'Authorization': 'Bearer $token', // Replace with actual token if needed
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful cancellation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event cancelled successfully!')),
      );
      // Optionally, navigate back or refresh the event list
      Navigator.pop(context);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel event: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title and Date-Time
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${event.date} | ${event.startTime} - ${event.endTime}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),

              // Categories Section
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: event.categories.map((category) {
                  return Chip(
                    label: Text(category),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // About the Event
              Text(
                'About the Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(event.description),
              SizedBox(height: 16),

              // Location Section
              Text(
                'Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                event.location,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Get Ticket Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Get Ticket'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              // Cancel Event Button
              Center(
                child: ElevatedButton(
                  onPressed: () => cancelEvent(context),
                  child: Text('Cancel Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Change color to indicate cancellation
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

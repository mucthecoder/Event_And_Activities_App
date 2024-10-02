
import 'package:flutter/material.dart';


import 'Event.dart';
import 'authentication/login_page.dart';
// Add google_maps_flutter if you want to display a map
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailPage extends StatelessWidget {
  final Event event; // Assuming you have an Event model

  EventDetailPage({required this.event});

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

              // Organizer Section

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

              // Event Highlights (you can replace this with images, if required)
              Text(
                'Event Highlights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Explore some memorable moments and glimpses of what\'s to come at this event. '
                    'Take a look at our event highlights through these featured images.',
              ),
              SizedBox(height: 16),

              // Location and Map Section
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

              // Placeholder for a Map (Google Maps)


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
            ],
          ),
        ),
      ),
    );
  }
}


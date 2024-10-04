import 'package:event_and_activities_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Event> collection = [];

  @override
  void initState() {
    super.initState();
    getMine(); // Fetch events when the widget is initialized
  }

  Future<void> getMine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var response1 = await http.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/myevents'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response1.statusCode == 200) {
      var data1 = jsonDecode(response1.body);

      setState(() {
        for (int i = 0; i < data1.length; i++) {
          if (data1[i]['isCancelled'].toString() == 'true') {
            continue;
          }
          Event something = Event(
            date: data1[i]['date']?.toString() ?? '',
            start: data1[i]['start_time']?.toString() ?? '',
            end: data1[i]['end_time']?.toString() ?? '',
            location: data1[i]['location']?.toString() ?? '',
            title: data1[i]['title']?.toString() ?? '',
            id: data1[i]['_id']?.toString() ?? '',
            eventId: data1[i]['event_id']?.toString() ?? '',
            description: data1[i]['description']?.toString() ?? '',
            price: data1[i]['ticket_price']?.toString() ?? '0',
            maxAttendees: data1[i]['max_attendees']?.toString() ?? '0',
            currentAttendees: data1[i]['current_attendees']?.toString() ?? '0',
          );

          if (data1[i]['images'] != null) {
            for (int j = 0; j < data1[i]['images'].length; j++) {
              something.images.add(data1[i]['images'][j]);
            }
          }

          collection.add(something);
        }
      });
    } else {
      print('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body: collection.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: collection.length,
        itemBuilder: (context, index) {
          return EventTile(
            title: collection[index].title,
            date: collection[index].date,
            location: collection[index].location,
            isPaid: collection[index].price != '0',
            price: double.parse(collection[index].price),
          );
        },
      ),
    );
  }
}

class Event {
  String start;
  String end;
  String date;
  String title;
  String id;
  String eventId;
  String location;
  String description;
  String price;
  String maxAttendees;
  String currentAttendees;
  List<String> images = [];

  Event({
    required this.date,
    required this.start,
    required this.end,
    required this.location,
    required this.title,
    required this.id,
    required this.eventId,
    required this.description,
    required this.price,
    required this.maxAttendees,
    required this.currentAttendees,
  });
}

class EventTile extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final bool isPaid;
  final double price;

  const EventTile({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.isPaid,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds a shadow to the card
      margin: const EdgeInsets.all(10), // Margin around the card
      child: Padding(
        padding: const EdgeInsets.all(16), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Space between title and the rest

            // Date and Location Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $date',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  'Location: $location',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8), // Space between rows

            // Price or Free Event
            Text(
              isPaid ? 'Price: \$${price.toStringAsFixed(2)}' : 'Free Event',
              style: TextStyle(
                fontSize: 14,
                color: isPaid ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:event_and_activities_app/screens/Eventspecifics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Event.dart';
import 'dart:convert';

class EventService {
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List).map((eventJson) => Event.fromJson(eventJson)).toList();
      } else {
        throw Exception('Failed to load events: ${data['message'] ?? "Unknown error"}');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> searchEvents(String query) async {
    final response = await http.get(Uri.parse(
        'https://eventsapi3a.azurewebsites.net/api/events/search?query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else {
        throw Exception('Failed to load events: ${data['message'] ?? "Unknown error"}');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> fetchEventsByCategory(String category) async {
    final response = await http.get(Uri.parse(
        'https://eventsapi3a.azurewebsites.net/api/events?category=$category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();
      } else {
        throw Exception('Failed to load events: ${data['message'] ?? "Unknown error"}');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }
}

class EventListingPage extends StatefulWidget {
  @override
  _EventListingPageState createState() => _EventListingPageState();
}

class _EventListingPageState extends State<EventListingPage> {
  late Future<List<Event>> futureEvents;
  String searchQuery = '';
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    futureEvents = EventService().fetchEvents(); // Initially fetch all events
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      futureEvents = EventService().searchEvents(query); // Fetch events based on the search query
    });
  }

  void onCategorySelect(String category) {
    setState(() {
      selectedCategory = category;
      futureEvents = EventService().fetchEventsByCategory(category); // Fetch events by category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: onSearch, // Call the search function on input change
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
            //  backgroundImage: AssetImage('assets/wits.png'), // Replace with your image
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter Section
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryButton(categoryName: 'Education', onCategorySelect: onCategorySelect),
                CategoryButton(categoryName: 'Technology', onCategorySelect: onCategorySelect),
                CategoryButton(categoryName: 'Health', onCategorySelect: onCategorySelect),
                CategoryButton(categoryName: 'Art', onCategorySelect: onCategorySelect),
                CategoryButton(categoryName: 'Music', onCategorySelect: onCategorySelect),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Event List Section
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: futureEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No events found.'));
                }

                final events = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust to your layout preference
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7, // Aspect ratio to match the image proportions
                  ),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String categoryName;
  final Function(String) onCategorySelect;

  CategoryButton({required this.categoryName, required this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onCategorySelect(categoryName); // Call the filter function with the selected category
        },
        child: Text(categoryName),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle the event when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                event.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),

              // Event Author
              Text(
                'Author: ${event.eventAuthor}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              SizedBox(height: 4),

              // Event Description
              Text(
                '${event.description}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              SizedBox(height: 4),

              // Event Location
              Text(
                '${event.location}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              SizedBox(height: 4),

              // Event Start-End Time
              Text(
                'Time: ${event.startTime} - ${event.endTime}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              // Event Date
              Text(
                'Date: ${event.date}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              // Event Categories
              Text(
                'Categories: ${event.categories.join(", ")}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              SizedBox(height: 8),

              // Event Paid/Free Indicator
              Text(
                event.isPaid ? 'Paid Event' : 'Free Event',
                style: TextStyle(
                  fontSize: 12,
                  color: event.isPaid ? Colors.red : Colors.green,
                ),
              ),


              SizedBox(height: 8,),

              Text(
                'Ticket Price: ${event.ticket_price}',
                style: TextStyle(
                  fontSize: 12,

                ),
              ),

              SizedBox(height: 8),

              // Buy Ticket or Get Ticket Button
              ElevatedButton(
                onPressed: ()  async{
                  // Add action for buy or get ticket
                  if (event.isPaid) {
                    // Logic for buying a ticket
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Redirecting to purchase tickets...'),
                    ));
                    // Navigate to the ticket purchase page (if any)
                  } else {
                    await getTicket(eventId: event.event_id, context: context);



                    // Logic for getting a free ticket
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your free ticket is available!'),
                    ));
                    // Perform action for free ticket
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: event.isPaid ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(event.isPaid ? 'Buy Ticket' : 'Get Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Function to fetch ticket
Future<void> getTicket({required String eventId, required BuildContext context}) async {
  print("getTicket called with eventId: $eventId"); // Debug print
  try {
    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("Retrieved Token: $token");

    // Check if the token is null
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token is null, please log in again.')),
      );
      return; // Exit the function early if there's no token
    }

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/ticket/$eventId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final ticketData = json.decode(response.body);
      print("Ticket data: $ticketData"); // Debug print

      // Optional: Validate ticketData structure
      if (ticketData['success']) {
        // Process ticket data here
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${ticketData['message']}')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket retrieved successfully!')),
      );
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unauthorized: Please log in again.')),
      );
    } else {
      print('Error fetching ticket: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching ticket: ${response.body}')),
      );
    }
  } catch (error) {
    print('Exception occurred: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch ticket: $error')),
    );
  }
}


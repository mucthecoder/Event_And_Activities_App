import 'dart:convert';
import 'package:event_and_activities_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import the QR code package

class myTickets extends StatefulWidget {
  const myTickets({super.key});

  @override
  _myTicketsState createState() => _myTicketsState();
}

class _myTicketsState extends State<myTickets> {
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  bool loadBuses=false;
  List<String> busses=[];
  Map<String, List<String>> ticketBuses = {};
  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found. Please log in.')),
      );
      return;
    }

    var response = await http.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/tickets'), // Adjust to your API endpoint
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _tickets = data.map((ticketJson) => Ticket.fromJson(ticketJson)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tickets.')),
      );
    }
    fetchBusses();
  }

  Future<void> fetchBusses() async {

    ticketBuses.clear();

    for (var ticket in _tickets) {
      String targetDate = ticket.eventDate.toString();

      var response = await http.get(
        Uri.parse('https://gateway.tandemworkflow.com/api/v1/bus-schedule/?date=$targetDate'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // If no buses are available, add a message
        List<String> busesForTicket = data.isEmpty
            ? ["No buses at this time"]
            : data.map<String>((bus) => bus['routeName'].toString()).toList();

        // Store in the dictionary using ticket ID or eventId as the key
        ticketBuses[ticket.eventId] = busesForTicket;
      } else {
        // If fetching failed, store the error message
        ticketBuses[ticket.eventId] = ["Failed to fetch buses"];
      }
    }
    print("done");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tickets.isEmpty
          ? Center(child: Text('No tickets found.'))
          : ListView.builder(
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return Card(
            child: ListTile(
              title: Text('${ticket.ticketType} - \$${ticket.price}'),
              subtitle: Text('Event Date: ${ticket.eventDate} \nStatus: ${ticket.paymentStatus}'),
              onLongPress: () {
                // Ensure buses are fetched before showing the dialog
                if (!ticketBuses.containsKey(ticket.eventId)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buses not yet fetched for this ticket.')),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setStateDialog) {
                        List<String> busesForTicket = ticketBuses[ticket.eventId]!;

                        return AlertDialog(
                          title: Text('Available Buses:'),
                          content: SizedBox(
                            height: 100,
                            width: 200,
                            child: busesForTicket.isEmpty
                                ? const Center(child: Text('No buses at this time'))
                                : ListView.builder(
                              itemCount: busesForTicket.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(busesForTicket[index]),
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }
              ,
              trailing: IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () {
                  // Display QR Code for ticket ID
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Ticket ID: ${ticket.eventId}'),
                      content: SizedBox(
                        height: 200,
                        width: 200,
                        child:Center(
                          child: QrImageView(
                            data: ticket.eventId, // Use ticket ID for QR code
                            version: QrVersions.auto,
                            size: 200.0,

                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class Ticket {
  final String eventId;
  final String userId;
  final String ticketType;
  final double price;
  final DateTime eventDate;
  final String stripePaymentIntentId;
  final String paymentStatus;
  final String? qrCode;
  final String refundStatus;
  final DateTime? used;

  Ticket({
    required this.eventId,
    required this.userId,
    required this.ticketType,
    required this.price,
    required this.eventDate,
    required this.stripePaymentIntentId,
    required this.paymentStatus,
    this.qrCode,
    required this.refundStatus,
    this.used,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      eventId: json['_id'], // Make sure this matches the ID in your data
      userId: json['user_id'],
      ticketType: json['ticket_type'],
      price: json['price'].toDouble(),
      eventDate: DateTime.parse(json['event_date']),
      stripePaymentIntentId: json['stripe_payment_intent_id']?.toString() ?? '',
      paymentStatus: json['payment_status'],
      qrCode: json['qr_code'],
      refundStatus: json['refund_status'],
      used: json['used'] != null ? DateTime.parse(json['used']) : null,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewEventPage extends StatefulWidget {
  const CreateNewEventPage({super.key});

  @override
  _CreateNewEventPageState createState() => _CreateNewEventPageState();
}

class _CreateNewEventPageState extends State<CreateNewEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _maxAttendeesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(); // Added date controller

  DateTime? _startTime;
  DateTime? _endTime;
  bool _isPaid = false;
  String? _category; // Category handled via dropdown
  List<String> images = []; // Placeholder for images list

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Format DateTime to String as YYYY-MM-DD
  String? _formatDate(DateTime? dateTime) {
    if (dateTime == null) return null;
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Future<void> createEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Fetch the stored token
    String? userId = prefs.getString('userId'); // Fetch the stored user_id if available
    print("Token: $token");
    print("User ID: $userId");
    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User information not found. Please log in again.')),
      );
      return;
    }

    // Prepare event data
    final eventData = {
      //"user_id": userId, // Include the user_id
      "title": _titleController.text,
      "description": _descriptionController.text,
      "location": _locationController.text,
      "start_time": _startTime?.toIso8601String(),
      "end_time": _endTime?.toIso8601String(),
      "date": _dateController.text, // Ensure this is in YYYY-MM-DD format
      "is_paid": _isPaid,
      "ticket_price": _isPaid ? double.tryParse(_ticketPriceController.text) ?? 0 : 0,
      "max_attendees": int.tryParse(_maxAttendeesController.text) ?? 0,
      "images": images,
      "category": _category != null ? [_category!] : [], // Ensure category is an array
    };

    try {
      final response = await Dio().post(
        'https://eventsapi3a.azurewebsites.net/api/events/new',
        data: eventData,
      );

      print('Response: ${response.data}');
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
      } else {
        print('Response Data: ${response.data}');
        print('Response Headers: ${response.headers}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        // Log more detailed error information
        print('Error Status: ${e.response?.statusCode}');
        print('Error Data: ${e.response?.data}');
        print('Error Headers: ${e.response?.headers}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text('Create New Event'),
        actions: [
          TextButton(
            onPressed: createEvent,
            child: const Text(
              'CREATE',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              ),
              TextFormField(
                controller: _dateController, // Added date field
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Please enter a date' : null,
              ),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select start time'
                    : 'Start Time: ${_formatDate(_startTime!)}'),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: Text(_endTime == null
                    ? 'Select end time'
                    : 'End Time: ${_formatDate(_endTime!)}'),
                onTap: () => _selectDateTime(context, false),
              ),
              SwitchListTile(
                title: const Text('Is Paid'),
                value: _isPaid,
                onChanged: (value) {
                  setState(() {
                    _isPaid = value;
                  });
                },
              ),
              if (_isPaid)
                TextFormField(
                  controller: _ticketPriceController,
                  decoration: const InputDecoration(labelText: 'Ticket Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  _isPaid && value!.isEmpty ? 'Please enter ticket price' : null,
                ),
              TextFormField(
                controller: _maxAttendeesController,
                decoration: const InputDecoration(labelText: 'Max Attendees'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Please enter maximum attendees' : null,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Music', 'Art', 'Business']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

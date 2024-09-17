import 'package:flutter/material.dart';

import '../widget/event_bottom_sheet.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  void initState() {
    super.initState();
    // Show the modal after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCreateEventModal(context);
    });
  }

  // Function to show the bottom sheet
  void _showCreateEventModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const CreateEventForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event Screen'),
      ),
      body: const Center(
        child: Text('This is the screen where the modal opens automatically'),
      ),
    );
  }
}

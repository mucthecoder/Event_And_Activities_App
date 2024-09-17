import 'package:flutter/material.dart';

class CreateEventForm extends StatelessWidget {
  const CreateEventForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create New Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your "Next" button action here
                  },
                  child: Text('NEXT'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add title',
                labelStyle: TextStyle(fontSize: 24, color: Colors.blue),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add description',
                prefixIcon: Icon(Icons.description),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionItem(Icons.image, 'Add cover photo'),
            _buildActionItem(Icons.calendar_today, 'Date and time'),
            _buildActionItem(Icons.location_on, 'Add location'),
            _buildActionItem(Icons.people, 'Invite people'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper widget to build list items like "Add cover photo"
  Widget _buildActionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

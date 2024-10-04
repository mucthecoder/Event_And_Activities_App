import 'package:event_and_activities_app/screens/authentication/login_page.dart';
import 'package:event_and_activities_app/screens/myEvents.dart';
import 'package:event_and_activities_app/screens/myTickets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'dummy.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  Future<void> logout() async {
    try {
      var response = await http.post(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/auth/logout'),
        body: jsonEncode({}),
        headers: {
          'Authorization': 'Bearer your_token_here', // Include token if required
        },
      );

      if (response.statusCode == 200) {
        // Clear local storage after successful logout
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();  // Removes all data stored
        print("Successfully logged out");
      } else {
        print("Error logging out: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.png'), // Add a profile picture
              ),
            ),
            const SizedBox(height: 20),
            // Name
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Email
            const Text(
              'johndoe@email.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Edit Profile button
            ElevatedButton.icon(
              onPressed: () {
                // Handle profile editing
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Settings or options
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Settings Page
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dummy()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('My Events'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Settings Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyEvents()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('My Tickets'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Settings Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => myTickets()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle logout action
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LoginPage()), // Replace `Dummy` with your login page or another post-logout page
                                    (route) => false, // Clears the navigation stack
                              );
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}

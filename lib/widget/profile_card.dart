import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    AssetImage('assets/group.jpeg'), // Replace with your image
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'mastermind',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '2628628@students.wis.ac.za',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
          _buildListItem(
            icon: Icons.person_outline,
            text: 'My Profile',
            onTap: () {
              // Add navigation or action here
            },
          ),
          _buildListItem(
            icon: Icons.settings_outlined,
            text: 'Settings',
            onTap: () {
              // Add navigation or action here
            },
          ),
          _buildListItem(
            icon: Icons.notifications_outlined,
            text: 'Notification',
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            onTap: () {
              // Add action if needed
            },
          ),
          _buildListItem(
            icon: Icons.logout,
            text: 'Log Out',
            onTap: () {
              // Add logout action here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String text,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}

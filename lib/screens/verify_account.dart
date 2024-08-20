import 'package:event_and_activities_app/screens/set_password.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyTokenScreen extends StatelessWidget {
  final String token;

  VerifyTokenScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Token')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await verifyToken(token, context);
          },
          child: Text('Verify Token'),
        ),
      ),
    );
  }

  Future<void> verifyToken(String token, BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/auth/reset-password/$token'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userId = data['userId'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetNewPasswordScreen(userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid or expired token')),
      );
    }
  }

}

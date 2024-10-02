import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'set_password.dart';

class VerifyTokenScreen extends StatefulWidget {
  final String email;

  const VerifyTokenScreen({super.key, required this.email});

  @override
  _VerifyTokenScreenState createState() => _VerifyTokenScreenState();
}

class _VerifyTokenScreenState extends State<VerifyTokenScreen> {
  final TextEditingController _token1Controller = TextEditingController();
  final TextEditingController _token2Controller = TextEditingController();
  final TextEditingController _token3Controller = TextEditingController();
  final TextEditingController _token4Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> verifyToken(BuildContext context) async {
    String token = _token1Controller.text +
        _token2Controller.text +
        _token3Controller.text +
        _token4Controller.text;

    try {
      final response = await http.post(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/auth/reset-password/$token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
        }),
      );

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
          const SnackBar(content: Text('Invalid or expired token')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTokenBox(_token1Controller),
                  _buildTokenBox(_token2Controller),
                  _buildTokenBox(_token3Controller),
                  _buildTokenBox(_token4Controller),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    verifyToken(context);
                  }
                },
                child: const Text('Verify Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenBox(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "", // Hide character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}

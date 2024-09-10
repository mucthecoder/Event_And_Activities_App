import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'set_password.dart';

class VerifyTokenScreen extends StatefulWidget {
  final String email;

  VerifyTokenScreen({required this.email});

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }



  void _moveFocus(BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode1 = FocusNode();
    final FocusNode _focusNode2 = FocusNode();
    final FocusNode _focusNode3 = FocusNode();
    final FocusNode _focusNode4 = FocusNode();

    return Scaffold(
      appBar: AppBar(title: Text('Verify Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTokenBox(_token1Controller, _focusNode1, context, _focusNode2),
                  _buildTokenBox(_token2Controller, _focusNode2, context, _focusNode3),
                  _buildTokenBox(_token3Controller, _focusNode3, context, _focusNode4),
                  _buildTokenBox(_token4Controller, _focusNode4, context, null),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    verifyToken(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Verify Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenBox(TextEditingController controller, FocusNode currentNode, BuildContext context, FocusNode? nextNode) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: controller,
        focusNode: currentNode,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "", // Hide the character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextNode != null) {
            _moveFocus(context, currentNode, nextNode);
          }
        },
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

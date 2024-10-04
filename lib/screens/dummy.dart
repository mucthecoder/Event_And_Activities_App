import 'package:event_and_activities_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class Dummy extends StatefulWidget {
  const Dummy({super.key});

  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  File? _image;
  bool _isUploading = false; // Track upload status

  // Pick image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // You can switch this to ImageSource.camera to allow camera capture
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Azure Blob Storage
  Future<void> _uploadImageToAzure() async {
    if (_image == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('No image selected')),
      // );
      return;
    }

    const String storageAccount = "ritanzwe";
    const String containerName = "event";
    const String sasToken = "sp=r&st=2024-10-04T02:32:46Z&se=2025-03-28T10:32:46Z&spr=https&sv=2022-11-02&sr=c&sig=PpJcSRDkZP90ZajToUMX5ks5VpsRq7l7kz8nTpDxcdc%3D";

    String fileName = basename(_image!.path);
    String uploadUrl = "https://$storageAccount.blob.core.windows.net/$containerName/$fileName?$sasToken";

    try {
      setState(() {
        _isUploading = true; // Set uploading status
      });

      // Prepare the file
      final fileBytes = await _image!.readAsBytes();
      String mimeType = lookupMimeType(fileName) ?? 'application/octet-stream'; // Get MIME type dynamically

      // Send a PUT request to upload the image
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': mimeType,
        },
        body: fileBytes,
      );

      if (response.statusCode == 201) {
        print('Upload successful!');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Image uploaded to Azure successfully!')),
        // );
      } else {
        print('Upload failed: ${response.statusCode}, Response: ${response.body}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        // );
      }
    } catch (e) {
      print('Error uploading image: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error uploading image: $e')),
      // );
    } finally {
      setState(() {
        _isUploading = false; // Reset uploading status
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/profile.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            // Name
            const Center(
              child: Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Email
            const Center(
              child: Text(
                'johndoe@email.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Pick Image Button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Upload Image Button
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadImageToAzure, // Disable while uploading
              icon: _isUploading ? CircularProgressIndicator() : const Icon(Icons.cloud_upload),
              label: const Text('Upload to Azure'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

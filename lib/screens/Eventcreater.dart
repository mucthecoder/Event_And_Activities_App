
import 'dart:typed_data';
import 'package:event_and_activities_app/screens/eventlisting.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewEventPage extends StatefulWidget {
  const CreateNewEventPage({super.key});

  @override
  _CreateNewEventPageState createState() => _CreateNewEventPageState();
}

class _CreateNewEventPageState extends State<CreateNewEventPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  bool isLoading = false; // For loading indicator
  bool isAvailable=false;
  String title = '';
  String description = '';
  String location = '';
  String date = '';
  String startTime = '';
  String endTime = '';
  bool isPaid = false;
  String ticketPrice = '';
  String maxAttendees = '';
  bool foodStalls = false;
  String? category2;
  var catMap={};
  List<String> catIds=[];
  List<String> categories=["Education","Technology","Health","Art","Music"];
  Future<void> createEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // If token is null, show an error and return
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Authentication token not found. Please log in.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true; // Show loading indicator
      });
      
//================================
      var loginBody = {
        "title": title,
        "description": description,
        "location":location,
        "date":date,
        "startTime":startTime,
        "endTime":endTime,
        "isPaid":isPaid.toString(),
        "category":[{"_id":catMap[category2.toString()]}],
        "ticketPrice":ticketPrice,
        "maxAttendees":maxAttendees,
        "food_stalls":foodStalls.toString()
      };
      print(loginBody);
      int res=await checkAvailability(location, date, startTime, endTime);
      //return value of 1 means unavailable
      //return value of 2 means booked
      //return value of 0 means available
      //return value of -1 means error
      print("Checking availability");
      if (res==-1){
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error checking availability')));
        return;
      }
      else if(res==1){
        setState(() {
          isLoading = false;
        });
        //unavailable
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create event, Venue Unavailable')));

        return;
      }
      else if (res==2){
        setState(() {
          isLoading = false;
        });
        //booked
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venue Reserved at this time,Check schedule')));
        return;
      }
      else if (res==0){
        //available
        print("Event created successfully");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venue available, Creating event')));
      }
      //print("Venue available");
      var response = await http.post(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/new-no-image'),
        body: jsonEncode(loginBody),
        headers: {'Content-Type': 'application/json','Authorization':'Bearer $token'},
      );
      //===========================================

      //var response = await request.send();

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event created successfully!')));
        var data = jsonDecode(response.body);
        //print(data);
        var him=data["id"];
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // if (_images != null && _images!.isNotEmpty) {
        //   var uri = Uri.parse('https://eventsapi3a.azurewebsites.net/api/events/add-image/$him');
        //   var request = http.MultipartRequest('POST', uri);
        //   request.headers['Authorization'] = 'Bearer $token'; // Set the token
        //
        //   try {
        //     var firstImage = _images?[0]; // Get the first image
        //     Uint8List bytes = await firstImage!.readAsBytes(); // Read the image as bytes
        //
        //     if (kIsWeb) {
        //       // Web: Read image as bytes and add to request
        //       request.files.add(http.MultipartFile.fromBytes(
        //         'image',
        //         bytes,
        //         filename: firstImage.path.split('/').last, // Extract filename from path
        //       ));
        //     } else {
        //       // Mobile: Use image path
        //       request.files.add(await http.MultipartFile.fromPath('image', firstImage.path));
        //     }
        //
        //     var response = await request.send();
        //
        //     if (response.statusCode == 200) {
        //       // If the server returns a 200 OK response
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('Image uploaded successfully!')),
        //       );
        //     } else {
        //       // Handle server response errors
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('Failed to upload image. Status: ${response.statusCode}')),
        //       );
        //     }
        //   } catch (e) {
        //     // Handle any errors during image reading or the HTTP request
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('Error during upload: $e')),
        //     );
        //   }
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('No images selected!')),
        //   );
        // }
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventListingPage()),
        );


      } else {
        // Error: read the response body for more details
        print("Something went wrong");
        //String responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event')));
      }
    }
  }
  //189
  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> getCategories() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response1 = await http.get(
      Uri.parse('https://eventsapi3a.azurewebsites.net/api/category'),
      headers: {'Authorization':'Bearer $token'},
    );

    var data1=jsonDecode(response1.body);
    //print(data1);
    if (data1.length>0){
      categories.clear();
      catIds.clear();
    }
    categories = data1.map<String>((category) => category['name'].toString()).toList();
    catIds=data1.map<String>((category) => category['_id'].toString()).toList();
    for (var i=0;i<catIds.length;i++){
      catMap[categories[i]]=catIds[i];
    }
  }
  Future<int> checkAvailability(String target,String date,String start,String end) async{
    //return value of 1 means unavailable
    //return value of 2 means booked
    //return value of 0 means available
    //return value of -1 means error
    try{
      var response1 = await http.get(
        Uri.parse(
            'https://group2afunctionapp.azurewebsites.net/api/getVENUE?code=lVPnP4OFOCMQEJe3ZcIOQfywgWO9Ag5WtiixpUIwv340AzFuYZT3dQ%3D%3D'),
      );
      if (response1.statusCode != 200) {
        throw Exception("Failed to fetch venue data.");
      }
      //works
      var data1 = jsonDecode(response1.body);
      Map<String, dynamic> temp = {};
      for (int i = 0; i < data1.length; i++) {
        temp[data1[i]["VENUE_ID"].toString()] =
            data1[i]["VENUE_NAME"].toString();
        if (target == data1[i]["VENUE_NAME"].toString() &&
            data1[i]["VENUE_STATUS"].toString() == "Unavailable") {
          return 1;
        }
      }

      var response2 = await http.get(
        Uri.parse(
            'https://group2afunctionapp.azurewebsites.net/api/getSCHEDULE?code=tFdF0OUbZjKmNgrFFKDjQmhS4c0Pi5cFr6NmzDtk6dq6AzFuDIQCQA%3D%3D'),
      );
      if (response2.statusCode != 200) {
        throw Exception("Failed to fetch 2A schedule data.");
      }
      var data2 = jsonDecode(response2.body);
      //to be determined
      //has fields schedule_id venue_id date start_time end_time event_time
      for (int i = 0; i < data2.length; i++) {
        String venueName = temp[data2[i]['VENUE_ID'].toString()] ?? '';
        if (target == venueName && date == data2[i]['DATE'].toString()) {
          String bookedStart = data2[i]['START_TIME'].toString();
          String bookedEnd = data2[i]['END_TIME'].toString();

          if ((start.compareTo(bookedStart) >= 0 &&
                  start.compareTo(bookedEnd) < 0) ||
              (end.compareTo(bookedStart) > 0 &&
                  end.compareTo(bookedEnd) <= 0) ||
              (start.compareTo(bookedStart) <= 0 &&
                  end.compareTo(bookedEnd) >= 0)) {
            return 2;
          }
        }
      }
      var response3 = await http.get(
        Uri.parse('https://eventsapi3a.azurewebsites.net/api/events'),
      );
      if (response3.statusCode != 200) {
        throw Exception("Failed to fetch our schedule data.");
      }
      //works
      var data3 = jsonDecode(response3.body);
      data3 = data3["data"];
      for (int i = 0; i < data3.length; i++) {
        if (target == data3[i]['location'].toString() &&
            date == data3[i]['date'].toString()) {
          String eventStart = data3[i]['startTime'].toString();
          String eventEnd = data3[i]['endTime'].toString();
          if ((start.compareTo(eventStart) >= 0 &&
                  start.compareTo(eventEnd) < 0) ||
              (end.compareTo(eventStart) > 0 && end.compareTo(eventEnd) <= 0) ||
              (start.compareTo(eventStart) <= 0 &&
                  end.compareTo(eventEnd) >= 0)) {
            return 2;
          }
        }
      }
      //available
      return 0;
    }
    catch(error){
      print("Error: $error");
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    getCategories();
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter event title' : null,
                  onSaved: (value) => title = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter event description' : null,
                  onSaved: (value) => description = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter location' : null,
                  onSaved: (value) => location = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date (DD/MM/YYYY)'),
                  validator: (value) => value!.isEmpty ? 'Enter date' : null,
                  onSaved: (value) => date = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter start time' : null,
                  onSaved: (value) => startTime = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'End Time (HH:MM)'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter end time' : null,
                  onSaved: (value) => endTime = value!,
                ),
                DropdownButton<String>(
                  hint:Text("Select Category"),
                  value:category2,
                  items:categories
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged:(String? newValue){
                    setState((){
                      category2=newValue;
                    });
                  },

                ),
                SwitchListTile(
                  title: Text('Is the event paid?'),
                  value: isPaid,
                  onChanged: (val) {
                    setState(() {
                      isPaid = val;
                    });
                  },
                ),
                if (isPaid)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Ticket Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    isPaid && (value == null || value.isEmpty)
                        ? 'Enter ticket price'
                        : null,
                    onSaved: (value) => ticketPrice = value!,
                  ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Max Attendees'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => maxAttendees = value ?? '',
                ),
                SwitchListTile(
                  title: Text('Food Stalls Available?'),
                  value: foodStalls,
                  onChanged: (val) {
                    setState(() {
                      foodStalls = val;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Pick Images'),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: createEvent,
                  child: Text('Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

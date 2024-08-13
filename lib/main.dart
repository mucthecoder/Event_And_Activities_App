import 'package:flutter/material.dart';
import 'package:event_and_activities_app/screens/welcomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eventos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WelcomePage());
  }
}

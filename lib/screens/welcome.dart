import 'package:flutter/material.dart';

import 'login_page.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
       appBar:   AppBar(
           title: const Text("ONE FOR ALL NIGGAS"),
         titleSpacing: 2,
         centerTitle: true,
         backgroundColor: Colors.white,
         elevation: 0,



         ),




      body: Center(
      child: Image.asset('assets/group.jpeg'),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
        Colors.amberAccent;
        const Text('press me clown');
      }),


    );



  }
}

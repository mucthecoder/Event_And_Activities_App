import 'package:event_and_activities_app/screens/home.dart';
import 'package:event_and_activities_app/screens/onboarding/onboarding2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../authentication/login_page.dart';

class LastOnboarding extends StatefulWidget {
  const LastOnboarding({super.key});

  @override
  State<StatefulWidget> createState() => _LastOnboarding();
}

class _LastOnboarding extends State<LastOnboarding>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(seconds: 2), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginPage()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color(0xF7F8FAff),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 7,
            ),
            Image.asset(
              'assets/onboard3.png',
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: screenHeight / 40),
            Text(
              'Meet with new folks',
              style: TextStyle(
                fontSize: screenWidth / 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Text(
              'Never miss out with EasyFind! Set your preferences, and we’ll bring the best events right to you.',
              style: TextStyle(
                fontSize: screenWidth / 22,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight / 30),
            Container(
              width: screenWidth / 1.1,
              height: screenHeight / 15,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: screenWidth / 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

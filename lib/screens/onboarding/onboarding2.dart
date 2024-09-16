import 'package:event_and_activities_app/screens/onboarding/onboarding3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../authentication/login_page.dart';

class SecondOnboarding extends StatefulWidget {
  const SecondOnboarding({super.key});

  @override
  State<StatefulWidget> createState() => _SecondOnboarding();
}

class _SecondOnboarding extends State<SecondOnboarding>
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
      body: SingleChildScrollView(
        child: Container(
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
                width: screenWidth / 1.4,
                'assets/onboard2.png',
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: screenHeight / 15),
              Text(
                'Fixed a Date for Event',
                style: TextStyle(
                  fontSize: screenWidth / 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight / 20),
              Text(
                'Stay in the loop with EasyFind! Our personalized recommendations ensure you never miss an event that matches your interests. Simply set your preferences, and we’ll do the rest—bringing the best events directly to you',
                style: TextStyle(
                  fontSize: screenWidth / 22,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight / 15),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 100, vertical: screenHeight / 20),
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth / 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/load2.svg',
                width: 90,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LastOnboarding()),
                  );
                },
                child: SvgPicture.asset(
                  'assets/next.svg',
                  width: 90,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

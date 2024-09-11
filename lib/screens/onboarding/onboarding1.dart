import 'package:event_and_activities_app/screens/onboarding/onboarding2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../authentication/login_page.dart';

class FirstOnboarding extends StatefulWidget {
  const FirstOnboarding({super.key});

  @override
  State<StatefulWidget> createState() => _FirstOnboarding();
}

class _FirstOnboarding extends State<FirstOnboarding>
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
              'assets/onboard1.png',
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: screenHeight / 15),
            Text(
              'Easy to find events',
              style: TextStyle(
                fontSize: screenWidth / 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight / 20),
            Text(
              'Discover events effortlessly with EasyFind! From concerts to workshops, our intuitive platform helps you find what\'s happening around you with ease. Explore, connect, and enjoy—let EasyFind be your guide!',
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
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 100, vertical: screenHeight / 20),
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth / 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/load1.svg',
                width: 90,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondOnboarding()),
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

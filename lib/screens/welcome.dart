import 'package:event_and_activities_app/screens/onboarding1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstOnboarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageWidth = screenWidth / 2;
    return Container(
      color: Colors.white,
      child: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color(0xfff7f8fa),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/rectAllBlue.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              //bottom: 0,
              child: Image.asset(
                'assets/rect24.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              // Center the image horizontally
              left: (screenWidth - imageWidth) / 2,
              // Place the image at the top third of the screen
              top: screenHeight / 5,
              width: imageWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/wits1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: screenHeight / 4,
              right: 0,
              //bottom: 0,
              child: Image.asset(
                'assets/secondBottomRect.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                'assets/topRect.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            const Center(
              child: Text(
                'Eventos',
                textAlign: TextAlign.left,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 40,
                  color: Color(0xffffffff),
                  letterSpacing: 7.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

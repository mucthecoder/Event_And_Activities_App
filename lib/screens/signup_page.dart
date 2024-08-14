import 'package:event_and_activities_app/services/validity_checker.dart';
import 'package:flutter/material.dart';
import 'package:event_and_activities_app/widget/bezierContainer.dart';
import 'package:event_and_activities_app/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.title});

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer(),
              ),
              Form(
                key: _formKey, // Assign the key here
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: 'E',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.lightBlue,
                            ),
                            children: [
                              TextSpan(
                                text: 've',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                              TextSpan(
                                text: 'n',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                ),
                              ),
                              TextSpan(
                                text: 'to',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                              TextSpan(
                                text: 's',
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "User Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      // hintText: "username",
                                      suffixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black54,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      fillColor: const Color(
                                        0xfff3f3f4,
                                      ),
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Username';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Email id",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      // hintText: "email",
                                      suffixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black54,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      fillColor: const Color(
                                        0xfff3f3f4,
                                      ),
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (ValidityChecker.nullInput(value) ||
                                          ValidityChecker.emptyInput(value!)) {
                                        return 'Please enter Email';
                                      }
                                      if (!ValidityChecker.isValidEmail(
                                          value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      // hintText: "password",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      fillColor: const Color(
                                        0xfff3f3f4,
                                      ),
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (ValidityChecker.nullInput(value) ||
                                          ValidityChecker.emptyInput(value!)) {
                                        return 'Please enter Password';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Confirm Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (ValidityChecker.nullInput(value) ||
                                          ValidityChecker.emptyInput(value!)) {
                                        return 'Please enter Password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    controller: _confirmedPasswordController,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      // hintText: "password",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ),
                                      ),
                                      fillColor: const Color(
                                        0xfff3f3f4,
                                      ),
                                      filled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(
                                  2,
                                  4,
                                ),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.blue,
                                Colors.lightBlue,
                              ],
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final String email = _emailController.text;
                                final String password =
                                    _passwordController.text;
                                final String name = _nameController.text;
                                final String confirmPassword =
                                    _confirmedPasswordController.text;

                                // Additional logic, like form submission or navigation
                                print("Name: $name");
                                print("Email: $email");
                                print("Password: $password");
                                print("Confirmed Password: $confirmPassword");
                              }
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                            if (_formKey.currentState?.validate() ?? false) {
                              // Additional logic, like form submission or navigation
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.bottomCenter,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Already have an account ?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(
                                      0xFF0389F6,
                                    ),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: 0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: const Icon(
                            Icons.arrow_left,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

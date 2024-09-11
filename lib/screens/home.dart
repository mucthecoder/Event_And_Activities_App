import 'package:event_and_activities_app/navbar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedIndex = 0;
  List<NavModel> navItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navItems = [
      NavModel(page: const Home(), navigatorKey: homeNavKey),
      NavModel(page: const Home(), navigatorKey: searchNavKey),
      NavModel(page: const Home(), navigatorKey: profileNavKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (navItems[selectedIndex].navigatorKey.currentState!.canPop()) {
          navItems[selectedIndex].navigatorKey.currentState!.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfefefeff),
        appBar: AppBar(
          backgroundColor: Color(0xfefefeff),
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/tune.svg',
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60, // Adjust the height as needed
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xe9e9e9ff),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(),
        bottomNavigationBar: NavBar(
          onTap: (index) {
            if (index == selectedIndex) {
              navItems[index]
                  .navigatorKey
                  .currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedIndex = index;
              });
            }
          },
          pageIndex: selectedIndex,
        ),
      ),
    );
  }
}

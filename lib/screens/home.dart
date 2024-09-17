import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:event_and_activities_app/screens/Eventcreater.dart'; // Import the CreateNewEventPage
import 'package:event_and_activities_app/widget/big_event_card.dart';
import 'package:event_and_activities_app/widget/categories_row.dart';
import 'package:event_and_activities_app/widget/heart_card.dart';
import 'package:event_and_activities_app/widget/join_card.dart';
import 'package:event_and_activities_app/widget/price_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const SingleChildScrollView(
        child: Column(
          children: [
            CategoriesRow(),
            PriceCard(),
            JoinCard(),
            HeartCard(),
            BigEventCard(),
          ],
        ),
      ),
      const CreateNewEventPage(), // Navigate to CreateNewEventPage
      Container(),
      Container(),
      Container()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore),
        title: ("Explore"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.event),
        title: ("Create Event"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_box_rounded),
        title: ("Search"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.location_on),
        title: ("Categories"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  void _onItemSelected(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateNewEventPage()),
      );
    } else {
      _controller.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfefefeff),
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/tune.svg'),
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
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        onItemSelected: _onItemSelected, // Handle item selection
        padding: const EdgeInsets.only(top: 10),
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This prevents the bottom nav bar from resizing when the keyboard is open.
        stateManagement: true, // Default is true.
        navBarStyle: NavBarStyle
            .style15, // Choose the nav bar style with different properties.
      ),
    );
  }
}

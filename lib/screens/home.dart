//import 'package:event_and_activities_app/navbar_model.dart';
import 'package:event_and_activities_app/widget/big_event_card.dart';
import 'package:event_and_activities_app/widget/categories_row.dart';
import 'package:event_and_activities_app/widget/heart_card.dart';
import 'package:event_and_activities_app/widget/join_card.dart';
import 'package:event_and_activities_app/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../data.dart';
import '../widget/event_bottom_sheet.dart';
import '../widget/event_cards.dart';
import '../widget/price_card.dart';
import 'create_event_screen.dart';
//import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

//import '../navbar.dart'; // Assuming this is your custom NavBar widget

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
            PriceCard(), // Add your event card here
            JoinCard(),
            HeartCard(),
            BigEventCard(),
          ],
        ),
      ),
      const Center(
          child: Text(
        "I have no idea what goes here",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      )),
      // Replace the direct modal call with a button that shows the modal
      const CreateEventScreen(), // This is the screen that will automatically show the modal

      ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            title: event["name"]!,
            count: event["count"]!,
            color: Color(int.parse(event["color"]!)),
          );
        },
      ),
      ProfileCard()
    ];
  }

  // Function to show the bottom sheet
  void _showCreateEventModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true, // Allows for full-screen modal
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom), // Ensures the modal shifts when keyboard pops up
          child: const CreateEventForm(),
        );
      },
    );
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
        icon: const Icon(
          Icons.add_box_rounded,
          color: Colors.white,
        ),
        title: (" "),
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
        padding: EdgeInsets.only(top: 10),
        //confineInSafeArea: true,
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

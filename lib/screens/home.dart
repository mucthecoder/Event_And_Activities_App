
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:event_and_activities_app/screens/Eventcreater.dart';
import 'package:event_and_activities_app/screens/categories_page.dart';
import 'package:event_and_activities_app/screens/profile_page.dart';

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
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample data of events for demonstration purposes
  final List<Map<String, String>> _allEvents = [
    {'title': 'CSAM GameBlast', 'category': 'Games'},
    {'title': 'Tech Conference', 'category': 'Technology'},
    {'title': 'Art Expo', 'category': 'Art'},
    {'title': 'Music Festival', 'category': 'Music'},
  ];

  List<Map<String, String>> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    // Initialize with all events initially displayed
    _filteredEvents = _allEvents;
  }

  List<Widget> _buildScreens() {
    return [
      SingleChildScrollView(
        child: Column(
          children: [
            CategoriesRow(),
            PriceCard(),
            JoinCard(),
            HeartCard(),
            // If there is a search query, display filtered results
            if (_searchQuery.isNotEmpty)
              ..._filteredEvents.map((event) => BigEventCard(eventTitle: event['title']!, eventCategory: event['category']!)).toList()
            else
            // Otherwise display default cards
              BigEventCard(eventTitle: 'CSAM GameBlast', eventCategory: 'Games'),
          ],
        ),
      ),
      const CreateNewEventPage(),
      Container(), // Placeholder for Search page
      const CategoriesPage(),
      const ProfilePage(),
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
        icon: const Icon(Icons.category),
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
        MaterialPageRoute(builder: (context) => CreateNewEventPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoriesPage()),
      );
    } else {
      setState(() {
        _controller.index = index;
      });
    }
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();

      if (_searchQuery.isNotEmpty) {
        // Filter the events based on the search query
        _filteredEvents = _allEvents.where((event) {
          return event['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              event['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      } else {
        // If search query is empty, show all events
        _filteredEvents = _allEvents;
      }
    });
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
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xe9e9e9ff),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 40,
                      ),
                      onPressed: _performSearch,
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
        onItemSelected: _onItemSelected,
        padding: const EdgeInsets.only(top: 10),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}

class BigEventCard extends StatelessWidget {
  final String eventTitle;
  final String eventCategory;

  const BigEventCard({
    Key? key,
    required this.eventTitle,
    required this.eventCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.asset(
                    'assets/group.jpeg', // Replace with event image asset
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      eventCategory,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'THU 26 May, 09:00 - FRI 27 May, 10:00',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R30',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Join Event',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

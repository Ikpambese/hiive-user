import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hiiveuser/delivery/delivery_screen.dart';
import 'package:hiiveuser/screens/search_screen.dart';

import '../screens/address.dart';
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void navigateBottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeliveryPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: (index) => navigateBottom(index),
        color: Colors.grey[400],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        activeColor: Colors.grey[700],
        tabBackgroundColor: Colors.grey.shade300,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBorderRadius: 24,
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 12),
        gap: 8, // Space between icon and text
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            textStyle: TextStyle(fontSize: 12),
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
            textStyle: TextStyle(fontSize: 12),
          ),
          GButton(
            icon: Icons.pin_drop,
            text: 'Address',
            textStyle: TextStyle(fontSize: 12),
          ),
          GButton(
            icon: Icons.shopify,
            text: 'Orders',
            textStyle: TextStyle(fontSize: 12),
          ),
          GButton(
            icon: FontAwesomeIcons.bicycle,
            text: 'Delivery',
            textStyle: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

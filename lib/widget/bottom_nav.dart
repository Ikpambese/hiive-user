import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hiiveuser/delivery/delivery_screen.dart';
import 'package:hiiveuser/screens/search_screen.dart';

import '../screens/address.dart';
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateBottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: navigateBottom,
              gap: 8,
              color: Colors.grey[400],
              activeColor: Colors.amber,
              tabBackgroundColor: Colors.amber.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabBorderRadius: 20,
              curve: Curves.easeInOut,
              iconSize: 24,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  iconActiveColor: Colors.amber,
                  iconSize: 24,
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: 'Search',
                  iconActiveColor: Colors.amber,
                  iconSize: 24,
                ),
                GButton(
                  icon: Icons.location_on_rounded,
                  text: 'Address',
                  iconActiveColor: Colors.amber,
                  iconSize: 24,
                ),
                GButton(
                  icon: Icons.shopping_bag_rounded,
                  text: 'Orders',
                  iconActiveColor: Colors.amber,
                  iconSize: 24,
                ),
                GButton(
                  icon: FontAwesomeIcons.bicycle,
                  text: 'Delivery',
                  iconActiveColor: Colors.amber,
                  iconSize: 22,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              rippleColor: Colors.amber.withOpacity(0.1),
              hoverColor: Colors.amber.withOpacity(0.1),
              haptic: true,
            ),
          ),
        ),
      ),
    );
  }
}

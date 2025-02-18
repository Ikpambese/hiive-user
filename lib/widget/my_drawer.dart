import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hiiveuser/global/global.dart';
import 'package:hiiveuser/screens/my_orders_screen.dart';

import '../authentication/auth_screen.dart';
import '../screens/address.dart';
import '../screens/history.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.amber.withOpacity(0.1),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: ListView(
            children: [
              // Header Drawer
              Container(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: 'profile',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.amber,
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(
                              sharedPreferences!.getString('photoUrl')!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          sharedPreferences!.getString('name')!.toUpperCase(),
                          textStyle: const TextStyle(
                            color: Colors.amber,
                            fontSize: 24,
                            fontFamily: 'Kiwi',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Drawer Items
              _buildAnimatedListTile(
                icon: Icons.home_rounded,
                title: 'Home',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
                delay: 0.2,
              ),

              _buildAnimatedListTile(
                icon: Icons.receipt_long_rounded,
                title: 'My Orders',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrdersScreen())),
                delay: 0.3,
              ),

              _buildAnimatedListTile(
                icon: Icons.history_rounded,
                title: 'History',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen())),
                delay: 0.4,
              ),

              _buildAnimatedListTile(
                icon: Icons.search_rounded,
                title: 'Search',
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SearchScreen())),
                delay: 0.5,
              ),

              _buildAnimatedListTile(
                icon: Icons.location_on_rounded,
                title: 'Add Address',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressScreen())),
                delay: 0.6,
              ),

              _buildAnimatedListTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                onTap: () {
                  firebaseAuth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const AuthScreen()));
                  });
                },
                delay: 0.7,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double delay,
    bool isLogout = false,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay,
            delay + 0.2,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLogout ? Colors.red.withOpacity(0.1) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isLogout
                  ? Colors.red.withOpacity(0.1)
                  : Colors.amber.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isLogout ? Colors.red : Colors.amber,
            size: 28,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLogout ? Colors.red : Colors.amber,
              fontFamily: 'Acme',
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

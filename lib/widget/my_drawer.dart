import 'package:flutter/material.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../screens/address.dart';
import '../screens/history.dart';
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/search_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Header Drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(80),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString('photoUrl')!,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sharedPreferences!
                      .getString(
                        'name',
                      )!
                      .toUpperCase(),
                  style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 28,
                      fontFamily: 'Kiwi',
                      letterSpacing: 2),
                ),
              ],
            ),
          )
          //  Drawer body
          ,
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.cyan),
                  title: const Text(
                    'My Order',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrdersScreen()));
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.cyan),
                  title: const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(Icons.search, color: Colors.cyan),
                  title: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => SearchScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(Icons.add_location, color: Colors.cyan),
                  title: const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()));
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.cyan),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontFamily: 'Acme',
                      fontSize: 30,
                      letterSpacing: 3,
                    ),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const AuthScreen(),
                            ),
                          )
                        });
                  },
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 2),
              ],
            ),
          )
        ],
      ),
    );
  }
}

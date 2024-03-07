import 'package:flutter/material.dart';

import '../screens/address.dart';
import '../screens/home_screen.dart';
import '../screens/my_orders_screen.dart';

class ButtomNav extends StatelessWidget {
  const ButtomNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipOval(
          child: Material(
              child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: Icon(Icons.home, color: Colors.cyan),
          )),
        ),
        ClipOval(
          child: Material(
              child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressScreen()));
            },
            icon: Icon(Icons.pin_drop, color: Colors.cyan),
          )),
        ),
        ClipOval(
          child: Material(
              child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyOrdersScreen()));
            },
            icon: Icon(Icons.shopify_rounded, color: Colors.cyan),
          )),
        ),
      ],
    );
  }
}

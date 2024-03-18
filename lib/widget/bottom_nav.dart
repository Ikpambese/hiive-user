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
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.2),
            offset: Offset.zero)
      ]),
      height: 100,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipOval(
            child: Material(
              child: IconButton(
                splashColor: Colors.grey[100],
                highlightColor: Colors.grey[100],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                icon: const Icon(Icons.home, color: Colors.amber),
              ),
            ),
          ),
          ClipOval(
            child: Material(
                color: Colors.amber,
                child: IconButton(
                  splashColor: Colors.grey[100],
                  highlightColor: Colors.grey[100],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()));
                  },
                  icon: const Icon(
                    Icons.pin_drop,
                    color: Colors.amber,
                  ),
                )),
          ),
          ClipOval(
            child: Material(
                child: IconButton(
              splashColor: Colors.grey[100],
              highlightColor: Colors.grey[100],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrdersScreen()));
              },
              icon: const Icon(Icons.shopify_rounded, color: Colors.amber),
            )),
          ),
        ],
      ),
    );
  }
}

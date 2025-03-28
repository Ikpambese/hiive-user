import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class StatusBarnner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const StatusBarnner({super.key, this.orderStatus, this.status});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;
    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = 'Successful' : message = 'Unsuccessful';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.amber,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const HomeScreen()),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            orderStatus == 'ended'
                ? 'Parcel Delivered $message'
                : 'Order Placed $message',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}

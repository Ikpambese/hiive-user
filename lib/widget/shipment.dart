import 'package:flutter/material.dart';

import '../models/address.dart';
import '../screens/order_trackingscreen.dart';
import '../splash/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderID;

  ShipmentAddressDesign({this.model, this.orderID});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Shipping Details:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MySplashScreen()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.cyan,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Go Back",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => TrackerScreen(
                    //               orderID: orderID,
                    //             )));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.black,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Track Food",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

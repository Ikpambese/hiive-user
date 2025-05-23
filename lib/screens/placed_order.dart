// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import 'home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  // Changed from StatelessWidget to StatefulWidget
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;
  final String? paymentMethod;

  const PlacedOrderScreen({
    super.key,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
    this.paymentMethod = 'Online',
  });

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  addOrderDetails() {
    writeOrderDetailsForUSer({
      'addressID': widget.addressID,
      'totalAmount': widget.totalAmount,
      'orderBy': sharedPreferences!.getString('uid'),
      'productIDs': sharedPreferences!.getStringList('userCart'),
      'paymentDetails': widget.paymentMethod,
      'orderTime': orderId,
      'isSuccess': true,
      'sellerUID': widget.sellerUID,
      'riderUID': '',
      'status': 'normal',
      'orderId': orderId
    });
    writeOrderDetailsForSeller({
      'addressID': widget.addressID,
      'totalAmount': widget.totalAmount,
      'orderBy': sharedPreferences!.getString('uid'),
      'productIDs': sharedPreferences!.getStringList('userCart'),
      'paymentDetails': widget.paymentMethod,
      'orderTime': orderId,
      'isSuccess': true,
      'sellerUID': widget.sellerUID,
      'riderUID': '',
      'status': 'normal',
      'orderId': orderId
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = '';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        Fluttertoast.showToast(
            msg: 'Congratulations, Order has been placed',
            textColor: Colors.green);
      });
    });
  }

  Future writeOrderDetailsForUSer(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .collection('orders')
        .doc(orderId)
        .set(data); // map that contains oder data
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(data); // map that contains oder data
  }

  @override
  void initState() {
    addOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/delivery.jpg'),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: (() {
                addOrderDetails();
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(14)),
              child: const Text('Oya send my oders'),
            )
          ],
        ),
      ),
    );
  }
}

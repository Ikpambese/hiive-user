// ignore_for_file: prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiiveuser/screens/saved_address_screen.dart';

import 'package:provider/provider.dart';

import '../assistants/address_changer.dart';
import '../global/global.dart';
import '../models/address.dart';
import '../widget/address_design.dart';
import '../widget/progress_bar.dart';
import '../widget/simple_appbar.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;
  AddressScreen({this.sellerUID, this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
    print(widget.totalAmount);
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'LunchBox',
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_location),
        backgroundColor: Colors.amber,
        label: const Text('add new Address'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveAddressScreen(),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Select Address: ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('userAddress')
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(child: circularProgress())
                    : snapshot.data!.docs.length == 0
                        ? Container()
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return AddressDesign(
                                currentIndex: address.count,
                                value: index,
                                addressID: snapshot.data!.docs[index].id,
                                sellerUID: widget.sellerUID,
                                totalAmount: widget.totalAmount,
                                model: Address.fromJson(
                                    snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>),
                              );
                            },
                          );
              },
            ));
          })
        ],
      ),
    );
  }
}

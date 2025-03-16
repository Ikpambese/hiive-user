// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../models/address.dart';
import 'package:intl/intl.dart';

import '../widget/progress_bar.dart';
import '../widget/shipment.dart';
import '../widget/status_barnner.dart';

class OrderDeatilsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDeatilsScreen({this.orderID});

  @override
  State<OrderDeatilsScreen> createState() => _OrderDeatilsScreenState();
}

class _OrderDeatilsScreenState extends State<OrderDeatilsScreen> {
  String orderStatus = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(sharedPreferences!.getString('uid'))
              .collection('orders')
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data() as Map<String, dynamic>;
              orderStatus = dataMap['status'].toString();
            }
            
            if (!snapshot.hasData) {
              return Center(child: circularProgress());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBarnner(
                  status: dataMap!["isSuccess"],
                  orderStatus: orderStatus,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₦ ${dataMap["totalAmount"]}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: orderStatus == "ended"
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              orderStatus == "ended" ? "Delivered" : "In Progress",
                              style: TextStyle(
                                color: orderStatus == "ended"
                                    ? Colors.green
                                    : Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Order Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow("Order ID", widget.orderID!),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        "Order Date",
                        DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(dataMap["orderTime"]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      orderStatus == "ended"
                          ? Image.asset(
                              "images/delivered.jpg",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "images/state.jpg",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                      const SizedBox(height: 24),
                      const Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(sharedPreferences!.getString("uid"))
                            .collection("userAddress")
                            .doc(dataMap["addressID"])
                            .get(),
                        builder: (c, snapshot) {
                          return snapshot.hasData
                              ? ShipmentAddressDesign(
                                  model: Address.fromJson(
                                    snapshot.data!.data()!
                                        as Map<String, dynamic>,
                                  ),
                                  orderID: widget.orderID,
                                )
                              : Center(child: circularProgress());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

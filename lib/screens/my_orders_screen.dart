import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';
import '../widget/progress_bar.dart';
import '../widget/simple_appbar.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.blue;
      case 'packed':
        return Colors.orange;
      case 'ended':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return 'Processing';
      case 'packed':
        return 'Ready to Ship';
      case 'ended':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: SimpleAppBar(title: "My Orders"),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .where("status", whereIn: ['normal', 'packed', 'ended'])
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgress());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No Orders Yet',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index) {
                final orderData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final status = orderData['status'] as String;
                final orderTime = orderData['orderTime'] != null
                    ? (orderData['orderTime'] is Timestamp
                        ? (orderData['orderTime'] as Timestamp).toDate()
                        : DateTime.fromMillisecondsSinceEpoch(
                            int.parse(orderData['orderTime'].toString())))
                    : DateTime.now();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => OrderDeatilsScreen(
                          orderID: snapshot.data!.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${snapshot.data!.docs[index].id.substring(0, 8)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat("dd MMMM, yyyy").format(orderTime),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  getStatusColor(status).withValues(alpha: 25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: getStatusColor(status)
                                    .withValues(alpha: 128),
                              ),
                            ),
                            child: Text(
                              getStatusText(
                                status,
                              ),
                              style: TextStyle(
                                // color: getStatusColor(status),
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../global/global.dart';
import '../widget/simple_appbar.dart';

class TrackerScreen extends StatefulWidget {
  final String? orderID;
  const TrackerScreen({this.orderID});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen>
    with TickerProviderStateMixin {
  String status = '';
  bool isLoading = true;

  Future<void> getStatus() async {
    try {
      DocumentSnapshot orderDoc = await FirebaseFirestore.instance
          // .collection('users')
          // .doc(sharedPreferences!.getString('uid'))
          .collection('orders')
          .doc(widget.orderID)
          .get();

      if (mounted && orderDoc.exists) {
        Map<String, dynamic> data = orderDoc.data() as Map<String, dynamic>;
        setState(() {
          status = data['status'] ?? 'normal';
          isLoading = false;
          print('Status fetched successfully: $status');
          print('Order ID: ${widget.orderID}');
        });
      } else {
        print('Order document does not exist');
        setState(() {
          status = 'normal';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching status: $e');
      setState(() {
        status = 'normal';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required String title,
    required String time,
    required bool isCompleted,
    required bool isActive,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isCompleted ? Colors.green : Colors.grey.shade300,
      ),
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : (isActive ? Colors.amber : Colors.grey.shade300),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
      endChild: Container(
        constraints: const BoxConstraints(minHeight: 80),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCompleted || isActive ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color: isCompleted || isActive ? Colors.black54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    // Debug print for status

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTimelineTile(
            isFirst: true,
            isLast: false,
            title: 'Order Placed (Status: Placed)',
            time: DateTime.now().toString(),
            isCompleted: true,
            isActive: status == 'normal',
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            title: 'Order Packed (Status: packed)',
            time: DateTime.now().toString(),
            isCompleted: status == 'packed' || status == 'ended',
            isActive: status == 'packed',
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            title: 'Rider Underway (Status: delivering)',
            time: DateTime.now().toString(),
            isCompleted: status == 'ended',
            isActive: status == 'delivering',
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: true,
            title: 'Delivered (Status: ended)',
            time: DateTime.now().toString(),
            isCompleted: status == 'ended',
            isActive: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: SimpleAppBar(title: 'Track Order'),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${widget.orderID}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Estimated Delivery: ${DateTime.now().add(const Duration(days: 2)).toString().split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTimeline(),
                ],
              ),
            ),
    );
  }
}

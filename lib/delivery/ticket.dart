import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../payment/flutterwave_payment.dart';
import '../global/global.dart';

class TrackingCard extends StatelessWidget {
  final String trackingId;
  final String status;
  final String type;
  final String departure;
  final String sortingCenter;
  final String arrival;
  final String departureTime;
  final String sortingCenterTime;
  final String arrivalTime;
  final double? bill;

  const TrackingCard({
    super.key,
    required this.trackingId,
    required this.status,
    required this.type,
    required this.departure,
    required this.sortingCenter,
    required this.arrival,
    required this.departureTime,
    required this.sortingCenterTime,
    required this.arrivalTime,
    this.bill,
  });

  void _handlePayment(BuildContext context) {
    OyaPay(
      logistics: sharedPreferences!.getInt('logistics')!,
      ctx: context,
      price: bill!.toInt(),
      email: sharedPreferences!.getString('email')!,
    ).handlePaymentInitialization((bool success) {
      if (success) {
        // Update ticket status to 'Pay' after successful payment
        FirebaseFirestore.instance
            .collection('minordelivery')
            .doc(trackingId)
            .update({
          'status': 'Pay',
        }).then((_) {
          Navigator.pop(context); // Close the tracking card
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment successful! Status updated.'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error updating status. Please contact support.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tracking ID:',
                style: TextStyle(
                  color: Colors.white.withAlpha(179),
                  fontSize: 14,
                ),
              ),
              Text(
                trackingId.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statusBadge(status),
              const SizedBox(width: 8),
              _statusBadge(type),
            ],
          ),
          const SizedBox(height: 24),
          _trackingStep(
            "Sender",
            departure,
            departureTime,
            true,
          ),
          _trackingStep(
            "Processing",
            sortingCenter,
            sortingCenterTime,
            status != 'Pending',
          ),
          _trackingStep(
            "Receiver",
            arrival,
            arrivalTime,
            status == 'Delivered',
          ),
          const SizedBox(height: 16),
          if (bill != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bill Amount:',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '₦${bill!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (bill! > 0.0 && status == 'Pending')
              Center(
                child: ElevatedButton(
                  onPressed: () => _handlePayment(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Make Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (bill! == 0.0 && status == 'Pending')
              const Center(
                child: Text(
                  'Hold one while we attend to your request',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (bill! > 0.0 && status == 'Complete')
              const Center(
                child: Text(
                  'We are coming your way now',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (bill! > 0.0 && status == 'delivering')
              const Center(
                child: Text(
                  'We are delivering your package',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (bill! > 0.0 && status == 'Delivered')
              const Center(
                child: Text(
                  'Completed, Thank you for choosing us',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Center(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _trackingStep(
      String title, String location, String time, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? Colors.greenAccent : Colors.grey,
              ),
              if (completed)
                Container(width: 2, height: 40, color: Colors.greenAccent),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 14,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

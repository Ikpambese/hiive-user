import 'package:flutter/material.dart';

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
  });

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
          Text(
            trackingId,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _statusBadge(status),
              const SizedBox(width: 8),
              _statusBadge(type),
            ],
          ),
          const SizedBox(height: 16),
          _trackingStep("Departure", departure, departureTime, true),
          _trackingStep(
              "Sorting Center", sortingCenter, sortingCenterTime, true),
          _trackingStep("Arrival", arrival, arrivalTime, false),
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
                    color: Colors.white.withOpacity(0.7),
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

import 'package:flutter/material.dart';
import 'package:hiiveuser/global/global.dart';

import 'package:provider/provider.dart';

import '../assistants/address_changer.dart';
import '../maps/maps.dart';
import '../models/address.dart';
import '../payment/flutterwave_payment.dart';
import '../screens/placed_order.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;
  const AddressDesign({
    super.key,
    this.addressID,
    this.currentIndex,
    this.model,
    this.sellerUID,
    this.totalAmount,
    this.value,
  });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Provider.of<AddressChanger>(context, listen: false)
                    .displayResults(widget.value);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: widget.value,
                          groupValue: widget.currentIndex,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            Provider.of<AddressChanger>(context, listen: false)
                                .displayResults(val);
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Name', widget.model!.name),
                              const SizedBox(height: 8),
                              _buildInfoRow('Phone', widget.model!.phoneNumber),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                  'Flat Number', widget.model!.flatNumber),
                              const SizedBox(height: 8),
                              _buildInfoRow('City', widget.model!.city),
                              const SizedBox(height: 8),
                              _buildInfoRow('State', widget.model!.state),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                  'Full Address', widget.model!.fullAddress),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await MapsUtils.openMap(
                                    widget.model!.lat!, widget.model!.lng!);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('View on Map'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        if (widget.value ==
                            Provider.of<AddressChanger>(context).count) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      OyaPay(
                                        logistics: sharedPreferences!
                                            .getInt('logistics')!,
                                        ctx: context,
                                        price: widget.totalAmount!.toInt(),
                                        email: sharedPreferences!
                                            .getString('email')!,
                                      ).handlePaymentInitialization(
                                          (bool success) {
                                        if (success) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlacedOrderScreen(
                                                addressID: widget.addressID,
                                                totalAmount: widget.totalAmount,
                                                sellerUID: widget.sellerUID,
                                              ),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Error"),
                                              content: const Text(
                                                  "Payment failed. Please try again."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.payment),
                                    label: const Text('Pay Now'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Show confirmation dialog for Pay on Delivery
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              "Pay on Delivery Notice"),
                                          content: const Text(
                                              "Pay on Delivery includes an additional charge of ₦500. Do you wish to continue?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlacedOrderScreen(
                                                      addressID:
                                                          widget.addressID,
                                                      totalAmount:
                                                          (widget.totalAmount! +
                                                              500),
                                                      sellerUID:
                                                          widget.sellerUID,
                                                      paymentMethod: 'Cash',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text("Continue"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delivery_dining),
                                    label:
                                        const Text('Pay on Delivery (+₦500)'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[800],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value ?? '',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

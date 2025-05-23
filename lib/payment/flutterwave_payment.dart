import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:hiiveuser/assistants/key.dart';
import 'package:uuid/uuid.dart';

class OyaPay {
  OyaPay(
      {required this.ctx,
      required this.price,
      required this.email,
      required this.logistics});

  final BuildContext ctx;
  final int? price;
  final String email;
  final int logistics;

  bool isTestMode = false;

  Future<void> handlePaymentInitialization(void Function(bool) callback) async {
    final Customer customer = Customer(email: email);
    final realPrice = price! + logistics;
    final Flutterwave flutterwave = Flutterwave(
      //ctx: context,
      // Fixed: using correct parameter name 'ctx'
      publicKey: ConstantKey.PAYSTACK_KEY,
      currency: 'NGN',
      redirectUrl: 'https://www.google.com',
      txRef: const Uuid().v1(),
      amount: realPrice.toString(),
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Hiive Payment"),
      isTestMode: isTestMode,
    );
    final ChargeResponse response = await flutterwave.charge(ctx);

    if (response.success!) {
      showLoading("Payment successful");
      callback(true);
    } else {
      showLoading("Payment failed. Please try again.");
      callback(false);
    }

    print("${response.toJson()}");
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}

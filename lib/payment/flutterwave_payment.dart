import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:hiiveuser/assistants/key.dart';
import 'package:uuid/uuid.dart';

class OyaPay {
  OyaPay({required this.ctx, required this.price, required this.email});
  final BuildContext ctx;
  final int? price;
  final String email;

  bool isTestMode = true;

  Future<void> handlePaymentInitialization() async {
    final Customer customer = Customer(email: email);

    final Flutterwave flutterwave = Flutterwave(
      context: ctx,
      publicKey: getPublicKey(),
      currency: 'NGN',
      redirectUrl: 'https://facebook.com',
      txRef: Uuid().v1(),
      amount: price.toString(),
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Test Payment"),
      isTestMode: isTestMode,
    );
    final ChargeResponse response = await flutterwave.charge();

    showLoading(response.toString());
    print("${response.toJson()}");
  }

  String getPublicKey() {
    return ConstantKey.PAYSTACK_KEY;
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}

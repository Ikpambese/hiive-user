import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import '../assistants/key.dart';
import '../global/global.dart';
import '../splash/splash_screen.dart';

class MakePayement {
  MakePayement({this.ctx, this.price, required this.email});
  BuildContext? ctx;
  int? price;
  String email = sharedPreferences!.getString('email')!;
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard getCardUI() {
    return PaymentCard(number: '', cvc: '', expiryMonth: 0, expiryYear: 0);
  }

  PaystackPlugin paystack = PaystackPlugin();

  Future initializePlugin() async {
    await paystack.initialize(
      publicKey: ConstantKey.PAYSTACK_KEY,
    );
  }

  chargeCardAndMAkePayement() async {
    initializePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = (price! * 100)
        ..email = email
        ..reference = _getReference()
        ..card = getCardUI();

      CheckoutResponse response = await paystack.checkout(
        ctx!,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: const FlutterLogo(
          size: 24,
        ),
      );
      print(response);
      if (response.status == true) {
        price = (price! + int.parse(sharedPreferences!.getString('balance')!));
        FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPreferences!.getString('uid')!)
            .update({
          'userBalance': price.toString(),
          'canWithdraw': 'canYes',
          'interest': '0'
        }).then((value) {
          print('Transaction Successful');
          Navigator.push(
              ctx!, MaterialPageRoute(builder: (ctx) => MySplashScreen()));
        });
      } else {
        print('Transaction Failed');
      }
    });
  }
}

import 'package:flutter/cupertino.dart';

import '../global/global.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter =
      sharedPreferences!.getStringList('userCart')!.length -
          1; //get total items in user cart

  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async {
    cartListItemCounter =
        sharedPreferences!.getStringList('userCart')!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners(); // shared data with provider
    });
  }
}

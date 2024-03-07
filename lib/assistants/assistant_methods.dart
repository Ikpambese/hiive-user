import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../global/global.dart';
import 'cartitem_counter.dart';

seperateOrderItemIDs(orderIDs) {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  return separateItemIDsList;
}

seperateItemIDs() {
  List<String> seperateItemIDsList = [], defaultItemList = [];
  int i = 0;
  defaultItemList = sharedPreferences!.getStringList('userCart')!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(':');
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    seperateItemIDsList.add(getItemId);
  }

  return seperateItemIDsList;
}

addItemTocart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempLIst = sharedPreferences!.getStringList('userCart');
  tempLIst!.add(foodItemId! + ':$itemCounter');

// ADD TO FIREBASE
  FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseAuth.currentUser!.uid)
      .update({'userCart': tempLIst}).then((value) {
    Fluttertoast.showToast(msg: 'Item added successfully');
    sharedPreferences!.setStringList('userCart', tempLIst);

    // update the badge

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

seperateItemQuantities() {
  List<int> seperateItemQtyList = [];
  List<String> defaultItemList = [];
  int i = 1;
  defaultItemList = sharedPreferences!.getStringList('userCart')!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(':').toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());
    print('\nthis is itemID now ' + quanNumber.toString());
    seperateItemQtyList.add(quanNumber);
  }
  print('\nthis is items lis now ');
  print(seperateItemQtyList);
  return seperateItemQtyList;
}

seperateORderItemQuantities(orderIDs) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();

    //0=:
    //1=7
    //:7
    List<String> listItemCharacters = item.split(":").toList();

    //7
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is Quantity Number = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber.toString());
  }

  print("\nThis is Quantity List now = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

clearCartNow(context) {
  sharedPreferences!.setStringList('userCart', ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList('userCart');
  //Update
  //
  FirebaseFirestore.instance
      .collection('users')
      .doc(firebaseAuth.currentUser!.uid)
      .update({'userCart': emptyList}).then((value) {
    sharedPreferences!.setStringList('userCart', emptyList!);
  });
}

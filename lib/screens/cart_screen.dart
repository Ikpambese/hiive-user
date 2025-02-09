// ignore_for_file: prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hiiveuser/assistants/assistant_methods.dart';
import 'package:hiiveuser/screens/address.dart';
import 'package:hiiveuser/widget/appbar.dart';
import 'package:provider/provider.dart';

import '../assistants/cartitem_counter.dart';
import '../assistants/total_amount.dart';
import '../models/items.dart';
import '../splash/splash_screen.dart';
import '../widget/cart_item_design.dart';
import '../widget/progress_bar.dart';
import '../widget/text_widget.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  const CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantityList = seperateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.sellerUID),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const SizedBox(
          width: 10,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton.extended(
            heroTag: 'btn2',
            label: const Text('Clear Cart'),
            backgroundColor: Colors.amber,
            icon: const Icon(Icons.clear_all),
            onPressed: (() {
              clearCartNow(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MySplashScreen()));
              Fluttertoast.showToast(msg: 'Cart has been Cleared');
            }),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton.extended(
            heroTag: 'btn1',
            label: const Text(
              'Check Out',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.amber,
            icon: const Icon(Icons.navigate_next),
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      sellerUID: widget.sellerUID,
                    ),
                  ));
              print(totalAmount);
              print(totalAmount.toDouble());
            }),
          ),
        ),
      ]),
      body: CustomScrollView(
        slivers: [
          // overall total amou
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidget(title: 'My Cart List'),
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            'Total Price: ${amountProvider.tAmount.toString()}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('itemID', whereIn: seperateItemIDs())
                .orderBy(
                  'publishedDate',
                  descending: true,
                )
                .snapshots(),
            builder: ((context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs.length == 0
                      ? SliverToBoxAdapter(
                          child: Container(
                              child: const Center(
                            child: Text("NO ITEMS IN CART"),
                          )),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            ((context, index) {
                              Items model = Items.fromJson(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>);
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              } else {
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                });
                              }
                              return CartItemDesign(
                                model: model,
                                context: context,
                                quanNumber: separateItemQuantityList![index],
                              );
                            }),
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ),
                        );
            }),
          ),
        ],
      ),
    );
  }
}

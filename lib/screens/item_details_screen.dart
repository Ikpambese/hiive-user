import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../assistants/assistant_methods.dart';
import '../models/items.dart';
import '../widget/appbar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController numberCounterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
          ),

          // counter
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: NumberInputPrefabbed.roundedButtons(
              controller: numberCounterController,
              incDecBgColor: Colors.amber,
              min: 1,
              max: 9,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              '₦ ' + widget.model!.price.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // add to cart
          Center(
            child: InkWell(
              onTap: () {
                //
                int itemCounter = int.parse(numberCounterController.text);
                List<String> seperateItemIDsList = seperateItemIDs();

                // check if item exist in cart
                seperateItemIDsList.contains(widget.model!.itemID)
                    ? Fluttertoast.showToast(msg: 'Item already in cart')
                    : addItemTocart(widget.model!.itemID, context, itemCounter);
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber,
                      Colors.amber,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ]),
      ),
    );
  }
}

//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../assistants/assistant_methods.dart';
import '../models/items.dart';
import '../widget/appbar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailsScreen({this.model});

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            Center(
              child: CachedNetworkImage(
                imageUrl: widget.model!.thumbnailUrl.toString(),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 150,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Item Quantity Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: NumberInputPrefabbed.roundedButtons(
                controller: numberCounterController,
                incDecBgColor: Colors.amber,
                min: 1,
                max: 10,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),
            const SizedBox(height: 20),

            // Item Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            // Item Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Item Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '₦ ${widget.model!.price.toString()}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Add to Cart Button
            InkWell(
              onTap: () {
                int itemCounter = int.parse(numberCounterController.text);
                List<String> separateItemIDsList = seperateItemIDs();

                // Check if item exists in cart
                if (separateItemIDsList.contains(widget.model!.itemID)) {
                  Fluttertoast.showToast(msg: 'Item already in cart');
                } else {
                  addItemTocart(widget.model!.itemID, context, itemCounter);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.amber],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../assistants/assistant_methods.dart';
import '../models/items.dart';
import '../widget/appbar.dart';
import '../widget/macro_widget.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  // TextEditingController numberCounterController = TextEditingController();
  int numberCounterController = 1;

  int max = 9;
  int min = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(3, 3), blurRadius: 5)
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.model!.thumbnailUrl!),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(3, 3), blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FloatingActionButton(
                          heroTag: 'add',
                          onPressed: () {
                            setState(() {
                              if (numberCounterController <= max) {
                                numberCounterController++;
                              } else {
                                print('CANT GO PAST 10');
                              }
                            });
                          },
                          child: const Icon(FontAwesomeIcons.plus),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          numberCounterController.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                          heroTag: 'minus',
                          onPressed: () {
                            setState(() {
                              if (numberCounterController >= min) {
                                numberCounterController--;
                              } else {
                                print('OUTTa BOUND');
                              }
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.model!.title!,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₦${widget.model!.price! - (widget.model!.price! * (0) / 100)}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  "₦${widget.model!.price}.00",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Row(
                      children: [
                        MyMacroWidget(
                          title: "Calories",
                          value: 100,
                          icon: FontAwesomeIcons.fire,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyMacroWidget(
                          title: "Protein",
                          value: 50,
                          icon: FontAwesomeIcons.dumbbell,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyMacroWidget(
                          title: "Fat",
                          value: 50,
                          icon: FontAwesomeIcons.oilWell,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyMacroWidget(
                          title: "Carbs",
                          value: 100,
                          icon: FontAwesomeIcons.breadSlice,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          int itemCounter =
                              int.parse(numberCounterController.toString());
                          List<String> separateItemIDsList = seperateItemIDs();

                          // Check if item exists in cart
                          if (separateItemIDsList
                              .contains(widget.model!.itemID)) {
                            Fluttertoast.showToast(msg: 'Item already in cart');
                          } else {
                            addItemTocart(
                                widget.model!.itemID, context, itemCounter);
                          }
                        },
                        style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Add Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

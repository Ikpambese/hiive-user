import 'package:flutter/material.dart';

import '../models/items.dart';

// ignore: must_be_immutable
class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;
  CartItemDesign({super.key, this.model, this.context, this.quanNumber});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(children: [
            Image.network(
              widget.model!.thumbnailUrl!,
              width: 140,
              height: 120,
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ignore: prefer_const_constructors

                Text(
                  widget.model!.title!,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Kiwi'),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Text(
                      'x ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Kiwi'),
                    ),
                    Text(
                      widget.quanNumber.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Acme'),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Acme'),
                    ),
                    const Text(
                      '₦',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Acme'),
                    ),
                    Text(
                      widget.model!.price.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Acme'),
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

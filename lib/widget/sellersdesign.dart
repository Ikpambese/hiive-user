import 'package:flutter/material.dart';

import '../models/sellers.dart';
import '../screens/menus_screen.dart';

class SellersDesign extends StatefulWidget {
  Sellers? model;
  BuildContext? context;

  SellersDesign({this.model, this.context});

  @override
  _SellersDesignState createState() => _SellersDesignState();
}

class _SellersDesignState extends State<SellersDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenusScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 150,
        child: Stack(children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.model!.sellerAvatarUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.cyan,
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.model!.sellerName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Acme',
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

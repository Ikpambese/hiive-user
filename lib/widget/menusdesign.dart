// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../screens/items_screen.dart';

class MenusDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  MenusDesignWidget({super.key, this.model, this.context});

  @override
  _MenusDesignWidgetState createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to ==
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemsScrenn(model: widget.model),
          ),
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Text(
                widget.model!.menuInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
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
      child: Container(
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget
                    .model!.thumbnailUrl!, // Replace with your actual image URL
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.grey,
                )), // Placeholder while the image is loading
                errorWidget: (context, url, error) => const Icon(
                    Icons.error), // Widget to display if an error occurs
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                    color: Colors.amber,
                  ),
                ),
                Text(
                  widget.model!.menuInfo!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

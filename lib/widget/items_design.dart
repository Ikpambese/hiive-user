// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_string_escapes

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/items.dart';
import '../screens/item_details_screen.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    ItemDetailsScreen(model: widget.model))));
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
                  widget.model!.title!,
                  style: const TextStyle(
                    color: Colors.amber,
                  ),
                ),
                const Text(
                  '1 Portion',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  '₦ ${widget.model!.price!}'.toString(),
                  style: const TextStyle(
                    color: Colors.white,
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

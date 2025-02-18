// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/items.dart';
import '../models/menu_model.dart';
import '../widget/appbar.dart';
import '../widget/items_design.dart';
import '../widget/text_widget.dart';

class ItemsScrenn extends StatefulWidget {
  // ItemsScrenn({Sellers? model});
  final Menus? model;
  const ItemsScrenn({super.key, this.model});

  @override
  State<ItemsScrenn> createState() => _ItemsScrennState();
}

class _ItemsScrennState extends State<ItemsScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidget(
                title: "Items of " + widget.model!.menuTitle.toString()),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(widget.model!.sellerUID)
                .collection('menus')
                .doc(widget.model!.menuID)
                .collection('items')
                .orderBy('publishedDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: ((context, index) {
                        Items model = Items.fromJson(snapshot.data!.docs[index]
                            .data()! as Map<String, dynamic>);
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                        );
                      }),
                      childCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}

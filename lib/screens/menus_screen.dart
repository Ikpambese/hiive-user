// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../assistants/assistant_methods.dart';
import '../assistants/cartitem_counter.dart';
import '../models/menu_model.dart';
import '../models/sellers.dart';
import '../widget/menusdesign.dart';
import '../widget/text_widget.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              clearCartNow(context);
              Provider.of<CartItemCounter>(context, listen: false)
                  .displayCartListItemsNumber();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text(
          'LuncBox',
          style: TextStyle(fontSize: 45, fontFamily: 'Acme'),
        ),
        centerTitle: true,
        //automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidget(
                title: widget.model!.sellerName.toString() + ' Menus'),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(widget.model!.sellerUID)
                .collection('menus')
                .orderBy(
                  'publishedDate',
                  descending: true,
                )
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: ((context, index) {
                        Menus model = Menus.fromJson(snapshot.data?.docs[index]
                            .data()! as Map<String, dynamic>);
                        return MenusDesignWidget(
                          model: model,
                          context: context,
                        );
                      }),
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}

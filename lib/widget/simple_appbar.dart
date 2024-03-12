// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  String? title;
  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize {
    return bottom == null
        ? Size(56, AppBar().preferredSize.height)
        : Size(56, 80 + AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.amber),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 45,
            fontFamily: 'Signatra',
            letterSpacing: 3,
            color: Colors.amber),
      ),

      // automaticallyImplyLeading: false,
    );
  }
}

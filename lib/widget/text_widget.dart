import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class TextWidget extends SliverPersistentHeaderDelegate {
  String? title;
  TextWidget({this.title});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return InkWell(
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
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
        child: InkWell(
          child: Text(
            title!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
                fontFamily: 'Signatra',
                fontSize: 30,
                letterSpacing: 2,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

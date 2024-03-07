// // ignore_for_file: library_private_types_in_public_api, must_be_immutable, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:LuncBox/models/sellers.dart';


// class SellersDesign extends StatefulWidget {
//   Sellers? model;
//   BuildContext? context;

//   SellersDesign({this.model, this.context});

//   @override
//   _SellersDesignState createState() => _SellersDesignState();
// }

// class _SellersDesignState extends State<SellersDesign> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ItemsScreen(model: widget.model)));
//         // send to item screen the model at index of particaular item
//       },
//       splashColor: Colors.amber,
//       child: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: SizedBox(
//           height: 280,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Divider(
//                 height: 4,
//                 thickness: 3,
//                 color: Colors.grey[300],
//               ),
//               Image.network(
//                 widget.model!.thumbnailUrl!,
//                 height: 210.0,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(
//                 height: 1.0,
//               ),
//               Text(
//                 widget.model!.menuTitle!,
//                 style: const TextStyle(
//                   color: Colors.cyan,
//                   fontSize: 20,
//                   fontFamily: "Train",
//                 ),
//               ),
//               Text(
//                 widget.model!.menuInfo!,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                 ),
//               ),
//               Divider(
//                 height: 4,
//                 thickness: 3,
//                 color: Colors.grey[300],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

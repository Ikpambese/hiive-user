// // ignore_for_file: import_of_legacy_library_into_null_safe

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// // import 'package:vertical_stepper/vertical_stepper.dart';
// // import 'package:vertical_stepper/vertical_stepper.dart' as step;

// import '../global/global.dart';
// import '../widget/simple_appbar.dart';

// class TrackerScreen extends StatefulWidget {
//   final String? orderID;
//   const TrackerScreen({this.orderID});

//   @override
//   State<TrackerScreen> createState() => _TrackerScreenState();
// }

// class _TrackerScreenState extends State<TrackerScreen>
//     with TickerProviderStateMixin {
//   String status = '';
//   getStatus() {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(sharedPreferences!.getString('uid'))
//         .collection('orders')
//         .doc(widget.orderID)
//         .get()
//         .then((snap) {
//       setState(() {
//         status = snap.data()!['status'];
//         print('fetched');
//         print(status);
//         print('fetched');
//       });
//     });
//   }

//   List<step.Step> steps = [
//     const step.Step(
//       shimmer: false,
//       title: 'Order Placed',
//       iconStyle: Colors.green,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:20 Order Created'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Order packed',
//       iconStyle: Colors.cyan,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:25 Order Parcel Ready To Dispatch'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider underway',
//       iconStyle: Colors.grey,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel Sorted'),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider is at address',
//       iconStyle: Colors.grey,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel has Arrived at address'),
//       ),
//     ),
//   ];

//   List<step.Step> steps2 = [
//     const step.Step(
//       shimmer: false,
//       title: 'Order Placed',
//       iconStyle: Colors.green,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:20 Order Created'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Order packed',
//       iconStyle: Colors.green,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:25 Order Parcel Ready To Dispatch'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider underway',
//       iconStyle: Colors.cyan,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel Sorted'),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider is at address',
//       iconStyle: Colors.grey,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel has Arrived at address'),
//       ),
//     ),
//   ];

//   List<step.Step> steps3 = [
//     const step.Step(
//       shimmer: false,
//       title: 'Order Placed',
//       iconStyle: Colors.green,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:20 Order Created'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Order packed',
//       iconStyle: Colors.green,
//       content: Padding(
//         padding: EdgeInsets.only(left: 5),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('3/3/2023 11:25 Order Parcel Ready To Dispatch'),
//         ),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider underway',
//       iconStyle: Colors.green,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel Sorted'),
//       ),
//     ),
//     const step.Step(
//       shimmer: false,
//       title: 'Rider is at address',
//       iconStyle: Colors.green,
//       content: Align(
//         alignment: Alignment.centerLeft,
//         child: Text('3/3/2023 11:25 Parcel has Arrived at address'),
//       ),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     getStatus();

//     print('okay');
//     print(status);
//     print('workded');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SimpleAppBar(title: 'Track Parcel'),
//       body: SingleChildScrollView(child: content()),
//     );
//   }

//   Widget content() {
//     return Column(
//       children: [
//         Container(
//           height: 300,
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(50),
//                 bottomRight: Radius.circular(50),
//               )),
//           child: Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 30.0),
//               child: Column(children: [
//                 Image.network(
//                   'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT6Yc_N3xC9akfMD4yRs9kwCBKoaRrie9z-Rg&usqp=CAU',
//                   height: 200,
//                 ),
//                 const Text(
//                   'Parcel Tracker',
//                   style: TextStyle(
//                     fontSize: 30,
//                   ),
//                 )
//               ]),
//             ),
//           ),
//         ),
//         body()
//       ],
//     );
//   }

//   Widget body() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 50),
//         const Padding(
//           padding: EdgeInsets.only(left: 35),
//           child: Text(
//             'Tracking Number :',
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
//           child: Row(
//             children: [
//               Container(
//                 height: 50,
//                 width: 280,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                       hintText: 'eg #12344556677765'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Icon(
//                 Icons.search,
//                 color: Colors.cyan,
//                 size: 40,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(35, 2, 31, 0),
//           child: Row(
//             children: const [
//               Text(
//                 'Result :',
//                 style: TextStyle(fontSize: 25),
//               ),
//               Spacer(),
//               Icon(
//                 Icons.close,
//                 size: 25,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),

//         Padding(
//           padding: const EdgeInsets.fromLTRB(15, 2, 15, 0),
//           child: Column(
//             children: [
//               status == 'normal'
//                   ? VerticalStepper(
//                       steps: steps,
//                       dashLength: 2,
//                     )
//                   : status == 'packed'
//                       ? VerticalStepper(
//                           steps: steps2,
//                           dashLength: 2,
//                         )
//                       : status == 'ended'
//                           ? VerticalStepper(
//                               steps: steps3,
//                               dashLength: 2,
//                             )
//                           : const SizedBox(),
//             ],
//           ),
//         )
//         // : Transform(
//         //     transform: Matrix4.translationValues(0, -50, 0),
//         //     child: Lottie.network(
//         //         'https://assets2.lottiefiles.com/packages/lf20_t24tpvcu.json'),
//         //   ),
//       ],
//     );
//   }
// }

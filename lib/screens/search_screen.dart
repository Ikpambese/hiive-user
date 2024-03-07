import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/sellers.dart';
import '../widget/sellersdesign.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? restaurantDocumentList;
  String sellerNameText = '';
  initSearchingRestaurant(String textEntered) {
    restaurantDocumentList = FirebaseFirestore.instance
        .collection('sellers')
        .where('sellerName', isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.cyan,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.search,
                    color: Colors.cyan,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          onChanged: (textEntered) {
                            setState(() {
                              sellerNameText = textEntered;
                            });
                            initSearchingRestaurant(textEntered);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Restaurant Here',
                            hintStyle: const TextStyle(color: Colors.cyan),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {
                                initSearchingRestaurant(sellerNameText);
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: restaurantDocumentList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Sellers model = Sellers.fromJson(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);

                      return SellersDesign(
                        context: context,
                        model: model,
                      );
                    })
                : const Center(
                    child: Text('No record found'),
                  );
          }),
    );
  }
}


// Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ]),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                   ),
//                   child: Row(children: [
//                     const Icon(
//                       CupertinoIcons.search,
//                       color: Colors.cyan,
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: 50,
//                         width: 300,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 15,
//                           ),
//                           child: TextFormField(
//                             decoration: const InputDecoration(
//                                 hintText: 'What would you love to have?',
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Icon(
//                       Icons.filter_list,
//                     )
//                   ]),
//                 ),
//               ),
//             ),
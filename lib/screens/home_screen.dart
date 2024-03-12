import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../models/sellers.dart';
import '../splash/splash_screen.dart';
import '../widget/bottom_nav.dart';
import '../widget/my_drawer.dart';
import '../widget/progress_bar.dart';
import '../widget/sellersdesign.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    'images/0.jpg',
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
    'images/6.jpg',
    'images/7.jpg',
    'images/8.jpg',
    'images/9.jpg',
    'images/10.jpg',
    'images/11.jpg',
    'images/12.jpg',
    'images/13.jpg',
    'images/14.jpg',
    'images/15.jpg',
    'images/16.jpg',
    'images/17.jpg',
    'images/18.jpg',
    'images/19.jpg',
    'images/20.jpg',
    'images/21.jpg',
    'images/22.jpg',
    'images/23.jpg',
    'images/24.jpg',
    'images/25.jpg',
    'images/26.jpg',
    'images/27.jpg',
  ];

  @override
  void initState() {
    super.initState();
    restrictctBlockedeUser();
    //clearCartNow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.2),
              offset: Offset.zero,
            )
          ]),
          height: 100,
          child: const ButtomNav(),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Hiive',
          style: TextStyle(
              fontSize: 40, fontFamily: 'Signatra', color: Colors.amber),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 5),
            child: ClipOval(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ClipOval(
                    child: Image.network(
                      sharedPreferences!.getString('photoUrl')!,
                      height: 100,
                      width: 100,
                    ),
                  )),
            ),
          ),
        ],
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .3,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context) {
                      return Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                index,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  sharedPreferences!.getString('name')!.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Kitchen',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      '....',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          )),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("sellers").snapshots(),
            builder: (context, snapshot) {
              print("FETCHING DATA IF AVAILABLE+++++++++++++++++");
              print(snapshot.data?.docs);
              print("GOT DATA IF AVAILABLE+++++++++++++++++");
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Sellers sModel = Sellers.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>);
                        //design for display sellers-cafes-restuarents
                        return SellersDesign(
                          model: sModel,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }

  restrictctBlockedeUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!['userSatus'] != 'approved') {
        Fluttertoast.showToast(
            msg: 'You have been blocked \n\n Mail Here : admin@lunchbox.com');
        firebaseAuth.signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MySplashScreen()));
      } else {
        clearCartNow(context);
      }
    });
  }
}

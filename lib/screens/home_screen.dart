import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../models/sellers.dart';
import '../splash/splash_screen.dart';
import '../widget/bottom_nav.dart';
import '../widget/my_drawer.dart';
import '../widget/sellersdesign.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();

    restrictctBlockedeUser();
    clearCartNow(context);
    getCompany();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(),
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Hiive',
              textStyle: const TextStyle(
                fontSize: 40,
                fontFamily: 'Signatra',
                fontWeight: FontWeight.bold,
              ),
              colors: const [
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
                Colors.amber,
              ],
            ),
          ],
          isRepeatingAnimation: true,
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.amber.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 5),
            child: Hero(
              tag: 'profilePic',
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    sharedPreferences?.getString('photoUrl') ??
                        'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Carousel Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * .25,
                      viewportFraction: 0.9,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                    ),
                    items: [
                      'images/1.jpg',
                      'images/2.jpg',
                      'images/3.jpg',
                      'images/4.jpg',
                    ].map((index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(index),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      ).createShader(bounds),
                      child: const Text(
                        'Select Kitchen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sellers Grid
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .where('sellerSatus', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(15),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Sellers sModel = Sellers.fromJson(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>);
                              return SellersDesign(
                                model: sModel,
                                context: context,
                              );
                            },
                            childCount: snapshot.data!.docs.length,
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
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
            msg:
                'You have been blocked \n\n Mail Here : hiiveallapps@gmail.com');
        firebaseAuth.signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MySplashScreen()));
      } else {
        clearCartNow(context);
      }
    });
  }

  Future<void> getCompany() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('internal').get();
    final List<Map<String, dynamic>> documents =
        snapshot.docs.map((doc) => doc.data()).toList();
    for (var data in documents) {
      int logistics = data['logistics'];
      String message = data['message'];
      await sharedPreferences!.setInt('logistics', logistics);
      await sharedPreferences!.setString('message', message);
      print('Logistics: $logistics');
      print('Message: $message');
    }
  }
}

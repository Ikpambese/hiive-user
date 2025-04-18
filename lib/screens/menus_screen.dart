// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../assistants/assistant_methods.dart';
import '../assistants/cartitem_counter.dart';
import '../models/menu_model.dart';
import '../models/sellers.dart';
import '../widget/menusdesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/auth_screen.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  // Add the protected feature handler
  void _handleProtectedFeature(BuildContext context, VoidCallback action) {
    if (FirebaseAuth.instance.currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to access this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text('Login', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      );
    } else {
      action();
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
// Remove this line as it's calling an undefined action
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.amber.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => _handleProtectedFeature(context, () {
            clearCartNow(context);
            Provider.of<CartItemCounter>(context, listen: false)
                .displayCartListItemsNumber();
            Navigator.pop(context);
          }),
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'restaurantLogo',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: NetworkImage(widget.model!.sellerAvatarUrl!),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Acme',
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
            onPressed: () {
              _showRestaurantInfo();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildCategoryChip('All', true),
                        _buildCategoryChip('Popular', false),
                        _buildCategoryChip('Recommended', false),
                        _buildCategoryChip('New Items', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(widget.model!.sellerUID)
                .collection('menus')
                .orderBy('publishedDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemBuilder: ((context, index) {
                    Menus model = Menus.fromJson(
                      snapshot.data?.docs[index].data()!
                          as Map<String, dynamic>,
                    );
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: MenusDesignWidget(
                        model: model,
                        context: context,
                        handleProtectedFeature: _handleProtectedFeature,
                      ),
                    );
                  }),
                  childCount: snapshot.data!.docs.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sellers')
            .doc(widget.model!.sellerUID)
            .collection('menus')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return FloatingActionButton.extended(
            onPressed: () => _handleProtectedFeature(context, () {
              // Add your cart navigation logic here
            }),
            backgroundColor: Colors.amber,
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Cart'),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.amber,
        onSelected: (bool selected) {
          // Handle category selection
        },
        elevation: 0,
        pressElevation: 2,
      ),
    );
  }

  void _showRestaurantInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.location_on_rounded, color: Colors.amber),
              // add location to model
              title: Text(widget.model!.sellerName ?? 'Address not available'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.access_time_rounded, color: Colors.amber),
              title: const Text('Opening Hours: 9:00 AM - 10:00 PM'),
            ),
            // Add more restaurant information as needed
          ],
        ),
      ),
    );
  }
}

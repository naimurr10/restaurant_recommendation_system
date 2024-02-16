//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/add_restaurant.dart';
import 'package:restaurant_recommendation/app/restaurant_details_page.dart';
import 'package:restaurant_recommendation/app/favourite_page.dart';
import 'package:restaurant_recommendation/app/user_profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  String searchQuery = '';
  String? foodFilter;
  String? locationFilter;

  //filter the restaurants by food and location
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Filter by food
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Food',
                  ),
                  onChanged: (value) {
                    foodFilter = value;
                  },
                ),
                SizedBox(height: 16.0),
                // Filter by location
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Location',
                  ),
                  onChanged: (value) {
                    locationFilter = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Close the dialog
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Reset the filters
            TextButton(
              child: Text('Reset Filters'),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  foodFilter = null;
                  locationFilter = null;
                });
                Navigator.of(context).pop();
              },
            ),
            // Apply the filters
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //navigate to favorite page
  void _showFavoritePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavouritePage()), //favourite page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Restaurants',
        onFilterPressed: _showFilterDialog,
        onFavoritePressed: _showFavoritePage,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // Search bar
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for restaurants by name',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          //--------------------------
          // List of restaurants
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final documents = snapshot.data!.docs.where((document) {
                final restaurant = document.data() as Map<String, dynamic>;
                final name = restaurant['name'] as String? ?? '';
                final foods = restaurant['foods'] as List<dynamic>? ?? [];
                final location = restaurant['location_text'] as String? ?? '';

                bool nameMatch = true;
                bool foodMatch = true;
                bool locationMatch = true;

                //search by restaurant name
                if (searchQuery.isNotEmpty) {
                  nameMatch =
                      name.toLowerCase().contains(searchQuery.toLowerCase());
                }

                //search by food = filter restaurants by foods
                if (foodFilter != null && foodFilter!.isNotEmpty) {
                  foodMatch = foods.any((food) => food
                      .toString()
                      .toLowerCase()
                      .contains(foodFilter!.toLowerCase()));
                }
                //search by location = filter restaurants by location
                if (locationFilter != null && locationFilter!.isNotEmpty) {
                  final locationQueries =
                      locationFilter!.toLowerCase().split(' ');
                  locationMatch = locationQueries
                      .any((query) => location.toLowerCase().contains(query));
                }

                return nameMatch && foodMatch && locationMatch;
              }).toList();

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final restaurant =
                      documents[index].data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailsPage(
                            restaurantId: documents[index].id,
                          ),
                        ),
                      );
                      // navigate to full details page for the restaurant
                    },
                    //restaurants displayed in card with informations
                    child: Card(
                      elevation: 4.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0)),
                              image: DecorationImage(
                                image:
                                    NetworkImage(restaurant['image_url'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant["name"] ?? '',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  restaurant['details'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Foods available: ${restaurant['foods'] != null ? (restaurant['foods'] is List<dynamic> ? (restaurant['foods'] as List<dynamic>).join(', ') : restaurant['foods']) : ''}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
      //--------------------------
      // floating action buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floating action button for restaurant recommendation
      //this button will show random restaurants from the database
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final QuerySnapshot snapshot =
              await FirebaseFirestore.instance.collection('restaurants').get();
          final int count = snapshot.size;
          final int randomIndex = Random().nextInt(count);
          final DocumentSnapshot randomRestaurant = snapshot.docs[randomIndex];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailsPage(
                restaurantId: randomRestaurant.id,
              ),
            ),
          );
        },
        child: Icon(Icons.restaurant_menu_rounded),
        backgroundColor: Color.fromARGB(255, 26, 7, 29),
      ),

      //--------------------------
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // -----------------------------------
            //home button which will refresh the home page
            IconButton(
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  foodFilter = null;
                  locationFilter = null;
                });
              },
              icon: const Icon(Icons.home),
              color: Colors.deepPurple,
            ),
            //-----------------------------------
            // add restaurant button to add restaurants
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRestaurantPage()),
                );
              },
              icon: const Icon(Icons.add),
              color: Colors.deepPurple,
            ),

            //-----------------------------------
            // Add the user profile button here
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
              icon: const Icon(Icons.account_box_rounded),
              color: Colors.deepPurple,
            ),
            //-----------------------------------
            // sign out button
            IconButton(
              // after pressing this button the user will be signed out and will be redirected to the sign in page
              onPressed: () async {
                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final bool confirmSignOut = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign Out'),
                        content: Text(
                            'Are you sure you want to sign out as ${user.email}?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmSignOut) {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You have been signed out.'),
                      ),
                    );
                  }
                }
              },
              icon: Icon(Icons.logout_sharp),
              color: Colors.deepPurple,
            ),
          ],
        ),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onFavoritePressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onFilterPressed,
    this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        if (onFilterPressed != null)
          IconButton(
            icon: Icon(Icons.filter_list_sharp), //filter list icon
            onPressed: onFilterPressed,
          ),
        if (onFavoritePressed != null)
          IconButton(
            icon: Icon(Icons.favorite), //favorite icon
            color: Colors.redAccent,
            onPressed: onFavoritePressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

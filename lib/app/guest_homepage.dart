//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/restaurant_details_page.dart';

class GuestHomePage extends StatefulWidget {
  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list_sharp), //filter list icon
            onPressed: _showFilterDialog,
          ),
        ],
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
              child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('restaurants').get(),
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
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        // User is not authenticated, show alert dialog.
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Please sign in or create an account to view restaurant details.'),
                              actions: [],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantDetailsPage(
                              restaurantId: documents[index].id,
                            ),
                          ),
                        );
                      }
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
    );
  }
}

//--------------------------
// floating action buttons

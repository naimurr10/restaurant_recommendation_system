//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/restaurant_details_page.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Stream<QuerySnapshot> _favouritesStream;

  @override
  void initState() {
    // Get the user's favourite restaurants from the Firebase Firestore
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _favouritesStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .snapshots();
    } else {
      _favouritesStream = Stream.empty();
    }
  }

  @override
  // Display the user's favourite restaurants using a StreamBuilder
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Restaurants'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _favouritesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Get the favourite restaurants from the snapshot
          final favourites = snapshot.data!.docs;

          // Display a message if there are no favourites
          if (favourites.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ),
                child: Text(
                  'You have no favourite restaurants yet.',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Display the favourite restaurants
          return ListView.builder(
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final restaurantData =
                  favourites[index].data() as Map<String, dynamic>;

              // Display the restaurant data using a ListTile
              return ListTile(
                title: restaurantData['name'] != null
                    ? Text(restaurantData['name'])
                    : SizedBox.shrink(), // Hide if it's null
                subtitle: restaurantData['location_text'] != null
                    ? Text(restaurantData['location_text'])
                    : SizedBox.shrink(), // Hide if it's null
                leading: restaurantData['image_url'] != null
                    ? Image.network(
                        restaurantData['image_url'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    _removeFromFavorites(favourites[index].id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailsPage(
                        restaurantId: favourites[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Remove a restaurant from the user's favourites
  Future<void> _removeFromFavorites(String restaurantId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(restaurantId)
          .delete();
    }
  }
}

//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/mailpass.dart';
import 'package:restaurant_recommendation/app/restaurant_details_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser; // get current user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the ChangeEmailPasswordPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailPasswordPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream the restaurants added by the current user from Firestore
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .where('user_id', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle errors in the snapshot
            print('Error in snapshot: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot
              .data!.docs; // Get the list of documents from the snapshot
          print('Number of documents: ${documents.length}');

          // Display a message if there are no restaurants added by the user
          if (documents.isEmpty) {
            return Center(
              child: Text('No restaurants added by you.'),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final restaurant =
                  documents[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // onTap function to navigate to the RestaurantDetailsPage when the card is tapped
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsPage(
                          restaurantId: documents[index].id,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {}); // rebuild the UI if changes were made
                    }
                  },
                  // Display restaurant details inside the Card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (restaurant['image_url'] !=
                          null) // Display restaurant image if available
                        Image.network(
                          restaurant['image_url'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          restaurant['name'] ?? '', // Display restaurant name
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (restaurant['location_text'] !=
                          null) // Display restaurant location
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            restaurant['location_text'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

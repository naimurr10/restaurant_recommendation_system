//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_recommendation/app/edit_restaurant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:restaurant_recommendation/app/favourite_page.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String restaurantId;

  RestaurantDetailsPage({required this.restaurantId});

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  late Future<DocumentSnapshot> _restaurantFuture;
  final GlobalKey<FormState> _reviewFormKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  bool _isFavourite = false;
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _restaurantFuture = _fetchRestaurant();
    //fetches the restaurant data from Firestore using the widget's restaurantId property
    _checkIfFavourite(); // to check if user favourite the resturant or not
  }

  void _editRestaurant() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditRestaurantPage(restaurantId: widget.restaurantId),
      ),
    );
  }

  // Method to fetch the restaurant data from Firestore
  Future<DocumentSnapshot> _fetchRestaurant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not authenticated, show error message or prompt to sign in.
      throw Exception('User is not authenticated');
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .get();

      if (!snapshot.exists) {
        // Restaurant document does not exist, show error message or redirect to home page.
        throw Exception('Restaurant not found');
      }

      return snapshot; // Return the document snapshot for the restaurant.
    } catch (e) {
      // Error occurred while fetching data from Firestore, show error message or log the error.
      throw Exception('Error fetching restaurant details: $e');
    }
  }

  // Method to check if the restaurant is in the user's favourites list
  Future<void> _checkIfFavourite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(widget.restaurantId)
          .get();
      setState(() {
        _isFavourite = snapshot.exists;
      });
    }
  }

  // Method to toggle the restaurant's favourite status for the user
  Future<void> _toggleFavourite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_isFavourite) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favourites')
            .doc(widget.restaurantId)
            .delete();
      } else {
        final restaurant = await _fetchRestaurant();
        final restaurantData = restaurant.data() as Map<String, dynamic>;
        final favouriteData = {
          'name': restaurantData['name'],
          'location_text': restaurantData['location_text'],
          'image_url': restaurantData['image_url'],
          'added_on': DateTime.now(),
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favourites')
            .doc(widget.restaurantId)
            .set(favouriteData);
      }
      setState(() {
        _isFavourite = !_isFavourite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Restaurant Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editRestaurant,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Handle error by displaying an error message to the user
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final restaurant = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            children: [
              Image.network(
                restaurant['image_url'] ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          restaurant['name'] ?? '',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: _isFavourite ? Colors.red : null,
                          onPressed: _toggleFavourite,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      restaurant['details'] ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Foods Available',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _getFoodsAsString(restaurant['foods']),
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      restaurant['location_text'] ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Rate this restaurant',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 35.0,
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Write a review',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: _reviewFormKey,
                      child: TextFormField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          labelText: 'Your review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        validator: (value) => value!.isEmpty
                            ? 'Please write a review'
                            : null, //valication check
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _submitReview();
                      },
                      child: Text('Submit Review'),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Reviews and Ratings',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(widget.restaurantId)
                          .collection('reviews')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final reviews = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final reviewData =
                                reviews[index].data() as Map<String, dynamic>;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${reviewData['user_name']} (${reviewData['rating']} stars)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(reviewData['review']),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _launchMaps(restaurant['location_map'] ?? '');
                        },
                        icon: Icon(Icons.local_restaurant_rounded),
                        label: Text('Open in Google Maps'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 15, 4, 46), // Choose the button color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Method to submit a review for the restaurant
  Future<void> _submitReview() async {
    if (_reviewFormKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userName = user.displayName ?? user.email;
        final review = {
          'user_id': user.uid,
          'user_name': userName,
          'rating': _rating,
          'review': _reviewController.text,
          'timestamp': DateTime.now(),
        };

        final reviewCollection = FirebaseFirestore.instance
            .collection('restaurants')
            .doc(widget.restaurantId)
            .collection('reviews');

        // Check if user has already reviewed the restaurant
        final existingReviewQuery =
            await reviewCollection.where('user_id', isEqualTo: user.uid).get();
        if (existingReviewQuery.docs.isNotEmpty) {
          // User has already reviewed the restaurant, update the existing review
          final existingReviewId = existingReviewQuery.docs.first.id;
          await reviewCollection.doc(existingReviewId).update(review);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review updated successfully')),
          );
        } else {
          // User has not reviewed the restaurant, add a new review
          await reviewCollection.add(review);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review submitted successfully')),
          );
        }

        _reviewController.clear();
        setState(() {
          _rating = 0;
        });
      }
    }
  }

  // Method to launch Google Maps with the restaurant's location
  Future<void> _launchMaps(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }
}

//function to convert the 'foods' list to a comma-separated string
String _getFoodsAsString(dynamic foods) {
  if (foods is List<dynamic>) {
    return foods.join(', ');
  } else {
    return foods.toString();
  }
}

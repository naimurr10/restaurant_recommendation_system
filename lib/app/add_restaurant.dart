//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRestaurantPage extends StatefulWidget {
  @override
  _AddRestaurantPageState createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // define variables to store the form input values
  String _restaurantName = '';
  String _restaurantDetails = '';
  List<String> foodsAvailable = [];
  File? _restaurantImage;
  String _restaurantLocationText = '';
  String _restaurantLocationMap = '';

  // method to get an image from the device's gallery or camera
  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _restaurantImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Restaurant')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // text input fields for restaurant name and details
                TextFormField(
                  decoration: InputDecoration(labelText: 'Restaurant Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => _restaurantName = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Restaurant Details'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => _restaurantDetails = value!,
                ),
                SizedBox(height: 16),
                SizedBox(height: 16.0),
                //-----------------------------------------
                // each filter chip represents a food item
                Text('Foods Available', style: TextStyle(color: Colors.black)),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label:
                          Text('Pizza', style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Pizza'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Pizza');
                          } else {
                            foodsAvailable.remove('Pizza');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label:
                          Text('Burger', style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Burger'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Burger');
                          } else {
                            foodsAvailable.remove('Burger');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('Nasi Lemak',
                          style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Nasi Lemak'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Nasi Lemak');
                          } else {
                            foodsAvailable.remove('Nasi Lemak');
                          }
                        });
                      },
                    ),
                    //
                    FilterChip(
                      label:
                          Text('Sushi', style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Sushi'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Sushi');
                          } else {
                            foodsAvailable.remove('Sushi');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('Roti Canai',
                          style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Roti Canai'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Roti Canai');
                          } else {
                            foodsAvailable.remove('Roti Canai');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('Nasi Goreng',
                          style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Nasi Goreng'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            foodsAvailable.add('Nasi Goreng');
                          } else {
                            foodsAvailable.remove('Nasi Goreng');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('Ayam goreng',
                          style: TextStyle(color: Colors.black)),
                      selected: foodsAvailable.contains('Ayam goreng'),
                      onSelected: (selected) {
                        setState(
                          () {
                            if (selected) {
                              foodsAvailable.add('Ayam goreng');
                            } else {
                              foodsAvailable.remove('Ayam goreng');
                            }
                          },
                        );
                      },
                    ),
                    FilterChip(
                      label: Text(
                        'Tacos',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: foodsAvailable.contains('Tacos'),
                      onSelected: (selected) {
                        setState(
                          () {
                            if (selected) {
                              foodsAvailable.add('Tacos');
                            } else {
                              foodsAvailable.remove('Tacos');
                            }
                          },
                        );
                      },
                    ),
                    FilterChip(
                      label: Text(
                        'Fried chicken',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: foodsAvailable.contains('Fried chicken'),
                      onSelected: (selected) {
                        setState(
                          () {
                            if (selected) {
                              foodsAvailable.add('Fried chicken');
                            } else {
                              foodsAvailable.remove('Fried chicken');
                            }
                          },
                        );
                      },
                    ),
                    FilterChip(
                      label: Text(
                        'Otak-Otak',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: foodsAvailable.contains('Otak-Otak'),
                      onSelected: (selected) {
                        setState(
                          () {
                            if (selected) {
                              foodsAvailable.add('Otak-Otak');
                            } else {
                              foodsAvailable.remove('Otak-Otak');
                            }
                          },
                        );
                      },
                    ),
                    FilterChip(
                      label: Text(
                        'Satay ',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: foodsAvailable.contains('Satay '),
                      onSelected: (selected) {
                        setState(
                          () {
                            if (selected) {
                              foodsAvailable.add('Satay ');
                            } else {
                              foodsAvailable.remove('Satay ');
                            }
                          },
                        );
                      },
                    ),
                    // foods available
                    //-----------------------------------------
                  ],
                ),
                // text input fields for other foods
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Other Foods Available',
                    helperText: 'Enter multiple foods separated by commas ","',
                  ),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Split the value into separate foods based on the comma delimiter
                      final foods = value.split(',');
                      // Add each food to the foodsAvailable list
                      foodsAvailable.addAll(foods);
                    }
                  },
                ),

                // text input fields for restaurant location
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Restaurant Location (Text)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                  onSaved: (value) => _restaurantLocationText = value!,
                ),
                // text input fields for restaurant location link google maps
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Restaurant Location (Google Maps Link)'),
                  onSaved: (value) => _restaurantLocationMap = value!,
                ),

                // text input fields for restaurant image
                SizedBox(height: 16),
                Text(
                  'Restaurant Image',
                  style: TextStyle(color: Colors.black),
                ),
                if (_restaurantImage == null)
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    child: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                else
                  Column(
                    children: [
                      Image.file(
                        _restaurantImage!,
                        height: 150,
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              _restaurantImage = null;
                            },
                          );
                        },
                        child: Text(
                          'Remove Image',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_restaurantImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select an image'),
                        ),
                      );
                    } else {
                      _submitForm();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // upload image
      String? imageUrl;
      if (_restaurantImage != null) {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('restaurant_images')
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        final uploadTask = storageReference.putFile(_restaurantImage!);
        final taskSnapshot = await uploadTask.whenComplete(() {});
        imageUrl = await taskSnapshot.ref.getDownloadURL();
        //here the image get stored in firebase storage in 'restaurant_images'
        //then the image url is stored in 'image_url' in firestore database
      }
      // create restaurant
      final restaurant = {
        'name': _restaurantName,
        'details': _restaurantDetails,
        'foods': foodsAvailable,
        'image_url': imageUrl,
        'location_text': _restaurantLocationText,
        'location_map': _restaurantLocationMap,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
      };
      // add restaurant in 'restaurants' in firestore database
      await FirebaseFirestore.instance
          .collection('restaurants')
          .add(restaurant);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant added successfully')),
      );
      Navigator.pop(context);
    }
  }
}

//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditRestaurantPage extends StatefulWidget {
  final String restaurantId;

  EditRestaurantPage({required this.restaurantId});

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _detailsController;
  TextEditingController? _foodsController;
  TextEditingController? _locationTextController;
  TextEditingController? _locationMapController;
  TextEditingController? _imageUrlController;

  bool _userHasPermission = false;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _detailsController = TextEditingController();
    _foodsController = TextEditingController();
    _locationTextController = TextEditingController();
    _locationMapController = TextEditingController();
    _imageUrlController = TextEditingController();
    _fetchRestaurant();
  }

  @override
  // dispose
  void dispose() {
    _nameController!.dispose();
    _detailsController!.dispose();
    _foodsController!.dispose();
    _locationTextController!.dispose();
    _locationMapController!.dispose();
    _imageUrlController!.dispose();
    super.dispose();
  }

  // Method to fetch the restaurant data from Firestore
  Future<void> _fetchRestaurant() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .get();
    final restaurant = snapshot.data() as Map<String, dynamic>;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print('Current user UID: ${currentUser.uid}');
      print('Restaurant user UID: ${restaurant['user_id']}');
      if (currentUser.uid == restaurant['user_id']) {
        setState(() {
          _userHasPermission = true;
        });
      } else {
        setState(() {
          _userHasPermission = false;
        });
      }
    } else {
      setState(() {
        _userHasPermission = false;
      });
    }

    _nameController!.text = restaurant['name'] ?? '';
    _detailsController!.text = restaurant['details'] ?? '';
    _foodsController!.text = _getFoodsAsString(restaurant['foods'] ?? []);
    _locationTextController!.text = restaurant['location_text'] ?? '';
    _locationMapController!.text = restaurant['location_map'] ?? '';
    _imageUrlController!.text = restaurant['image_url'] ?? '';
  }

  // Get a list of foods as a string
  String _getFoodsAsString(List<dynamic> foods) {
    return foods.join(', ');
  }

  // Pick an image from the device's gallery
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Upload an image
  Future<String?> _uploadImage(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final reference =
        FirebaseStorage.instance.ref().child('restaurants/$fileName');
    final uploadTask = reference.putFile(file);
    final taskSnapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  @override
  // Widget build
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Restaurant')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //input the restaurant name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Restaurant Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                //input the restaurant details
                TextFormField(
                  controller: _detailsController,
                  decoration: InputDecoration(labelText: 'Restaurant Details'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                //input the available foods
                TextFormField(
                  controller: _foodsController,
                  decoration: InputDecoration(labelText: 'Foods Available'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                //input the restaurant location
                TextFormField(
                  controller: _locationTextController,
                  decoration:
                      InputDecoration(labelText: 'Restaurant Location (Text)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                //input the restaurant location link from google maps
                TextFormField(
                  controller: _locationMapController,
                  decoration: InputDecoration(
                      labelText: 'Restaurant Location (Google Maps Link)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ),
                SizedBox(height: 16),
                //input the restaurant image from gallery
                _image == null
                    ? _imageUrlController!.text.isEmpty
                        ? Text('No image selected.')
                        : Image.network(_imageUrlController!.text)
                    : Image.file(_image!),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text('Add Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                          _imageUrlController!.text = '';
                        });
                      },
                      child: Text('Remove Image'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _userHasPermission
                    ? ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_image != null) {
                              final imageUrl = await _uploadImage(_image!);
                              _imageUrlController!.text = imageUrl ?? '';
                            }
                            _submitForm();
                          }
                        },
                        child: Text('Save'),
                      )
                    : Text(
                        // if user does not have permission
                        'You do not have permission to edit this restaurant.',
                        style: TextStyle(color: Colors.red),
                      ),
                SizedBox(height: 16),
                _userHasPermission
                    ? ElevatedButton(
                        onPressed: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              // if user confirms
                              title: Text('Confirm Deletion'),
                              content: Text(
                                  'Are you sure you want to delete this restaurant?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                ),
                              ],
                            ),
                          );
                          if (confirmDelete == true) {
                            await FirebaseFirestore.instance
                                .collection('restaurants')
                                .doc(widget.restaurantId)
                                .delete();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Restaurant deleted successfully'),
                            ));
                          }
                        },
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Submit the form
  Future<void> _submitForm() async {
    final updatedRestaurant = {
      'name': _nameController!.text,
      'details': _detailsController!.text,
      'foods': _getFoodsAsList(_foodsController!.text),
      'location_text': _locationTextController!.text,
      'location_map': _locationMapController!.text,
      'image_url': _imageUrlController!.text,
    };
    await FirebaseFirestore.instance // Update the restaurant
        .collection('restaurants')
        .doc(widget.restaurantId)
        .update(updatedRestaurant);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restaurant updated successfully'),
      ),
    );
    Navigator.pop(context);
  }

  // Get a list of foods
  List<String> _getFoodsAsList(String foodsAsString) {
    return foodsAsString.split(',').map((s) => s.trim()).toList();
  }
}

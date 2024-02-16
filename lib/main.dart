//----------------------------------------------------------------------------------------
//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805
//Program Name: restaurant_recommendation
//First Written on: 05-January-2023
//Edited on: Sunday, 30-April-2023
//File name: main.dart

//---------------------------------------------------------------------------------------
//before running this code need to type - flutter pub upgrade (in the terminal)
//to reduce size flutter clean was used
//---------------------------------------------
// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for data storage
import 'package:flutter/material.dart'; // Material Design widgets
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:restaurant_recommendation/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core functionality

// Main function of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that all the widgets are initialized before running the app
  await Firebase.initializeApp(); // Initialize Firebase in the application

  runApp(const MyApp()); // Start the app with MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'restaurant_recommendation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MainPage(), // MainPage checks if the user is logged in or not
    );
  }
}

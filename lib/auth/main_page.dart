//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

// Import necessary packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/page1.dart';
import 'package:restaurant_recommendation/auth/auth_page.dart';

//this page will check if I logged in or not

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // FirebaseAuth.instance.authStateChanges() provides a stream of authentication state changes
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(); // If the snapshot has data (user is logged in), return HomePage
          } else {
            return AuthPage(); // If the snapshot doesn't have data (user is not logged in), return AuthPage
          }
        },
      ),
    );
  }
}

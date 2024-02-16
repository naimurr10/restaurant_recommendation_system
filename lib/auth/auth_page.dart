//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

// Import necessary packages
import 'package:flutter/material.dart';
import 'package:restaurant_recommendation/app/register_page.dart';
import '../app/sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially show me the login page
  bool showLoginPage = true;

  void toggleScreens() {
    // Function to toggle between login and register screens
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
      // If showLoginPage is true, return LoginPage and pass the toggleScreens function as a callback
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
      // If showLoginPage is false, return RegisterPage and pass the toggleScreens function as a callback
    }
  }
}

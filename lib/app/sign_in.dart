//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

// import necessary packages

import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:flutter/material.dart'; // Material Design widgets
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package for custom fonts
import 'package:lottie/lottie.dart'; // Lottie animations package
import 'package:restaurant_recommendation/app/guest_homepage.dart';
import 'about_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers for email and password input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false; //to make the passoword visible
  String? _errorMessage; // String to store an error message if there is one

  // signIn function to sign in the user using FirebaseAuth
  Future signIn() async {
    //email and password text field cannot be empty
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(
        () {
          _errorMessage = 'Email and password cannot be empty.';
        },
      );
      return;
    }

    // Try to sign in with the provided email and password
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Handle specific FirebaseAuthException errors
        if (e.code == 'user-not-found') {
          setState(
            () {
              _errorMessage = 'Email is incorrect.';
            },
          );
        } else if (e.code == 'wrong-password') {
          setState(
            () {
              _errorMessage = 'Wrong password provided for that user.';
            },
          );
        }
      } else {
        setState(
          () {
            // Handle any other errors that might occur
            _errorMessage = 'An error occurred while signing in: $e';
          },
        );
      }
    }
  }

  @override
  // Dispose of the text controllers when the widget is disposed
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display a Lottie animation at the top
                Lottie.network(
                    'https://assets8.lottiefiles.com/packages/lf20_Eh4ZBX.json'),
                SizedBox(height: 55),

                //--------------------------
                //Display text at the top of the screen
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GuestHomePage(),
                          ));
                      // Navigate to guest home page
                    },
                    child: Text(
                      'Guest Login',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                Text(
                  'Hello Foodie!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                //SizedBox(height: 10),
                //--------------------------
                const Text(
                  'Welcome back!!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 25),

                //--------------------------
                //email textfield
                // Email input field with styling
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
                        fillColor: Colors.white,
                        filled: true),
                  ),
                ),
                //),
                // ),
                //  ),
                SizedBox(height: 10),
                // Display error message if there is one

                //--------------------------
                //password textfield
                //Password input field with styling and visibility toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: !_passwordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text('Password'),
                        prefixIcon: Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              print('Password visibility toggled');
                              _passwordVisible =
                                  !_passwordVisible; // toggle the password visibility
                            });
                          },
                        ),
                        hintText: 'Password',
                        fillColor: Colors.white,
                        filled: true),
                  ),
                ),
                SizedBox(height: 10),

                // Display error message if there is one
                _errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),

                //--------------------------
                //Forgot password text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 107, 84, 146),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                //--------------------------
                //sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 107, 84, 146),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                //--------------------------
                //register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        ' Register Now',
                        style: TextStyle(
                            color: Color.fromARGB(255, 107, 84, 146),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                //--------------------------
                //learn page button
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Learn more about ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearnPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Restora',
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 84, 146),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

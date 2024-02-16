//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'about_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false; //
  bool _confirmPasswordVisible = false; //to make the passoword visible
  final _formKey = GlobalKey<FormState>();

  @override
  // dispose the controllers when the state object is removed
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle user registration
  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // Handle weak password
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The password provided is too weak.'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          // Handle existing account
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The account already exists for that email.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  // Build the RegisterPage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                    // Add an animation to the page
                    'https://assets9.lottiefiles.com/packages/lf20_bqnjxnmy.json',
                    height: 250,
                    width: 1000,
                  ),
                  SizedBox(height: 55),

                  //--------------------------
                  // Add a greeting text
                  Text(
                    'Hello Foodie!',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                    ),
                  ),
                  SizedBox(height: 10),

                  //--------------------------
                  // Add a greeting text
                  const Text(
                    'Register below!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 35),

                  //--------------------------
                  //email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
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
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  //),
                  // ),
                  //  ),
                  SizedBox(height: 10),

                  //--------------------------
                  //password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
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
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  // confrim passowerd text field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: !_confirmPasswordVisible,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          label: Text('Confirm Password'),
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                print('Password visibility toggled');
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible; // toggle the password visibility
                              });
                            },
                          ),
                          hintText: 'Confirm Password',
                          fillColor: Colors.white,
                          filled: true),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),

                  //--------------------------
                  //sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 107, 84, 146),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
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
                        'I am a member!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          ' Login Now',
                          style: TextStyle(
                              color: Color.fromARGB(255, 107, 84, 146),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  //--------------------------
                  //about page
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
                        //by clicking 'restora' user will be redirected to about page
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
      ),
    );
  }
}

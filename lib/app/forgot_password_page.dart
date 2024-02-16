//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //try catch to do password reset using Firebase Auth.
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Show a dialog box with a message that the password reset link has been sent.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link has been sent to your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      // Show a dialog box with an error message if sending reset email failed.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //text widget to display instruction to enter email for password reset.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your email and we will send you passwrod reset link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(height: 10),

          //--------------------------------------
          // Textfield to input email for password reset.
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
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true),
            ),
          ),
          SizedBox(height: 10),

          //--------------------------------
          // Material button to initiate password reset.
          MaterialButton(
            onPressed: passwordReset,
            child: Text('Reset Password'),
            color: Colors.deepPurple[200],
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        ],
      ),
    );
  }
}

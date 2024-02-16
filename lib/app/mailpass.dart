//Programmer Name: Naimur Rahman Shahed, student of Computer Science (CS), APU, Malaysia
//TP060805

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeEmailPasswordPage extends StatefulWidget {
  @override
  _ChangeEmailPasswordPageState createState() =>
      _ChangeEmailPasswordPageState();
}

class _ChangeEmailPasswordPageState extends State<ChangeEmailPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentPasswordController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isProcessing = false;
  bool _emailChanged = false;
  bool _passwordChanged = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newEmailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _changeEmailPassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
        _emailChanged = _newEmailController.text.isNotEmpty;
        _passwordChanged = _newPasswordController.text.isNotEmpty;
      });

      try {
        // Reauthenticate the user with their current password
        final credential = EmailAuthProvider.credential(
          email: currentUser!.email!,
          password: _currentPasswordController.text,
        );
        await currentUser.reauthenticateWithCredential(credential);

        // Update the email and/or password
        if (_emailChanged) {
          await currentUser.updateEmail(_newEmailController.text);
        }
        if (_passwordChanged) {
          await currentUser.updatePassword(_newPasswordController.text);
        }

        String message = '';
        if (_emailChanged && _passwordChanged) {
          message = 'Email and password updated successfully.';
        } else if (_emailChanged) {
          message = 'Email updated successfully.';
        } else if (_passwordChanged) {
          message = 'Password updated successfully.';
        }
        _showSnackBar(message);
        Navigator.pop(context, true);
      } on FirebaseAuthException catch (e) {
        _showSnackBar('Error: ${e.message}');
      } finally {
        setState(() {
          _isProcessing = false;
          _emailChanged = false;
          _passwordChanged = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Change Email and Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Password',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'New Email',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(hintText: 'Enter your new email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'New Password',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration:
                    InputDecoration(hintText: 'Enter your new password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _changeEmailPassword,
                  child: _isProcessing
                      ? CircularProgressIndicator()
                      : Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

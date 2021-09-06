import 'package:flash_chat/components/rrbox.dart';
import 'package:flash_chat/constants.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'friend_list.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var email;
  var password;
  bool indicatorRunning = false;
  final _auth = FirebaseAuth.instance;
  final snackBar =
      SnackBar(content: Text('Email is already in use or badly formatted'));
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: indicatorRunning,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter Your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Create a new password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RRBox(
                col: Colors.blueAccent,
                onPress: () async {
                  setState(() {
                    indicatorRunning = true;
                  });
                  try {
                    var newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      setState(() {
                        indicatorRunning = false;
                      });
                      Navigator.pushNamed((context), Flist.id);
                    }
                  } catch (e) {
                    setState(() {
                      indicatorRunning = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print(e);
                  }
                },
                text: "Register",
              )
            ],
          ),
        ),
      ),
    );
  }
}

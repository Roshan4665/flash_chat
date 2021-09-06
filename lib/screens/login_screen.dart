import 'package:flash_chat/components/rrbox.dart';
import 'package:flash_chat/constants.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'friend_list.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var email;
  var password;
  bool loggingInState = false;
  final _googleSignIn = GoogleSignIn();
  final snackBar = SnackBar(content: Text('Email not registered or incorrect'));
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loggingInState,
      child: Scaffold(
        //backgroundColor: Colors.white,
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
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter Your Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RRBox(
                col: Colors.lightBlueAccent,
                onPress: () async {
                  setState(() {
                    loggingInState = true; //modal hud pi comes up
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      setState(() {
                        loggingInState = false;
                      });
                      // email = null;
                      // password = null;
                      Navigator.pushNamed((context), Flist.id);
                    }
                  } catch (e) {
                    setState(() {
                      loggingInState = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //print(e);
                  }
                },
                text: "Log In",
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    await _googleSignIn.signIn();
                    Navigator.pushNamed((context), Flist.id);
                  } catch (error) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar); //error message
                    //print("here comes the error");
                    //print(error);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 35,
                          child: Image.asset('assets/images/google_logo.png')),
                      Container(
                          child: Text(
                        "Or continue with Google",
                        style: GoogleFonts.loveYaLikeASister(fontSize: 18),
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

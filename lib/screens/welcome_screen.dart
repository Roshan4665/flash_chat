import 'package:flash_chat/screens/helpScreen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flash_chat/components/rrbox.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    startApp();
    super.initState();
  }

  void startApp() async {
    final user = await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 80),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('assets/images/logo.png'),
                        height: 60.0,
                      ),
                    ),
                    AnimatedTextKit(
                      totalRepeatCount: 5,
                      pause: Duration(seconds: 2),
                      animatedTexts: [
                        TypewriterAnimatedText("Flash Chat",
                            speed: Duration(milliseconds: 100),
                            textStyle: GoogleFonts.loveYaLikeASister(
                                color: Colors.pinkAccent,
                                fontSize: 45,
                                fontWeight: FontWeight.w900))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                RRBox(
                    text: "Log In",
                    col: Colors.lightBlue,
                    onPress: () {
                      Navigator.pushNamed((context), LoginScreen.id);
                    }),
                RRBox(
                  col: Colors.blueAccent,
                  onPress: () {
                    Navigator.pushNamed((context), RegistrationScreen.id);
                  },
                  text: "Register",
                ),
                RRBox(
                  col: Colors.pinkAccent,
                  onPress: () {
                    Navigator.pushNamed(context, HelpScreen.id);
                  },
                  text: "Help",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  static const id = "help_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Help'),
        ),
        body: Container(
          child: Text(
            'You can have only one google registered Sign In per device. To have more than one accounts please use register button. Once you login with google, your google credentials are saved by google to ease your Sign In next time. If you don\'t want this or there\'s an error with Google Sign In, then you can login/register manually with email and password. For help you can, mail me @ dreamer4346@gmail.com.',
            style: GoogleFonts.loveYaLikeASister(
                fontSize: 18, color: Colors.white),
          ),
        ));
  }
}

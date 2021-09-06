import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RRBox extends StatelessWidget {
  RRBox({required this.col, required this.onPress, this.text});
  final col;
  final Function()? onPress;
  final text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: col,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text ?? '',
            style: GoogleFonts.loveYaLikeASister(),
          ),
        ),
      ),
    );
  }
}

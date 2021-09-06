import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flash_chat/components/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
var email = "random@";
var currentCollectionId = impcId;
var cspeed = 100;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  void getCurrentUser() {
    currentCollectionId = impcId;
    try {
      var user = _auth.currentUser;
      email = user!.email!;
    } catch (e) {
      try {
        var user = _googleSignIn.currentUser;
        email = user!.email;
      } catch (e) {}
    }
  }

  List<int> speed = [1, 100, 200, 300, 400, 600, 800, 1000, 5000, 20000];

  int i = 0;
  @override
  void initState() {
    // TODO: implement initState
    i = 0;
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  i++;
                  i %= 10;
                  final snackBar = SnackBar(
                      content: Text('Text animation speed change to ' +
                          speed[i].toString()));

                  setState(() {
                    cspeed = speed[i];
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Icon(
                  Icons.speed,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
        title: Text('⚡️' + userName(freind)),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageScreen(currentCollectionId),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        //Do something with the user input.

                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Implement send functionality.add({})
                      String date = getCurrentDateTime();
                      try {
                        await _firestore.collection(currentCollectionId).add({
                          "text": messageText,
                          "sender": email,
                          'Timestamp': FieldValue.serverTimestamp()
                        });
                        await _firestore.collection("Self" + freind).add({
                          "text": "A new message from " +
                              userName(email) +
                              " at $date",
                          "sender": email,
                          'Timestamp': FieldValue.serverTimestamp()
                        });
                        await _firestore.collection("Self" + email).add({
                          "text": "A new message sent to " +
                              userName(freind) +
                              " at " +
                              date,
                          "sender": email,
                          'Timestamp': FieldValue.serverTimestamp()
                        });
                        controller.clear();
                        messageText = " ";
                        //print(ref);
                      } catch (e) {
                        //print(e);
                        final snackBar = SnackBar(
                          content: Text(
                              'There was a network error. Please try in a moment.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageScreen extends StatefulWidget {
  const MessageScreen(this.collectionId);
  final collectionId;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection(widget.collectionId)
            .orderBy('Timestamp')
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            var messages = snapshots.data!.docs;
            List<TextBox> textMessages = [];
            for (var message in messages) {
              var text = message['text'].toString();
              if (message['sender'] == email) {
                textMessages.add(TextBox(
                  text: text,
                  isMe: true,
                  mail: message['sender'],
                  time: message['Timestamp'],
                ));
              } else {
                textMessages.add(TextBox(
                  text: text,
                  isMe: false,
                  mail: message['sender'],
                  time: message['Timestamp'],
                ));
              }
            }
            return Expanded(
              child: ListView(
                //reverse: true,
                children: textMessages,
              ),
            );
          }
          return Flexible(child: CircularProgressIndicator());
        });
  }
}

class TextBox extends StatelessWidget {
  TextBox(
      {required this.text,
      required this.isMe,
      required this.mail,
      required this.time});
  final text;
  final isMe;
  final mail;
  final time;
  final List<Color> clist = [
    Colors.blue,
    Colors.pinkAccent,
    Colors.pink,
    Colors.greenAccent,
    Colors.green,
    Colors.purpleAccent,
    Colors.cyan
  ];

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
            margin: isMe
                ? EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10)
                : EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: isMe
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                color: clist[random.nextInt(7)]),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  isMe ? userName(email) : userName(freind),
                ),
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  pause: Duration(seconds: 2),
                  animatedTexts: [
                    TypewriterAnimatedText(text,
                        speed: Duration(milliseconds: cspeed),
                        textStyle: GoogleFonts.loveYaLikeASister(fontSize: 18))
                  ],
                )
              ],
            ))
      ],
    );
  }
}

String userName(String email) {
  if (email == null) email = "random@";
  String temp = "";
  int sz = email.length;
  int i = 0;
  for (i = 0; i < sz; i++) {
    if (email[i] == '@') break;
    temp = temp + email[i];
  }
  return temp;
}

String getCurrentDateTime() {
  String date = DateFormat('kk:mm:ss on EEE d MMM').format(DateTime.now());
  return date;
}

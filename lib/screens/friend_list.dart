import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat/components/helper.dart';

String impCollectionId =
    'messages'; //TODO for guest and group feature, not implemented yet

class Flist extends StatefulWidget {
  static const id = "friend_list";

  @override
  _FlistState createState() => _FlistState();
}

Set<String> s = {'Self'};

class _FlistState extends State<Flist> {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();
  final _firestore = FirebaseFirestore.instance;
  var emailh = "errormail@mail.com";
  bool gotUserList = false;
  bool isError = false;
  List<String> users = [];
  @override
  void initState() {
    try {
      var user = _auth.currentUser;
      emailh = user!.email!;
      _firestore.collection('USERS').add({'email': emailh});
    } catch (e) {
      try {
        var user = _google.currentUser;
        emailh = user!.email;
        _firestore.collection('USERS').add({'email': emailh});
      } catch (e) {
        isError = true;
      }
    }
//_firestore.collection('USERS').add({'email': newUser});
    getUser();
    super.initState();
  }

  void getUser() async {
    var userList = await _firestore.collection('USERS').get();
    var temp = userList.docs;

    // print(email);
    int sz = temp.length;
    for (int i = 0; i < sz; i++) {
      s.add(temp[i]['email']);
    }
    //for (var m in s) print(m);

    setState(() {
      gotUserList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: gotUserList,
      child: isError == true
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'))),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text("Welcome and Introduction"),
                ),
                body: SingleChildScrollView(
                  child: AnimatedTextKit(
                    totalRepeatCount: 5,
                    pause: Duration(seconds: 2),
                    animatedTexts: [
                      TypewriterAnimatedText(
                          "This page has been created to handle an error that might have been caused because of error on google log in part. Either you need to register or log in manually by entering your email. Thanks",
                          speed: Duration(milliseconds: 100),
                          textStyle: GoogleFonts.loveYaLikeASister(
                              color: Colors.pinkAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.w900))
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.black,
              // appBar: AppBar(
              //   actions: [
              //     GestureDetector(
              //         onTap: () {
              //           _auth.signOut();
              //           Navigator.pop(context);
              //         },
              //         child: Container(
              //           margin: EdgeInsets.only(right: 10),
              //           child: Icon(Icons.logout),
              //         ))
              //   ],
              //   title: Text(userName(emailh)),
              // ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  getUser();
                  setState(() {
                    gotUserList = true;
                  });
                },
                child: Icon(Icons.refresh_outlined),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Container(
                              //margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/goku1.jpg'))),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  userName(email),
                                  style: GoogleFonts.aladin(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Check for interactions in Self",
                                  style: GoogleFonts.aladin(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            _auth.signOut();
                            Navigator.pop((context));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text(
                                "Sign Out",
                                style: GoogleFonts.loveYaLikeASister(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(34),
                              topLeft: Radius.circular(34))),
                      child: ListView(
                        children: getw(_auth.currentUser!.email),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

List<Widget> getw(String? myMail) {
  List<ClickableNamedBox> listf = [];

  for (var f in s) {
    listf.add(ClickableNamedBox(
      friendMail: f,
      myMail: myMail,
    ));
  }

  return listf;
}

int colno = 0;

class ClickableNamedBox extends StatelessWidget {
  ClickableNamedBox({@required this.friendMail, @required this.myMail});
  final friendMail;
  final myMail;
  List<Color> clist = [
    //Colors.blue,
    Colors.pinkAccent,
    //Colors.pink,
    Colors.greenAccent,
    Colors.green,
    Colors.purpleAccent,
    Colors.cyan,
    //Colors.yellow,
    //Colors.blueGrey,
    //Colors.deepPurpleAccent
  ];

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        impCollectionId = cIdmaker(myMail, friendMail);
        help(impCollectionId,
            friendMail); //fun to pass the collection to be opened with help of helper.dart
        Navigator.pushNamed(
          context,
          ChatScreen.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: clist[colno++ % 5],
            borderRadius: BorderRadius.circular(100)),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Flexible(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://picsum.photos/100/120/?blur=1&random' +
                              random.nextInt(100).toString()),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Text(
              userName(friendMail == null ? "nothing" : friendMail),
              style: GoogleFonts.loveYaLikeASister(
                  fontSize: 24, fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
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

String cIdmaker(String? a, String b) {
  if (a == null) a = 'random';

  int val = a.compareTo(b);
  if (val < 0) return a + b;
  return b + a;
}

import 'dart:math';

import 'package:dataly_app/authentication/firebase_auth.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class LoginForm extends StatefulWidget {
  final String page;

  const LoginForm({Key? key, required this.page}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isHidden = true;
  bool? googleloading = false;
  bool _isLoading = false;
  static final _loginkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _togglepasswordview() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Form(
      key: _loginkey,
      child: Container(
        margin: EdgeInsets.all(min(horizontalScale, verticalScale) * 24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                min(horizontalScale, verticalScale) * 25)),
        child: ListView(
          padding: EdgeInsets.fromLTRB(horizontalScale * 25, verticalScale * 36,
              horizontalScale * 24, verticalScale * 36),
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  labelText: 'Email',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18 * min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(
                    fontSize: 18 * min(horizontalScale, verticalScale),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('7B62DF'), width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                  ),
                  suffixIcon: Icon(
                    Icons.email,
                    color: HexColor('6153D3'),
                  )),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter email address';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                        r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale * 16,
            ),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  floatingLabelStyle: TextStyle(
                      fontSize: 18 * min(horizontalScale, verticalScale),
                      fontWeight: FontWeight.w500,
                      color: HexColor('7B62DF')),
                  labelStyle: TextStyle(
                      fontSize: 18 * min(horizontalScale, verticalScale)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('7B62DF'), width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                  ),
                  suffix: InkWell(
                    onTap: _togglepasswordview,
                    child: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility,
                      color: HexColor('6153D3'),
                    ),
                  ),
                  errorMaxLines: 2),
              obscureText: _isHidden,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter the Password';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    .hasMatch(value)) {
                  return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
                }
                return null;
              },
            ),
            SizedBox(
              height: verticalScale * 9,
            ),
            InkWell(
              onTap: () {
                if (email.text.isNotEmpty) {
                  auth.sendPasswordResetEmail(email: email.text);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Future.delayed(Duration(seconds: 13), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                Lottie.asset('assets/email.json',
                                    height: height * 0.15, width: width * 0.5),
                                Text(
                                  'Password Reset',
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'An email has been sent to ',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              Text(
                                '${email.text}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Click the link in the email to change password.',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: verticalScale * 10,
                              ),
                              Text(
                                'Didn\'t get the email?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Check entered email or check spam folder.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              TextButton(
                                  child: Text(
                                    'Retry',
                                    textScaleFactor:
                                        min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  }),
                            ],
                          ),
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Center(
                              child: Text(
                                'Error',
                                textScaleFactor:
                                    min(horizontalScale, verticalScale),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Text(
                              'Enter email in the email field or check if the email is valid.',
                              textAlign: TextAlign.center,
                              textScaleFactor:
                                  min(horizontalScale, verticalScale),
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  })
                            ]);
                      });
                }
              },
              child: Text(
                'Forgot Password?',
                textScaleFactor: min(horizontalScale, verticalScale),
                textAlign: TextAlign.end,
                style: TextStyle(color: HexColor('0047FF'), fontSize: 16),
              ),
            ),
            SizedBox(
              height: verticalScale * 12,
            ),
            Center(
              child: (_isLoading)
                  ? Loading()
                  : ElevatedButton(
                      child: Text(
                        'Login',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('6153D3'),
                      ),
                      onPressed: () {
                        if (_loginkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          logIn(email.text, pass.text).then((user) async {
                            if (user != null) {
                              print(user);
                              Toast.show('Logged in Successfully');
                              print("seewewew");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: HomePage()),
                                  (route) => false);
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(
                                            child: Text(
                                              'Error',
                                              textScaleFactor: min(
                                                  horizontalScale,
                                                  verticalScale),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          content: Text(
                                            '       There is no user record \n corresponding to the identifier.',
                                            textScaleFactor: min(
                                                horizontalScale, verticalScale),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                                child: Text('Retry'),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                })
                                          ]);
                                    });
                              }
                              Toast.show('Login failed');
                            }
                          });
                        }
                      },
                    ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                height: 50,
                width: 220,
                child: InkWell(
                  onTap: () {
                    try {
                      setState(() {
                        googleloading = true;
                      });
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin(
                        context,
                        // listOfAllExistingUser,
                      );
                      print(provider);
                      setState(() {
                        googleloading = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    height: horizontalScale * 49,
                    width: verticalScale * 173,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          min(horizontalScale, verticalScale) * 8),
                      boxShadow: [
                        // color: Colors.white, //background color of box
                        BoxShadow(
                          color: HexColor('977EFF'),
                          blurRadius: 10.0, // soften the shadow
                          offset: Offset(
                            0, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Center(
                      child: googleloading!
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.network(
                                  'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fgoogle.svg?alt=media&token=e8c0aa3a-a131-49a4-be09-8ebfe2990ea7',
                                  height:
                                      min(horizontalScale, verticalScale) * 26,
                                  width:
                                      min(horizontalScale, verticalScale) * 26,
                                ),
                                Text(
                                  'Continue with Google',
                                  textScaleFactor:
                                      min(horizontalScale, verticalScale),
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

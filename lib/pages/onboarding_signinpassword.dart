import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/screens/stores/login_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:dataly_app/screens/stores/login_store.dart';
import 'package:dataly_app/theme.dart';
import 'package:dataly_app/widgets/loader_hud.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:toast/toast.dart';
import '../authentication/firebase_auth.dart';
import '../globals.dart';
import '../screens/onboarding_phone.dart';

class SigninPasswordPage extends StatefulWidget {
  String email;
  SigninPasswordPage({Key? key, required this.email}) : super(key: key);
  @override
  _SigninPasswordPageState createState() => _SigninPasswordPageState();
}

class _SigninPasswordPageState extends State<SigninPasswordPage> {
  TextEditingController passwordController = TextEditingController();
  bool loading = false;
  late bool _passwordVisible;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        loginStore.isLoginLoading = false;

        return Scaffold(
          backgroundColor: Colors.white,
          key: loginStore.loginScaffoldKey,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.90,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Stack(
                              children: <Widget>[
                                // Center(
                                //   child: Container(
                                //     height: 140,
                                //     constraints:
                                //         const BoxConstraints(maxWidth: 500),
                                //     margin: const EdgeInsets.only(top: 100),
                                //     decoration: const BoxDecoration(
                                //         color: Color(0xFFE1E0F5),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(30))),
                                //   ),
                                // ),
                                Center(
                                  child: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 240),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Lottie.asset(
                                          'assets/onboarding_password.json')),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          //  Container(
                          //       constraints:
                          //           const BoxConstraints(maxWidth: 500),
                          //       margin: const EdgeInsets.symmetric(
                          //           horizontal: 10),
                          //       child: RichText(
                          //         textAlign: TextAlign.center,
                          //         text: TextSpan(children: <TextSpan>[
                          //           TextSpan(
                          //               text: 'Choosing a hard-to-guess,',
                          //               style: TextStyle(
                          //                   color: MyColors.primaryColor)),
                          //           TextSpan(
                          //               text: ' but easy-to-remember\n',
                          //               style: TextStyle(
                          //                   color: MyColors.primaryColor,
                          //                   fontWeight: FontWeight.bold)),
                          //           TextSpan(
                          //               text: ' password is important!',
                          //               style: TextStyle(
                          //                   color: MyColors.primaryColor)),
                          //         ]),
                          //       )),
                          SizedBox(
                            height: 40,
                          ),

                          // Container(
                          //   height: 60,
                          //   constraints:
                          //       const BoxConstraints(maxWidth: 500),
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   child: CupertinoTextField(
                          //     maxLength: 10,
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 16),
                          //     decoration: BoxDecoration(
                          //         color: Color.fromARGB(255, 242, 240, 240),
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(4))),
                          //     controller: nameController,
                          //     clearButtonMode:
                          //         OverlayVisibilityMode.editing,
                          //     keyboardType: TextInputType.name,
                          //     maxLines: 1,
                          //     placeholder: 'Confirm Password',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: passwordController,
                              obscureText:
                                  !_passwordVisible, //This will obscure text dynamically
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(120, 96, 220, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(120, 96, 220, 1),
                                  ), //<-- SEE HERE
                                ),
                                iconColor: Color.fromRGBO(120, 96, 220, 1),
                                hoverColor: Color.fromRGBO(120, 96, 220, 1),
                                focusColor: Color.fromRGBO(120, 96, 220, 1),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(120, 96, 220, 1)),
                                // Here is key idea
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color.fromRGBO(120, 96, 220, 1),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                         SizedBox(
                            height: 10,
                          ),
                           Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 8, 18, 8),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.email.isNotEmpty) {
                                        _auth.sendPasswordResetEmail(
                                            email: widget.email);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              Future.delayed(
                                                  Duration(seconds: 13), () {
                                                Navigator.of(context).pop(true);
                                              });
                                              return AlertDialog(
                                                title: Center(
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset(
                                                          'assets/email.json',
                                                          height: height * 0.15,
                                                          width: width * 0.5),
                                                      Text(
                                                        'Reset Password',
                                                        textScaleFactor: min(
                                                            horizontalScale,
                                                            verticalScale),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'An email has been sent to ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    Text(
                                                      '${widget.email}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Click the link in the email to change password.',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          verticalScale * 10,
                                                    ),
                                                    Text(
                                                      'Didn\'t get the email?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Check entered email or check spam folder.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(),
                                                    ),
                                                    TextButton(
                                                        child: Text(
                                                          'Retry',
                                                          textScaleFactor: min(
                                                              horizontalScale,
                                                              verticalScale),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
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
                                                      textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Enter email in the email field or check if the email is valid.',
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: min(
                                                        horizontalScale,
                                                        verticalScale),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        child: Text('Retry'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        })
                                                  ]);
                                            });
                                      }
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'Forgot Password?',
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: HexColor('8346E1'),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),

                          GestureDetector(
                            onTap: () async {
                              if (passwordController.text.isNotEmpty) {
                                setState(() {
                                  loading = true;
                                });
                                User? user;
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                try {
                                  user =
                                      (await _auth.signInWithEmailAndPassword(
                                              email: widget.email,
                                              password: passwordController.text
                                                  .toString()))
                                          .user;
                                  _auth.currentUser!
                                      .linkWithCredential(globals.credental);
                                  var value = await FirebaseAuth
                                      .instance.currentUser!.uid;
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('login', "true");

                                  await FirebaseFirestore.instance
                                      .collection('Users_dataly')
                                      .doc(_auth.currentUser!.uid)
                                      .update({
                                    "linked": "true",
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                } on FirebaseException catch (e) {
                                  print(e.code);
                                  setState(() {
                                    loading = false;
                                  });
                                  Toast.show(e.toString());
                                  if (e.code.toString() == "wrong-password") {
                                    setState(() {
                                      loading = false;
                                    });
                                    Toast.show("wrong password");
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                }

                                // Toast.show("here");
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                } else {
                                  Toast.show("wrong password");
                                }
                              } else {
                                Toast.show("enter your password");
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              constraints: const BoxConstraints(maxWidth: 500),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        // Color(0xFF8A2387),
                                        Color.fromRGBO(120, 96, 220, 1),
                                        Color.fromRGBO(120, 96, 220, 1),
                                        Color.fromARGB(255, 88, 52, 246),
                                      ])),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: loading
                                  ? Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white))),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 0, 0),
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: MyColors.primaryColorLight,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

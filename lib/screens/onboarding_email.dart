import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/homepage.dart';
import 'package:dataly_app/pages/onboarding_signinpassword.dart';
import 'package:dataly_app/screens/stores/onboarding_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:dataly_app/theme.dart';
import 'package:dataly_app/widgets/loader_hud.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:toast/toast.dart';
import '../../authentication/firebase_auth.dart';
import '../Providers/UserProvider.dart';
import '../catalogue_screen.dart';
import '../pages/otp_page.dart';
import '../pages/survay_page.dart';
import 'onboarding_signuppassword.dart';

class LoginEmailPage extends StatefulWidget {
  String user;
  LoginEmailPage({Key? key, required this.user}) : super(key: key);
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _passwordVisible = false;
  bool loading = false;
  bool signin = false;
  @override
  void initState() {
    super.initState();
    print("rrrrrrrrrrrrrrrrr");
    print(globals.action);
    // widget.user == "signup" ? loginnewuser() : null;
    print(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.primaryColorLight.withAlpha(20),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                              Center(
                                  // child: Container(
                                  //   height: 240,
                                  //   constraints:
                                  //       const BoxConstraints(maxWidth: 500),
                                  //   margin: const EdgeInsets.only(top: 100),
                                  //   decoration: const BoxDecoration(
                                  //       color: Color(0xFFE1E0F5),
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(30))),
                                  // ),
                                  ),
                              Center(
                                child: widget.user == "signup"
                                    ? Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 340),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Lottie.asset(
                                            'assets/logingif.json'))
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 56, 0, 0),
                                        child: Container(
                                            constraints: const BoxConstraints(
                                                maxHeight: 140),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Lottie.asset(
                                                'assets/onboarding_password.json')),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('CloudyML',
                                style: TextStyle(
                                    color: MyColors.primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800)))
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      widget.user == "signup"
                          ? Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'We look forward to getting to know you better at ',
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                  TextSpan(
                                      text: 'CloudyML.',
                                      style: TextStyle(
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: " Let's begin with name and email",
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                ]),
                              ))
                          : Container(),

                      widget.user == "signup"
                          ? Column(
                              children: <Widget>[
                                // Container(
                                //     constraints:
                                //         const BoxConstraints(maxWidth: 500),
                                //     margin: const EdgeInsets.symmetric(
                                //         horizontal: 10),
                                //     child: RichText(
                                //       textAlign: TextAlign.center,
                                //       text: TextSpan(children: <TextSpan>[
                                //         TextSpan(
                                //             text: 'What should we call you?',
                                //             style: TextStyle(
                                //                 color:
                                //                     MyColors.primaryColor)),
                                //         TextSpan(
                                //             text: '',
                                //             style: TextStyle(
                                //                 color: MyColors.primaryColor,
                                //                 fontWeight: FontWeight.bold)),
                                //         TextSpan(
                                //             text: '',
                                //             style: TextStyle(
                                //                 color:
                                //                     MyColors.primaryColor)),
                                //       ]),
                                //     )),
                                Container(
                                  height: 60,
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: CupertinoTextField(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    controller: nameController,
                                    clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                    keyboardType: TextInputType.name,
                                    maxLines: 1,
                                    placeholder: 'Name',
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // GestureDetector(
                                //   onTap: () async {
                                //     FirebaseAuth _auth = FirebaseAuth.instance;

                                //     if (signin == false) {
                                //       var logi = await _auth
                                //           .signInWithCredential(globals.credental);
                                //       userprofile(
                                //           name: nameController.text.toString(),
                                //           image: '',
                                //           mobilenumber: globals.phone,
                                //           authType: 'phoneAuth',
                                //           phoneVerified: true,
                                //           email: globals.email);
                                //       print(logi.user?.email);
                                //       Toast.show(logi.user!.email);
                                //     } else {
                                //       userprofile(
                                //           name: nameController.text.toString(),
                                //           image: '',
                                //           mobilenumber: globals.phone,
                                //           authType: 'phoneAuth',
                                //           phoneVerified: true,
                                //           email: globals.email);
                                //     }

                                //     if (nameController.text.isNotEmpty) {
                                //       try {
                                //         setState(() {
                                //           loading = true;
                                //         });
                                //         globals.name =
                                //             nameController.text.toString();
                                //         var user = _auth.currentUser;
                                //         if (user != null) {
                                //           await FirebaseFirestore.instance
                                //               .collection('Users')
                                //               .doc(FirebaseAuth
                                //                   .instance.currentUser!.uid)
                                //               .update({
                                //             "linked": "true",
                                //           });
                                //           var userDocs;
                                //           try {
                                //             userDocs = await FirebaseFirestore
                                //                 .instance
                                //                 .collection('Users')
                                //                 .doc(FirebaseAuth
                                //                     .instance.currentUser!.uid)
                                //                 .get();
                                //           } catch (e) {
                                //             if (userDocs.data() == null) {
                                //               await FirebaseFirestore.instance
                                //                   .collection('Users')
                                //                   .doc(FirebaseAuth
                                //                       .instance.currentUser!.uid)
                                //                   .update({
                                //                 "linked": "true",
                                //               });
                                //               // Toast.show('user data does not exist');

                                //               setState(() {
                                //                 loading = false;
                                //               });
                                //             }
                                //           }

                                //           setState(() {
                                //             loading = false;
                                //           });
                                //         } else {
                                //           Toast.show('user does not exist');
                                //           setState(() {
                                //             loading = false;
                                //           });
                                //         }

                                //         var value = await FirebaseAuth
                                //             .instance.currentUser!.uid;
                                //         final prefs =
                                //             await SharedPreferences.getInstance();
                                //         await prefs.setString('login', "true");
                                //         Navigator.pushReplacement(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) => HomePage(),
                                //           ),
                                //         );
                                //         setState(() {
                                //           loading = false;
                                //         });
                                //       } catch (e) {
                                //         Toast.show(e.toString());
                                //         // Navigator.pushReplacement(
                                //         //   context,
                                //         //   MaterialPageRoute(
                                //         //     builder: (context) => HomePage(),
                                //         //   ),
                                //         // );
                                //       }
                                //     } else {
                                //       setState(() {
                                //         loading = false;
                                //       });
                                //       Toast.show('Please enter your name');
                                //     }
                                //     //        var user = FirebaseAuth.instance.currentUser;
                                //     //       if (nameController.text.isNotEmpty) {
                                //     //         if (user != null) {
                                //     // DocumentSnapshot userDocs = await FirebaseFirestore
                                //     //     .instance
                                //     //     .collection('Users')
                                //     //     .doc(FirebaseAuth.instance.currentUser!.uid)
                                //     //     .get();
                                //     // if (userDocs.data() == null) {
                                //     //   userprofile(
                                //     //       name: '',
                                //     //       image: '',
                                //     //       mobilenumber: mobile.text,
                                //     //       authType: 'phoneAuth',
                                //     //       phoneVerified: true,
                                //     //       email: '');
                                //     //   Toast.show('Account Created');
                                //     // }
                                //     //       } else {
                                //     //         SnackBar(
                                //     //           behavior: SnackBarBehavior.floating,
                                //     //           backgroundColor: Colors.red,
                                //     //           content: Text(
                                //     //             'Please enter your name',
                                //     //             style: TextStyle(color: Colors.white),
                                //     //           ),
                                //     //         );
                                //     //       }
                                //   },
                                //   child: Container(
                                //     margin: const EdgeInsets.symmetric(
                                //         horizontal: 20, vertical: 10),
                                //     constraints:
                                //         const BoxConstraints(maxWidth: 500),
                                //     alignment: Alignment.center,
                                //     decoration: const BoxDecoration(
                                //         borderRadius:
                                //             BorderRadius.all(Radius.circular(14)),
                                //         gradient: LinearGradient(
                                //             begin: Alignment.centerLeft,
                                //             end: Alignment.centerRight,
                                //             colors: [
                                //               // Color(0xFF8A2387),
                                //               Color.fromRGBO(120, 96, 220, 1),
                                //               Color.fromRGBO(120, 96, 220, 1),
                                //               Color.fromARGB(255, 88, 52, 246),
                                //             ])),
                                //     padding: const EdgeInsets.symmetric(
                                //         vertical: 8, horizontal: 8),
                                //     child: loading
                                //         ? Padding(
                                //             padding: const EdgeInsets.all(6.0),
                                //             child: Container(
                                //                 height: 20,
                                //                 width: 20,
                                //                 child: Center(
                                //                     child:
                                //                         CircularProgressIndicator(
                                //                             color: Colors.white))),
                                //           )
                                //         : Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: <Widget>[
                                //               Padding(
                                //                 padding: const EdgeInsets.fromLTRB(
                                //                     12, 0, 0, 0),
                                //                 child: Text(
                                //                   'Next',
                                //                   style: TextStyle(
                                //                       color: Color.fromARGB(
                                //                           255, 255, 255, 255),
                                //                       fontWeight: FontWeight.bold),
                                //                 ),
                                //               ),
                                //               Container(
                                //                 padding: const EdgeInsets.all(8),
                                //                 decoration: BoxDecoration(
                                //                   borderRadius:
                                //                       const BorderRadius.all(
                                //                           Radius.circular(20)),
                                //                   color: MyColors.primaryColorLight,
                                //                 ),
                                //                 child: Icon(
                                //                   Icons.arrow_forward_ios,
                                //                   color: Colors.white,
                                //                   size: 16,
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Container(
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 20, vertical: 10),
                                //   constraints:
                                //       const BoxConstraints(maxWidth: 500),
                                //   child: RaisedButton(
                                //     onPressed: () {
                                //       if (phoneController.text.isNotEmpty) {
                                //         loginStore.getCodeWithPhoneNumber(context,
                                //             "+91${phoneController.text.toString()}");
                                //       } else {
                                //         loginStore.loginScaffoldKey.currentState
                                //             ?.showSnackBar(SnackBar(
                                //           behavior: SnackBarBehavior.floating,
                                //           backgroundColor: Colors.red,
                                //           content: Text(
                                //             'Please enter a phone number',
                                //             style: TextStyle(color: Colors.white),
                                //           ),
                                //         ));
                                //       }
                                //     },
                                //     color: MyColors.primaryColor,
                                //     shape: const RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(14))),
                                //     child: Container(
                                //       padding: const EdgeInsets.symmetric(
                                //           vertical: 8, horizontal: 8),
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: <Widget>[
                                //           Text(
                                //             'Next',
                                //             style: TextStyle(color: Colors.white),
                                //           ),
                                //           Container(
                                //             padding: const EdgeInsets.all(8),
                                //             decoration: BoxDecoration(
                                //               borderRadius:
                                //                   const BorderRadius.all(
                                //                       Radius.circular(20)),
                                //               color: MyColors.primaryColorLight,
                                //             ),
                                //             child: Icon(
                                //               Icons.arrow_forward_ios,
                                //               color: Colors.white,
                                //               size: 16,
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            )
                          : Container(),

                      Container(
                        height: 40,
                        constraints: const BoxConstraints(maxWidth: 500),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: CupertinoTextField(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          controller: emailController,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          placeholder: 'Email',
                        ),
                      ),

                      widget.user == "signin"
                          ? Expanded(
                              flex: 0,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: CupertinoTextField(
                                      suffix: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromRGBO(120, 96, 220, 1),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      obscureText: !_passwordVisible,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      clearButtonMode:
                                          OverlayVisibilityMode.editing,
                                      keyboardType: TextInputType.text,
                                      controller: passwordController,
                                      maxLines: 1,
                                      placeholder: 'Password',
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width * 0.9,
                                  //   child: TextFormField(

                                  //     keyboardType: TextInputType.text,
                                  //     controller: passwordController,
                                  //     obscureText:
                                  //         !_passwordVisible, //This will obscure text dynamically
                                  //     decoration: InputDecoration(

                                  //       suffixIcon: IconButton(
                                  //         icon: Icon(
                                  //           // Based on passwordVisible state choose the icon
                                  //           _passwordVisible
                                  //               ? Icons.visibility
                                  //               : Icons.visibility_off,
                                  //           color: Color.fromRGBO(120, 96, 220, 1),
                                  //         ),
                                  //         onPressed: () {
                                  //           // Update the state i.e. toogle the state of passwordVisible variable
                                  //           setState(() {
                                  //             _passwordVisible = !_passwordVisible;
                                  //           });
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  SizedBox(
                                    height: 4,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 2, 18, 8),
                                    child: InkWell(
                                      onTap: () {
                                        if (emailController.text.isNotEmpty) {
                                          _auth.sendPasswordResetEmail(
                                              email: emailController.text
                                                  .toLowerCase()
                                                  .toString());
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                Future.delayed(
                                                    Duration(seconds: 13), () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                });
                                                return AlertDialog(
                                                  title: Center(
                                                    child: Column(
                                                      children: [
                                                        Lottie.asset(
                                                            'assets/email.json',
                                                            height:
                                                                height * 0.15,
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
                                                        '${emailController.text.toLowerCase().toString()}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                FontWeight
                                                                    .bold),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    content: Text(
                                                      'Enter email in the email field or check if the email is valid.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      textScaleFactor: min(
                                                          horizontalScale,
                                                          verticalScale),
                                                      style: TextStyle(
                                                          fontSize: 16),
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
                                          textScaleFactor: min(
                                              horizontalScale, verticalScale),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: HexColor('8346E1'),
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Container(
                                  //   margin: const EdgeInsets.symmetric(
                                  //       horizontal: 20, vertical: 10),
                                  //   constraints:
                                  //       const BoxConstraints(maxWidth: 500),
                                  //   child: RaisedButton(
                                  //     onPressed: () {
                                  //       if (phoneController.text.isNotEmpty) {
                                  //         loginStore.getCodeWithPhoneNumber(context,
                                  //             "+91${phoneController.text.toString()}");
                                  //       } else {
                                  //         loginStore.loginScaffoldKey.currentState
                                  //             ?.showSnackBar(SnackBar(
                                  //           behavior: SnackBarBehavior.floating,
                                  //           backgroundColor: Colors.red,
                                  //           content: Text(
                                  //             'Please enter a phone number',
                                  //             style: TextStyle(color: Colors.white),
                                  //           ),
                                  //         ));
                                  //       }
                                  //     },
                                  //     color: MyColors.primaryColor,
                                  //     shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(14))),
                                  //     child: Container(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 8, horizontal: 8),
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         children: <Widget>[
                                  //           Text(
                                  //             'Next',
                                  //             style: TextStyle(color: Colors.white),
                                  //           ),
                                  //           Container(
                                  //             padding: const EdgeInsets.all(8),
                                  //             decoration: BoxDecoration(
                                  //               borderRadius:
                                  //                   const BorderRadius.all(
                                  //                       Radius.circular(20)),
                                  //               color: MyColors.primaryColorLight,
                                  //             ),
                                  //             child: Icon(
                                  //               Icons.arrow_forward_ios,
                                  //               color: Colors.white,
                                  //               size: 16,
                                  //             ),
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          : Container(),

                      GestureDetector(
                        onTap: () async {
                          if (widget.user == "signup") {
                            print('uuyguyguguy');
                            if (nameController.text.isNotEmpty) {
                              if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(emailController.text
                                      .toLowerCase()
                                      .toString())) {
                                if (email != "" || email != null) {
                                  setState(() {
                                    loading = true;
                                  });
                                  globals.email = emailController.text
                                      .toLowerCase()
                                      .toString();
                                  FirebaseAuth _auth = FirebaseAuth.instance;

                                  // if (signin == false) {
                                  userprofile(
                                      listOfCourses: [],
                                      linked: "true",
                                      name: nameController.text.toString(),
                                      image: '',
                                      mobilenumber: globals.phone,
                                      authType: 'phoneAuth',
                                      phoneVerified: true,
                                      email: globals.email);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => HomePage(),
                                    ),
                                  );
                                  // Toast.show(logi.user!.email);
                                  print(
                                      "llllllllllllllllllllllll ${globals.phone}");
                                  // } else {
                                  //   userprofile(
                                  //       name: nameController.text.toString(),
                                  //       image: '',
                                  //       mobilenumber: globals.phone,
                                  //       authType: 'phoneAuth',
                                  //       phoneVerified: true,
                                  //       email: globals.email);
                                  // }

                                  try {
                                    // globals.name =
                                    //     nameController.text.toString();
                                    // var user = _auth.currentUser;
                                    // if (user != null) {
                                    //   await FirebaseFirestore.instance
                                    //       .collection('Users')
                                    //       .doc(FirebaseAuth
                                    //           .instance.currentUser!.uid)
                                    //       .update({
                                    //     "linked": "true",
                                    //   });
                                    //   var userDocs;
                                    //   try {
                                    //     userDocs = await FirebaseFirestore
                                    //         .instance
                                    //         .collection('Users')
                                    //         .doc(FirebaseAuth
                                    //             .instance.currentUser!.uid)
                                    //         .get();
                                    //   } catch (e) {
                                    //     if (userDocs.data() == null) {
                                    //       await FirebaseFirestore.instance
                                    //           .collection('Users')
                                    //           .doc(FirebaseAuth
                                    //               .instance.currentUser!.uid)
                                    //           .update({
                                    //         "linked": "true",
                                    //       });
                                    //       // Toast.show('user data does not exist');

                                    //       setState(() {
                                    //         loading = false;
                                    //       });
                                    //     }
                                    //   }

                                    //   setState(() {
                                    //     loading = false;
                                    //   });
                                    // } else {
                                    //   Toast.show('user does not exist');
                                    //   setState(() {
                                    //     loading = false;
                                    //   });
                                    // }

                                    var value = await FirebaseAuth
                                        .instance.currentUser!.uid;
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('login', "true");
                                    print("sdjsodjew${globals.moneyrefcode}");
                                    try {
                                      await UserProvider().onStateChanged(
                                          FirebaseAuth.instance.currentUser!);
                                    } catch (e) {
                                      print("poooiiieirj${e.toString()}");
                                    }
                                    if (globals.moneyrefcode != '') {
                                      print("ijsofjdserer");
                                      courseId =
                                          globals.moneyrefcode.split('-')[1];
                                      try {
                                        print("sdjsdfgdohroeodjew");
                                        FirebaseFirestore.instance
                                            .collection("Users_dataly")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get()
                                            .then((value) {
                                          FirebaseFirestore.instance
                                              .collection("Users_dataly")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "sendermoneyrefcode":
                                                globals.moneyrefcode,
                                            "sendermoneyrefuid": globals
                                                .moneyrefcode
                                                .split('-')[2],
                                            "senderrefvalidfrom": DateTime.now()
                                          });

                                          FirebaseFirestore.instance
                                              .collection("AffiliatePayments")
                                              .doc()
                                              .set({
                                            "sendermoneyrefcode":
                                                globals.moneyrefcode,
                                            "sendermoneyrefuid": globals
                                                .moneyrefcode
                                                .split('-')[2],
                                            "senderrefvalidfrom": DateTime.now()
                                          });
                                        });
                                      } catch (e) {
                                        print("poooiiieirj${e.toString()}");
                                        FirebaseFirestore.instance
                                            .collection("Users_dataly")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "sendermoneyrefcode":
                                              globals.moneyrefcode,
                                          "sendermoneyrefuid": globals
                                              .moneyrefcode
                                              .split('-')[2],
                                          "senderrefvalidfrom": DateTime.now()
                                        });
                                      }
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => CatelogueScreen(),
                                        ),
                                      );
                                    } else {
                                      if (globals.survay == "done") {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => HomePage(),
                                          ),
                                        );
                                      } else {
                                        // Navigator.of(context).pushReplacement(
                                        //   MaterialPageRoute(
                                        //     builder: (_) => CheckboxPage(),
                                        //   ),
                                        // );
                                      }
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  } catch (e) {
                                    Toast.show("error jkl ${e.toString()}");
                                    print("jkl");
                                    print(e.toString());
                                    if (globals.survay == "done") {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => HomePage(),
                                        ),
                                      );
                                    } else {
                                      // Navigator.of(context).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder: (_) => CheckboxPage(),
                                      //   ),
                                      // );
                                    }
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  // setState(() {
                                  //     loginStore.isLoginLoading = false;
                                  //   });
                                  Toast.show('Please enter a email');

                                  //  setState(() {
                                  //       loginStore.isLoginLoading = false;
                                  //     });
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                Toast.show('Please enter a valid email');
                              }
                              //        var user = FirebaseAuth.instance.currentUser;
                              //       if (nameController.text.isNotEmpty) {
                              //         if (user != null) {
                              // DocumentSnapshot userDocs = await FirebaseFirestore
                              //     .instance
                              //     .collection('Users')
                              //     .doc(FirebaseAuth.instance.currentUser!.uid)
                              //     .get();
                              // if (userDocs.data() == null) {
                              //   userprofile(
                              //       name: '',
                              //       image: '',
                              //       mobilenumber: mobile.text,
                              //       authType: 'phoneAuth',
                              //       phoneVerified: true,
                              //       email: '');
                              //   Toast.show('Account Created');
                              // }
                              //       } else {
                              //         SnackBar(
                              //           behavior: SnackBarBehavior.floating,
                              //           backgroundColor: Colors.red,
                              //           content: Text(
                              //             'Please enter your name',
                              //             style: TextStyle(color: Colors.white),
                              //           ),
                              //         );
                              //       }
                            } else {
                              Toast.show("please enter your name");
                            }
                          } else if (widget.user == "signin") {
                            bool otpverified = true;
                            print('dfgdrgergreger');
                            if (passwordController.text.isNotEmpty) {
                              setState(() {
                                loading = true;
                              });
                              User? user;
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              try {
                                user = (await _auth.signInWithEmailAndPassword(
                                        email: emailController.text
                                            .toLowerCase()
                                            .toString(),
                                        password:
                                            passwordController.text.toString()))
                                    .user;

                                //otp verification and linking
                                try {
                                  await _auth.currentUser!
                                      .linkWithCredential(globals.credental);
                                  await FirebaseFirestore.instance
                                      .collection('Users_dataly')
                                      .doc(_auth.currentUser!.uid)
                                      .update({
                                    "linked": "true",
                                  });
                                } catch (e) {
                                  Toast.show(e.toString());
                                  otpverified = false;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => OtpPage("fromemailpage"),
                                    ),
                                  );
                                }

                                var value = await FirebaseAuth
                                    .instance.currentUser!.uid;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('login', "true");

                                setState(() {
                                  loading = false;
                                });
                              } on FirebaseException catch (e) {
                                print("iooijjj${e.code}");
                                setState(() {
                                  loading = false;
                                });
                                // Toast.show(e.toString());
                                if (e.code.toString() == "wrong-password") {
                                  setState(() {
                                    loading = false;
                                  });
                                  Toast.show("wrong password");
                                }
                                Toast.show(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              }

                              // Toast.show("here");
                              if (user != null) {
                                if (globals.moneyrefcode != '') {
                                  courseId = globals.moneyrefcode.split('-')[1];
                                  try {
                                    FirebaseFirestore.instance
                                        .collection("Users_dataly")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .get()
                                        .then((value) {
                                      if (value.data()!['sendermoneyrefcode'] !=
                                          globals.moneyrefcode) {
                                        FirebaseFirestore.instance
                                            .collection("Users_dataly")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "sendermoneyrefcode":
                                              globals.moneyrefcode,
                                          "sendermoneyrefuid": globals
                                              .moneyrefcode
                                              .split('-')[2],
                                          "senderrefvalidfrom": DateTime.now()
                                        });
                                      }
                                    });
                                  } catch (e) {
                                    FirebaseFirestore.instance
                                        .collection("Users_dataly")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "sendermoneyrefcode":
                                          globals.moneyrefcode,
                                      "sendermoneyrefuid":
                                          globals.moneyrefcode.split('-')[2],
                                      "senderrefvalidfrom": DateTime.now()
                                    });
                                    print("poooiiieirj${e.toString()}");
                                  }
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => CatelogueScreen(),
                                    ),
                                  );
                                } else {
                                  //adding condition for handling otp verification error
                                  if (otpverified) {
                                    if (globals.survay == "done") {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => HomePage(),
                                        ),
                                      );
                                    } else {
                                      // Navigator.of(context).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder: (_) => CheckboxPage(),
                                      //   ),
                                      // );
                                    }
                                  }
                                }
                              } else {
                                Toast.show("wrong password");
                              }
                            } else {
                              Toast.show("enter your password");
                            }
                          } else {
                            await email(context,
                                emailController.text.toLowerCase().toString());
                          }

                          // loginStore.email(
                          //     context, emailController.text.toString());
                          // if (RegExp(
                          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //     .hasMatch(
                          //         emailController.text.toString())) {
                          //   if (emailController.text.isNotEmpty) {
                          //     loginStore.isLoginLoading = true;
                          //     final docSnapshots = await FirebaseFirestore
                          //         .instance
                          //         .collection('Users')
                          //         .where('email',
                          //             isEqualTo:
                          //                 "${emailController.text.toString()}")
                          //         .get();
                          //     try {
                          //       if (docSnapshots.docs.first.exists) {
                          //         print(docSnapshots.docs.first.exists);
                          //         //    setState(() {
                          //         //   loginStore.isLoginLoading = false;
                          //         // });
                          //         Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     SigninPasswordPage(
                          //                         email: emailController
                          //                             .text
                          //                             .toString())));
                          //       } else {
                          //         //  setState(() {
                          //         //   loginStore.isLoginLoading = false;
                          //         // });
                          //         Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     SignupPasswordPage(
                          //                         email: emailController
                          //                             .text
                          //                             .toString())));
                          //       }
                          //     } catch (e) {
                          //       // setState(() {
                          //       //   loginStore.isLoginLoading = false;
                          //       // });

                          //       if (e.toString() ==
                          //           "Bad state: No element") {
                          //         Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     SignupPasswordPage(
                          //                         email: emailController
                          //                             .text
                          //                             .toString())));
                          //       }
                          //       ;
                          //     }
                          //   } else {
                          //     // setState(() {
                          //     //     loginStore.isLoginLoading = false;
                          //     //   });
                          //     ScaffoldMessenger.of(context)
                          //         .showSnackBar(
                          //       const SnackBar(
                          //         content: Text('Please enter a email'),
                          //       ),
                          //     );
                          //     //  setState(() {
                          //     //       loginStore.isLoginLoading = false;
                          //     //     });
                          //   }
                          // }else{

                          // }
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
                                        borderRadius: const BorderRadius.all(
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
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 10),
                      //   constraints:
                      //       const BoxConstraints(maxWidth: 500),
                      //   child: RaisedButton(
                      //     onPressed: () {
                      //       if (phoneController.text.isNotEmpty) {
                      //         loginStore.getCodeWithPhoneNumber(context,
                      //             "+91${phoneController.text.toString()}");
                      //       } else {
                      //         loginStore.loginScaffoldKey.currentState
                      //             ?.showSnackBar(SnackBar(
                      //           behavior: SnackBarBehavior.floating,
                      //           backgroundColor: Colors.red,
                      //           content: Text(
                      //             'Please enter a phone number',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ));
                      //       }
                      //     },
                      //     color: MyColors.primaryColor,
                      //     shape: const RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.all(
                      //             Radius.circular(14))),
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(
                      //           vertical: 8, horizontal: 8),
                      //       child: Row(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Text(
                      //             'Next',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.all(8),
                      //             decoration: BoxDecoration(
                      //               borderRadius:
                      //                   const BorderRadius.all(
                      //                       Radius.circular(20)),
                      //               color: MyColors.primaryColorLight,
                      //             ),
                      //             child: Icon(
                      //               Icons.arrow_forward_ios,
                      //               color: Colors.white,
                      //               size: 16,
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> email(BuildContext context, String email) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      if (email != "" || email != null) {
        globals.email = email;
        setState(() {
          loading = true;
        });
        final docSnapshots = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('email', isEqualTo: "${email}")
            .get();
        setState(() {
          loading = false;
        });
        try {
          if (docSnapshots.docs.first.exists) {
            print(docSnapshots.docs.first.exists);
            //    setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            setState(() {
              loading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SigninPasswordPage(email: email),
              ),
            );
          } else {
            setState(() {
              loading = false;
            });
            //  setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
        } catch (e) {
          // Toast.show(e.toString());
          setState(() {
            loading = false;
          });
          // setState(() {
          //   loginStore.isLoginLoading = false;
          // });
          if (e.toString() == "Bad state: No element") {
            setState(() {
              loading = false;
            });

            // isLoginLoading = false;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
          ;
        }
      } else {
        setState(() {
          loading = false;
        });
        // setState(() {
        //     loginStore.isLoginLoading = false;
        //   });
        Toast.show('Please enter a email');

        //  setState(() {
        //       loginStore.isLoginLoading = false;
        //     });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }
}

// import 'dart:math';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dataly_app/authentication/SignUpForm.dart';
// import 'package:dataly_app/authentication/firebase_auth.dart';
// import 'package:dataly_app/authentication/loginform.dart';
// import 'package:dataly_app/authentication/onboardbg.dart';
// import 'package:dataly_app/authentication/phoneauthnew.dart';
// import 'package:dataly_app/globals.dart';
// import 'package:dataly_app/home.dart';
// import 'package:dataly_app/models/existing_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:snippet_coder_utils/FormHelper.dart';
// import 'package:snippet_coder_utils/ProgressHUD.dart';
// import 'package:snippet_coder_utils/hex_color.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'package:url_launcher/url_launcher.dart';

// import '../Providers/UserProvider.dart';
// import '../pages/newentername.dart';
// import '../widgets/loading.dart';
// import 'package:dataly_app/global_variable.dart' as globals;

// class Onboardew extends StatefulWidget {
//   Onboardew({Key? key}) : super(key: key);

//   @override
//   State<Onboardew> createState() => _OnboardewState();
// }

// class _OnboardewState extends State<Onboardew> {
//   // List<ExistingUser> listOfAllExistingUser = [];

//   // void getListOfExistingUsers() async {
//   //   final rawData = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbzOsK2DmwO6lA_Vv6zaeZTdZA2G6sgN4RmWl9kdb1AsZ6Sz0oCdiSvvEVoYZqQZe8sx/exec'));
//   //   var rawJson = convert.jsonDecode(rawData.body);

//   //   rawJson.forEach((json) async {
//   //     print(json['name']);
//   //     ExistingUser existingUser = ExistingUser();
//   //     existingUser.name = json['name'];
//   //     existingUser.email = json['email'];
//   //     existingUser.courseId = json['courseId'];
//   //     listOfAllExistingUser.add(existingUser);
//   //   });
//   // }
//   bool isloading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     // getListOfExistingUsers();
//     print(globals.action);
//     print('rrrrrrrrrrrrrrr');
//     super.initState();
//   }

//   bool? googleloading = false;
//   bool formVisible = false;
//   bool phoneVisible = false;
//   int _formIndex = 1;

//   static final _phonekey = GlobalKey<FormState>();
//   static final _otpkey = GlobalKey<FormState>();
//   String? countryCode = '+91';
//   late final String? verifyid;
//   bool _isloading = false;
//   bool _verifyloading = false;
//   TextEditingController otp = TextEditingController();
//   static final currentUsern = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     print(globals.action);
//     return SafeArea(
//       child: Scaffold(
//         body: ProgressHUD(
//           child: onboarding(),
//           inAsyncCall: isloading,
//           opacity: 0.3,
//           key: UniqueKey(),
//         ),
//       ),
//     );
//   }

//   Widget onboarding() {
//     final userprovider = Provider.of<UserProvider>(context);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     var verticalScale = height / mockUpHeight;
//     var horizontalScale = width / mockUpWidth;
//     return Scaffold(
//         body: Stack(
//       children: [
//         Onboardbg(),
//         Container(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: verticalScale * 46,
//                 ),
//                 Center(
//                     child: Image.asset(
//                   'assets/logo.png',
//                   height: verticalScale * 80,
//                   width: horizontalScale * 238,
//                 )),
//                 SizedBox(
//                   height: verticalScale * 30,
//                 ),
//                 RichText(
//                     textAlign: TextAlign.center,
//                     textScaleFactor: min(horizontalScale, verticalScale),
//                     text: TextSpan(
//                         style: TextStyle(
//                           fontSize: 25,
//                         ),
//                         children: [
//                           TextSpan(text: "Learn "),
//                           TextSpan(
//                               text: 'data science \n',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           TextSpan(text: "and "),
//                           TextSpan(
//                               text: 'ML ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           TextSpan(text: "on the go with \nour "),
//                           TextSpan(
//                               text: 'mobile app ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                         ])),
//                 SizedBox(
//                   height: verticalScale * 47.44,
//                 ),
//                 Container(
//                   width: horizontalScale * 388,
//                   decoration: BoxDecoration(
//                       boxShadow: [
//                         // color: Colors.white, //background color of box
//                         BoxShadow(
//                           color: Color.fromRGBO(123, 98, 223, 1),
//                           blurRadius: 18.0, // soften the shadow
//                           offset: Offset(
//                             0, // Move to right 10  horizontally
//                             10.0, // Move to bottom 10 Vertically
//                           ),
//                         )
//                       ],
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(
//                         min(horizontalScale, verticalScale) * 25,
//                       ))),
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(
//                         horizontalScale * 0.76,
//                         verticalScale * 35.56,
//                         horizontalScale * 0.24,
//                         verticalScale * 35.56),
//                     child: Column(
//                       children: [
//                         ListView(
//                           padding: EdgeInsets.fromLTRB(
//                               horizontalScale * 25,
//                               verticalScale * 23,
//                               horizontalScale * 24,
//                               verticalScale * 33),
//                           shrinkWrap: true,
//                           children: [
//                             Center(
//                                 child: Text(
//                               "",
//                               textScaleFactor:
//                                   min(horizontalScale, verticalScale),
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 0),
//                             )),
//                             SizedBox(
//                               height: verticalScale * 0,
//                             ),
//                             Form(
//                               key: _phonekey,
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     height: 60.5,
//                                     width: horizontalScale * 64,
//                                     child: TextFormField(
//                                       initialValue: countryCode,
//                                       onChanged: (v) {
//                                         setState(() {
//                                           countryCode = v;
//                                         });
//                                       },
//                                       keyboardType: TextInputType.phone,
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.deny(' ')
//                                       ],
//                                       decoration: InputDecoration(
//                                           hintText: 'Code',
//                                           labelText: 'Code',
//                                           floatingLabelStyle: TextStyle(
//                                               fontSize: 18 *
//                                                   min(horizontalScale,
//                                                       verticalScale),
//                                               fontWeight: FontWeight.w500,
//                                               color: Color.fromRGBO(
//                                                   123, 98, 223, 1)),
//                                           labelStyle: TextStyle(
//                                             fontSize: 18 *
//                                                 min(horizontalScale,
//                                                     verticalScale),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Color.fromRGBO(
//                                                       123, 98, 223, 1),
//                                                   width: 2)),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.only(
//                                                 topLeft: Radius.circular(4),
//                                                 topRight: Radius.circular(0),
//                                                 bottomLeft: Radius.circular(4),
//                                                 bottomRight:
//                                                     Radius.circular(0)),
//                                             borderSide: BorderSide(
//                                                 color: Color.fromRGBO(
//                                                     123, 98, 223, 1),
//                                                 width: 2),
//                                           ),
//                                           errorMaxLines: 2),
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return 'Please Enter Code';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 1,
//                                   ),
//                                   Flexible(
//                                     child: Container(
//                                       height: 61.6,
//                                       child: TextFormField(
//                                         controller: mobile,
//                                         decoration: InputDecoration(
//                                             hintText: 'Phone',
//                                             // labelText: 'Phone Number',
//                                             counterText: '',
//                                             floatingLabelStyle: TextStyle(
//                                                 fontSize: 18 *
//                                                     min(horizontalScale,
//                                                         verticalScale),
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color.fromRGBO(
//                                                     123, 98, 223, 1)),
//                                             labelStyle: TextStyle(
//                                               fontSize: 18 *
//                                                   min(horizontalScale,
//                                                       verticalScale),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Color.fromRGBO(
//                                                         123, 98, 223, 1),
//                                                     width: 2)),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(0),
//                                                   topRight: Radius.circular(0),
//                                                   bottomLeft:
//                                                       Radius.circular(0),
//                                                   bottomRight:
//                                                       Radius.circular(0)),
//                                               borderSide: BorderSide(
//                                                   color: Color.fromRGBO(
//                                                       123, 98, 223, 1),
//                                                   width: 2),
//                                             ),
//                                             suffixIcon: Icon(
//                                               Icons.phone,
//                                               color: Color.fromRGBO(
//                                                   123, 98, 223, 1),
//                                             )),
//                                         keyboardType: TextInputType.phone,
//                                         maxLength: 10,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Please Enter Phone No';
//                                           } else if (!RegExp(
//                                                   r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
//                                               .hasMatch(value)) {
//                                             return 'Please enter a valid Phone Number';
//                                           } else if (value.length < 10) {
//                                             return 'Enter 10 digit Phone number';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 1,
//                                   ),
//                                   Center(
//                                     child: Container(
//                                       height: 61,
//                                       width: 60,
//                                       child: ElevatedButton(
//                                         onPressed: (() async {
//                                           if (_phonekey.currentState!
//                                               .validate()) {
//                                             setState(() {
//                                               isloading = true;
//                                             });

//                                             FirebaseAuth auth =
//                                                 FirebaseAuth.instance;
//                                             await auth.verifyPhoneNumber(
//                                               phoneNumber:
//                                                   '$countryCode ${mobile.text}',
//                                               verificationCompleted:
//                                                   (PhoneAuthCredential
//                                                       credential) async {},
//                                               codeAutoRetrievalTimeout:
//                                                   (String verificationId) {},
//                                               codeSent: (String verificationId,
//                                                   int? forceResendingToken) {
//                                                 verifyid = verificationId;

//                                                 showDialog(
//                                                     context: context,
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       Future.delayed(
//                                                           Duration(seconds: 5),
//                                                           () {
//                                                         Navigator.of(context)
//                                                             .pop(true);
//                                                       });
//                                                       setState(() {
//                                                         isloading = false;
//                                                       });
//                                                       return AlertDialog(
//                                                         title: Center(
//                                                           child: Column(
//                                                             children: [
//                                                               Lottie.asset(
//                                                                   'assets/otplottie.json',
//                                                                   height:
//                                                                       height *
//                                                                           0.15,
//                                                                   width: width *
//                                                                       0.5),
//                                                               Text(
//                                                                 'OTP Sent Successfully',
//                                                                 textScaleFactor: min(
//                                                                     horizontalScale,
//                                                                     verticalScale),
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .green,
//                                                                     fontSize:
//                                                                         22,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         content: Column(
//                                                           mainAxisSize:
//                                                               MainAxisSize.min,
//                                                           children: [
//                                                             Text(
//                                                               'OTP has been sent to',
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                               style:
//                                                                   TextStyle(),
//                                                             ),
//                                                             Text(
//                                                               '${mobile.text}',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                             Text(
//                                                               'Please enter the OTP in the field below to verify your phone.',
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                             ),
//                                                             SizedBox(
//                                                               height:
//                                                                   verticalScale *
//                                                                       10,
//                                                             ),
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 Navigator.of(
//                                                                         context)
//                                                                     .pop(true);
//                                                               },
//                                                               child: Container(
//                                                                 //height: 20,
//                                                                 child: Padding(
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .all(
//                                                                     min(horizontalScale,
//                                                                             verticalScale) *
//                                                                         10,
//                                                                   ),
//                                                                   child: Text(
//                                                                     'OK',
//                                                                     textScaleFactor: min(
//                                                                         horizontalScale,
//                                                                         verticalScale),
//                                                                     style: TextStyle(
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         color: Colors
//                                                                             .white,
//                                                                         fontSize:
//                                                                             20),
//                                                                   ),
//                                                                 ),
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: Color
//                                                                       .fromRGBO(
//                                                                           123,
//                                                                           98,
//                                                                           223,
//                                                                           1),
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       );
//                                                     });
//                                                 showToast('OTP sent');
//                                               },
//                                               verificationFailed:
//                                                   (FirebaseAuthException
//                                                       error) {
//                                                 // showToast(
//                                                 //     'Error Verifying\nPlease check your Mobile Number and try again');
//                                               },
//                                             );
//                                             setState(() {
//                                               isloading = false;
//                                             });
//                                           } else {
//                                             setState(() {
//                                               isloading = false;
//                                             });
//                                           }
//                                         }),
//                                         child: Text(
//                                           "send",
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                         style: ButtonStyle(
//                                           foregroundColor:
//                                               MaterialStateProperty.all<Color>(
//                                                   Color.fromRGBO(
//                                                       123, 98, 223, 1)),
//                                           backgroundColor:
//                                               MaterialStateProperty.all<Color>(
//                                                   Colors.white),
//                                           shape: MaterialStateProperty.all<
//                                               RoundedRectangleBorder>(
//                                             RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(0),
//                                                   topRight: Radius.circular(4),
//                                                   bottomLeft:
//                                                       Radius.circular(0),
//                                                   bottomRight:
//                                                       Radius.circular(4)),
//                                               side: BorderSide(
//                                                 width: 2,
//                                                 color: Color.fromRGBO(
//                                                     123, 98, 223, 1),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             // SizedBox(
//                             //   height: verticalScale * 18,
//                             // ),
//                             // Center(
//                             //   child: (_isloading)
//                             //       ? Loading()
//                             //       : InkWell(
//                             //           child: Container(
//                             //             //height: 20,
//                             //             child: Padding(
//                             //               padding: const EdgeInsets.all(8.0),
//                             //               child: Text(
//                             //                 'Send OTP',
//                             //                 textScaleFactor: min(
//                             //                     horizontalScale, verticalScale),
//                             //                 style: TextStyle(
//                             //                     fontWeight: FontWeight.bold,
//                             //                     color: Colors.white,
//                             //                     fontSize: 20),
//                             //               ),
//                             //             ),
//                             //             decoration: BoxDecoration(
//                             //               color: HexColor('6153D3'),
//                             //               borderRadius: BorderRadius.circular(
//                             //                   min(horizontalScale,
//                             //                           verticalScale) *
//                             //                       8),
//                             //               boxShadow: [
//                             //                 BoxShadow(
//                             //                   color: HexColor('6153D3'),
//                             //                   blurRadius:
//                             //                       10.0, // soften the shadow
//                             //                   offset: Offset(
//                             //                     0, // Move to right 10  horizontally
//                             //                     4.0, // Move to bottom 10 Vertically
//                             //                   ),
//                             //                 )
//                             //               ],
//                             //             ),
//                             //           ),
//                             //           onTap: () async {
//                             //             if (_phonekey.currentState!
//                             //                 .validate()) {
//                             //               setState(() {
//                             //                 _isloading = true;
//                             //               });
//                             //               FirebaseAuth auth =
//                             //                   FirebaseAuth.instance;
//                             //               await auth.verifyPhoneNumber(
//                             //                 phoneNumber:
//                             //                     '$countryCode ${mobile.text}',
//                             //                 verificationCompleted:
//                             //                     (PhoneAuthCredential
//                             //                         credential) async {},
//                             //                 codeAutoRetrievalTimeout:
//                             //                     (String verificationId) {},
//                             //                 codeSent: (String verificationId,
//                             //                     int? forceResendingToken) {
//                             //                   verifyid = verificationId;
//                             //                   setState(() {
//                             //                     _isloading = false;
//                             //                   });
//                             //                   showDialog(
//                             //                       context: context,
//                             //                       builder:
//                             //                           (BuildContext context) {
//                             //                         Future.delayed(
//                             //                             Duration(seconds: 5),
//                             //                             () {
//                             //                           Navigator.of(context)
//                             //                               .pop(true);
//                             //                         });
//                             //                         return AlertDialog(
//                             //                           title: Center(
//                             //                             child: Column(
//                             //                               children: [
//                             //                                 Lottie.asset(
//                             //                                     'assets/otplottie.json',
//                             //                                     height: height *
//                             //                                         0.15,
//                             //                                     width: width *
//                             //                                         0.5),
//                             //                                 Text(
//                             //                                   'OTP Sent Successfully',
//                             //                                   textScaleFactor: min(
//                             //                                       horizontalScale,
//                             //                                       verticalScale),
//                             //                                   style: TextStyle(
//                             //                                       color: Colors
//                             //                                           .green,
//                             //                                       fontSize: 22,
//                             //                                       fontWeight:
//                             //                                           FontWeight
//                             //                                               .bold),
//                             //                                 ),
//                             //                               ],
//                             //                             ),
//                             //                           ),
//                             //                           content: Column(
//                             //                             mainAxisSize:
//                             //                                 MainAxisSize.min,
//                             //                             children: [
//                             //                               Text(
//                             //                                 'OTP has been sent to',
//                             //                                 textAlign: TextAlign
//                             //                                     .center,
//                             //                                 style: TextStyle(),
//                             //                               ),
//                             //                               Text(
//                             //                                 '${mobile.text}',
//                             //                                 style: TextStyle(
//                             //                                     fontWeight:
//                             //                                         FontWeight
//                             //                                             .bold),
//                             //                               ),
//                             //                               Text(
//                             //                                 'Please enter the OTP in the field below to verify your phone.',
//                             //                                 textAlign: TextAlign
//                             //                                     .center,
//                             //                               ),
//                             //                               SizedBox(
//                             //                                 height:
//                             //                                     verticalScale *
//                             //                                         10,
//                             //                               ),
//                             //                               InkWell(
//                             //                                 onTap: () {
//                             //                                   Navigator.of(
//                             //                                           context)
//                             //                                       .pop(true);
//                             //                                 },
//                             //                                 child: Container(
//                             //                                   //height: 20,
//                             //                                   child: Padding(
//                             //                                     padding:
//                             //                                         EdgeInsets
//                             //                                             .all(
//                             //                                       min(horizontalScale,
//                             //                                               verticalScale) *
//                             //                                           10,
//                             //                                     ),
//                             //                                     child: Text(
//                             //                                       'OK',
//                             //                                       textScaleFactor: min(
//                             //                                           horizontalScale,
//                             //                                           verticalScale),
//                             //                                       style: TextStyle(
//                             //                                           fontWeight:
//                             //                                               FontWeight
//                             //                                                   .bold,
//                             //                                           color: Colors
//                             //                                               .white,
//                             //                                           fontSize:
//                             //                                               20),
//                             //                                     ),
//                             //                                   ),
//                             //                                   decoration:
//                             //                                       BoxDecoration(
//                             //                                     color: HexColor(
//                             //                                         '6153D3'),
//                             //                                     borderRadius:
//                             //                                         BorderRadius
//                             //                                             .circular(
//                             //                                                 5),
//                             //                                   ),
//                             //                                 ),
//                             //                               ),
//                             //                             ],
//                             //                           ),
//                             //                         );
//                             //                       });
//                             //                   showToast('OTP sent');
//                             //                 },
//                             //                 verificationFailed:
//                             //                     (FirebaseAuthException error) {
//                             //                   setState(() {
//                             //                     _isloading = false;
//                             //                   });
//                             //                   showToast(
//                             //                       'Error Verifying\nPlease check your Mobile Number and try again');
//                             //                   setState(() {
//                             //                     _isloading = false;
//                             //                   });
//                             //                 },
//                             //               );
//                             //             } else {}
//                             //           },
//                             //         ),
//                             // ),
//                             // SizedBox(
//                             //   height: verticalScale * 4,
//                             // ),
//                             // Divider(
//                             //   thickness: 2,
//                             // ),
//                             // SizedBox(
//                             //   height: verticalScale * 24,
//                             // ),
//                             // Center(
//                             //     child: Text(
//                             //   "Enter OTP",
//                             //   textScaleFactor:
//                             //       min(horizontalScale, verticalScale),
//                             //   style: TextStyle(
//                             //       fontWeight: FontWeight.bold, fontSize: 20),
//                             // )),
//                             SizedBox(
//                               height: verticalScale * 14,
//                             ),
//                             Form(
//                               key: _otpkey,
//                               child: TextFormField(
//                                 controller: otp,
//                                 textAlign: TextAlign.center,
//                                 // style: TextStyle(
//                                 //   letterSpacing: 8.0,
//                                 // ),
//                                 //obscureText: true,
//                                 decoration: InputDecoration(
//                                   //hintText: 'Enter One Time Password',
//                                   labelText: 'OTP',
//                                   floatingLabelAlignment:
//                                       FloatingLabelAlignment.center,
//                                   counterText: '',
//                                   floatingLabelStyle: TextStyle(
//                                       fontSize: 22 *
//                                           min(horizontalScale, verticalScale),
//                                       fontWeight: FontWeight.w500,
//                                       color: Color.fromRGBO(123, 98, 223, 1)),
//                                   labelStyle: TextStyle(
//                                     fontSize: 18 *
//                                         min(horizontalScale, verticalScale),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color:
//                                               Color.fromRGBO(123, 98, 223, 1),
//                                           width: 2)),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Color.fromRGBO(123, 98, 223, 1),
//                                         width: 2),
//                                   ),
//                                   // suffixIcon: Icon(
//                                   //   Icons.lock,
//                                   //   color: HexColor('6153D3'),
//                                   // )
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                                 maxLength: 6,
//                                 validator: (String? value) {
//                                   if (value!.isEmpty) {
//                                     return 'OTP is required';
//                                   } else if (!RegExp(r'^\d{6}$')
//                                       .hasMatch(value)) {
//                                     return 'OTP must be 6 digits only';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: verticalScale * 32,
//                             ),
//                             Center(
//                               child: (_verifyloading)
//                                   ? Loading()
//                                   : InkWell(
//                                       child: Container(
//                                         height: 54,
//                                         child: Padding(
//                                           padding: EdgeInsets.all(
//                                             min(horizontalScale,
//                                                     verticalScale) *
//                                                 8,
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               'SignIn',
//                                               textScaleFactor: min(
//                                                   horizontalScale,
//                                                   verticalScale),
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.white,
//                                                   fontSize: 23),
//                                             ),
//                                           ),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color:
//                                               Color.fromRGBO(123, 98, 223, 1),
//                                           borderRadius: BorderRadius.circular(
//                                               min(horizontalScale,
//                                                       verticalScale) *
//                                                   15),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Color.fromRGBO(
//                                                   123, 98, 223, 1),
//                                               blurRadius:
//                                                   10.0, // soften the shadow
//                                               offset: Offset(0, 4.0),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         if (_otpkey.currentState!.validate()) {
//                                           setState(() {
//                                             _verifyloading = true;
//                                           });
//                                           // setState(() {
//                                           //   isloading = true;
//                                           // });
//                                           FirebaseAuth auth =
//                                               FirebaseAuth.instance;
//                                           final code = otp.text.trim();
//                                           try {
//                                             AuthCredential credential =
//                                                 PhoneAuthProvider.credential(
//                                                     verificationId: verifyid!,
//                                                     smsCode: code);
//                                             var result =
//                                                 await auth.signInWithCredential(
//                                                     credential);
//                                             var value = await FirebaseAuth
//                                                 .instance.currentUser!.uid;
//                                             print(value);
//                                             final prefs =
//                                                 await SharedPreferences
//                                                     .getInstance();
//                                             print("6");
//                                             await prefs.setString(
//                                                 '$value', "true");

//                                             setState(() {
//                                               _verifyloading = false;
//                                             });

//                                             setState(() {
//                                               isloading = false;
//                                             });

//                                             AwesomeDialog(
//                                               context: context,
//                                               animType: AnimType.LEFTSLIDE,
//                                               headerAnimationLoop: true,
//                                               dialogType: DialogType.SUCCES,
//                                               showCloseIcon: true,
//                                               title: 'Verified!',
//                                               desc:
//                                                   'Your Mobile Number\n ${mobile.text} \nhas been successfully verified!\n Please wait you will be redirected to the HomePage.',
//                                               btnOkOnPress: () {
//                                                 debugPrint('OnClcik');
//                                               },
//                                               btnOkIcon: Icons.check_circle,
//                                               onDissmissCallback: (type) {
//                                                 debugPrint(
//                                                     'Dialog Dissmiss from callback $type');
//                                               },
//                                             ).show();

//                                             var user = result.user;
//                                             if (user != null) {
//                                               DocumentSnapshot userDocs =
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection('Users')
//                                                       .doc(FirebaseAuth.instance
//                                                           .currentUser!.uid)
//                                                       .get();
//                                               if (userDocs.data() == null) {
//                                                 userprofile(
//                                                     name: '',
//                                                     image: '',
//                                                     mobilenumber: mobile.text,
//                                                     authType: 'phoneAuth',
//                                                     phoneVerified: true,
//                                                     email: '');
//                                                 // showToast('Account Created');
//                                               }
//                                               await Future.delayed(
//                                                   Duration(seconds: 4));
//                                               await userprovider
//                                                   .reloadUserModel();
//                                               await currentUsern?.reload();
//                                               print(
//                                                   user.displayName.toString());
//                                               print(currentUsern?.displayName
//                                                   .toString());
//                                               print(currentUsern?.displayName
//                                                   .toString());
//                                               if (user.displayName != null) {
//                                                 print('11111111111111');
//                                                 Navigator.pushAndRemoveUntil(
//                                                     context,
//                                                     PageTransition(
//                                                         duration: Duration(
//                                                             milliseconds: 200),
//                                                         curve:
//                                                             Curves.bounceInOut,
//                                                         type: PageTransitionType
//                                                             .rightToLeftWithFade,
//                                                         child: HomePage()),
//                                                     (route) => false);
//                                               }
//                                               if (user.displayName == null) {
//                                                 print('2222222222222');
//                                                 Navigator.push(
//                                                   context,
//                                                   PageTransition(
//                                                       duration: Duration(
//                                                           milliseconds: 200),
//                                                       curve: Curves.bounceInOut,
//                                                       type: PageTransitionType
//                                                           .rightToLeft,
//                                                       child: HomePage()),
//                                                 );
//                                               }

//                                               await AwesomeNotifications().createNotification(
//                                                   content: NotificationContent(
//                                                       id: 1234,
//                                                       channelKey: 'image',
//                                                       title:
//                                                           'Welcome to CloudyML',
//                                                       body:
//                                                           'It\'s great to have you on CloudyML',
//                                                       bigPicture:
//                                                           'asset://assets/HomeImage.png',
//                                                       largeIcon:
//                                                           'asset://assets/logo2.png',
//                                                       notificationLayout:
//                                                           NotificationLayout
//                                                               .BigPicture,
//                                                       displayOnForeground:
//                                                           true));
//                                               await Provider.of<UserProvider>(
//                                                       context,
//                                                       listen: false)
//                                                   .addToNotificationP(
//                                                 title: 'Welcome to CloudyML',
//                                                 body:
//                                                     'It\'s great to have you on CloudyML',
//                                                 notifyImage:
//                                                     'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e',
//                                                 NDate: DateFormat(
//                                                         'dd-MM-yyyy | h:mm a')
//                                                     .format(DateTime.now()),
//                                               );
//                                             } else {
//                                               setState(() {
//                                                 isloading = false;
//                                               });
//                                               setState(() {
//                                                 _verifyloading = false;
//                                               });
//                                               showToast(
//                                                   'Incorrect OTP\nPlease try again');
//                                               print("Error");
//                                             }
//                                           } catch (e) {
//                                             showToast(e.toString());
//                                             setState(() {
//                                               isloading = false;
//                                             });
//                                             setState(() {
//                                               _verifyloading = false;
//                                             });
//                                             showToast(e.toString());
//                                             setState(() {
//                                               _verifyloading = false;
//                                             });
//                                           }
//                                         } else {
//                                           setState(() {
//                                             isloading = false;
//                                           });
//                                         }
//                                       },
//                                     ),
//                             ),
//                           ],
//                         ),

//                         // InkWell(
//                         //   onTap: () {
//                         //     setState(() {
//                         //       phoneVisible = true;
//                         //     });
//                         //   },
//                         //   child: Container(
//                         //     height: 45 * verticalScale,
//                         //     width: 273 * horizontalScale,
//                         //     decoration: BoxDecoration(
//                         //         borderRadius: BorderRadius.circular(
//                         //             min(horizontalScale, verticalScale) * 8),
//                         //         border: Border.all(
//                         //             color: HexColor('7B62DF'), width: 2)),
//                         //     child: Center(
//                         //       child: Text(
//                         //         'Continue with Phone',
//                         //         textScaleFactor:
//                         //             min(horizontalScale, verticalScale),
//                         //         style: TextStyle(
//                         //             fontFamily: 'SemiBold',
//                         //             color: Colors.black,
//                         //             fontSize: 20),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         // SizedBox(
//                         //   height: verticalScale * 21,
//                         // ),
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: Divider(
//                               color: Colors.black,
//                               thickness: 2,
//                             )),
//                             SizedBox(
//                               width: horizontalScale * 15,
//                             ),
//                             Text(
//                               'OR',
//                               textScaleFactor:
//                                   min(horizontalScale, verticalScale),
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               width: horizontalScale * 15,
//                             ),
//                             Expanded(
//                                 child: Divider(
//                               color: Colors.black,
//                               thickness: 2,
//                             )),
//                           ],
//                         ),
//                         SizedBox(
//                           height: verticalScale * 31,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               formVisible = true;
//                               _formIndex = 1;
//                             });
//                           },
//                           child: Container(
//                             height: 45 * verticalScale,
//                             width: 273 * horizontalScale,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                     min(horizontalScale, verticalScale) * 8),
//                                 border: Border.all(
//                                     color: Color.fromRGBO(123, 98, 223, 1),
//                                     width: 2)),
//                             child: Center(
//                               child: Text(
//                                 'Continue with Email',
//                                 textScaleFactor:
//                                     min(horizontalScale, verticalScale),
//                                 style: TextStyle(
//                                     fontFamily: 'SemiBold',
//                                     color: Colors.black,
//                                     fontSize: 20),
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(
//                           height: verticalScale * 24,
//                         ),
//                         // Text(
//                         //   'Don’t have an account?',
//                         //   textScaleFactor: min(horizontalScale, verticalScale),
//                         //   style: TextStyle(fontSize: 20),
//                         // ),
//                         // InkWell(
//                         //   onTap: () {
//                         //     setState(() {
//                         //       formVisible = true;
//                         //       _formIndex = 2;
//                         //     });
//                         //   },
//                         //   child: Center(
//                         //     child: Text(
//                         //       'Sign Up with Email',
//                         //       textScaleFactor:
//                         //           min(horizontalScale, verticalScale),
//                         //       style: TextStyle(
//                         //           fontFamily: 'SemiBold',
//                         //           color: HexColor('0047FF'),
//                         //           fontSize: 20),
//                         //     ),
//                         //   ),
//                         // )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: verticalScale * 73.56,
//                 ),
//                 Container(
//                   child: InkWell(
//                     onTap: () async {
//                       final Uri params = Uri(
//                           scheme: 'mailto',
//                           path: 'app.support@cloudyml.com',
//                           query: 'subject=Query about App');
//                       var mailurl = params.toString();
//                       if (await canLaunch(mailurl)) {
//                         await launch(mailurl);
//                       } else {
//                         throw 'Could not launch $mailurl';
//                       }
//                     },
//                     child: Text(
//                       'Need Help with Login?',
//                       textScaleFactor: min(horizontalScale, verticalScale),
//                       style: TextStyle(
//                           fontFamily: 'Regular',
//                           fontSize: 19,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: height*0.0705,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedSwitcher(
//             duration: Duration(milliseconds: 200),
//             child: (formVisible)
//                 ? (_formIndex == 1)
//                     ? Container(
//                         color: Colors.black54,
//                         alignment: Alignment.center,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.06)),
//                                       ),
//                                       child: Text(
//                                         'Login',
//                                         textScaleFactor:
//                                             min(horizontalScale, verticalScale),
//                                         style: TextStyle(
//                                           color: Color.fromRGBO(97, 83, 211,
//                                               1), //Color.fromRGBO(123, 98, 223, 1)
//                                           fontSize: 18,
//                                         ),
//                                       )),
//                                   SizedBox(
//                                     width: horizontalScale * 17,
//                                   ),
//                                   IconButton(
//                                       color: Colors.white,
//                                       onPressed: () {
//                                         setState(() {
//                                           formVisible = false;
//                                         });
//                                       },
//                                       icon: Icon(Icons.clear))
//                                 ],
//                               ),
//                               Container(
//                                 child: AnimatedSwitcher(
//                                   duration: Duration(milliseconds: 200),
//                                   child: LoginForm(
//                                     page: "OnBoard",
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     : Container(
//                         color: Colors.black54,
//                         alignment: Alignment.center,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.06)),
//                                       ),
//                                       child: Text('SignUp',
//                                           textScaleFactor: min(
//                                               horizontalScale, verticalScale),
//                                           style: TextStyle(
//                                             color:
//                                                 Color.fromRGBO(97, 83, 211, 1),
//                                             fontSize: 18,
//                                           ))),
//                                   SizedBox(
//                                     width: horizontalScale * 17,
//                                   ),
//                                   IconButton(
//                                       color: Colors.white,
//                                       onPressed: () {
//                                         setState(() {
//                                           formVisible = false;
//                                         });
//                                       },
//                                       icon: Icon(Icons.clear))
//                                 ],
//                               ),
//                               Container(
//                                 child: AnimatedSwitcher(
//                                   duration: Duration(milliseconds: 200),
//                                   child: SignUpform(
//                                       // listOfAllExistingUser:
//                                       //     listOfAllExistingUser,
//                                       ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                 : null),
//         AnimatedSwitcher(
//             duration: Duration(milliseconds: 200),
//             child: (phoneVisible)
//                 ? Container(
//                     color: Colors.black54,
//                     alignment: Alignment.center,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                   onPressed: () {},
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                             width * 0.06)),
//                                   ),
//                                   child: Text('OTP Verification',
//                                       textScaleFactor:
//                                           min(horizontalScale, verticalScale),
//                                       style: TextStyle(
//                                         color: Color.fromRGBO(97, 83, 211, 1),
//                                         fontSize: 18,
//                                       ))),
//                               SizedBox(
//                                 width: horizontalScale * 17,
//                               ),
//                               IconButton(
//                                   color: Colors.white,
//                                   onPressed: () {
//                                     setState(() {
//                                       phoneVisible = false;
//                                     });
//                                   },
//                                   icon: Icon(Icons.clear))
//                             ],
//                           ),
//                           Container(
//                             child: AnimatedSwitcher(
//                               duration: Duration(milliseconds: 200),
//                               child: PhoneAuthentication(),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 : null)
//       ],
//     ));
//   }
// }

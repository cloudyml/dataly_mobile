// import 'package:cloudyml_app2/globals.dart';
// import 'package:cloudyml_app2/screens/stores/login_store.dart';
// import 'package:cloudyml_app2/screens/stores/onboarding_username.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:cloudyml_app2/screens/stores/login_store.dart';
// import 'package:cloudyml_app2/theme.dart';
// import 'package:cloudyml_app2/widgets/loader_hud.dart';
// import 'package:cloudyml_app2/global_variable.dart' as globals;
// import '../authentication/firebase_auth.dart';
// import 'onboarding_phone.dart';

// class SignupPasswordPage extends StatefulWidget {
//   String email;
//   SignupPasswordPage({Key? key, required this.email}) : super(key: key);
//   @override
//   _SignupPasswordPageState createState() => _SignupPasswordPageState();
// }

// class _SignupPasswordPageState extends State<SignupPasswordPage> {
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confermationpasswordController =
//       TextEditingController();
//   late bool _passwordVisible;
//   late bool _confermationpasswordVisible;

//   bool loading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _passwordVisible = false;
//     _confermationpasswordVisible = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoginStore>(
//       builder: (_, loginStore, __) {
//         loginStore.isLoginLoading = false;
//         return Observer(
//           builder: (_) => LoaderHUD(
//             inAsyncCall: loginStore.isLoginLoading,
//             key: loginStore.loginScaffoldKey,
//             child: Scaffold(
//               backgroundColor: Colors.white,
//               key: loginStore.loginScaffoldKey,
//               body: SafeArea(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.90,
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 20),
//                                 child: Stack(
//                                   children: <Widget>[
//                                     // Center(
//                                     //   child: Container(
//                                     //     height: 140,
//                                     //     constraints:
//                                     //         const BoxConstraints(maxWidth: 500),
//                                     //     margin: const EdgeInsets.only(top: 100),
//                                     //     decoration: const BoxDecoration(
//                                     //         color: Color(0xFFE1E0F5),
//                                     //         borderRadius: BorderRadius.all(
//                                     //             Radius.circular(30))),
//                                     //   ),
//                                     // ),
//                                     Center(
//                                       child: Container(
//                                           constraints: const BoxConstraints(
//                                               maxHeight: 240),
//                                           margin: const EdgeInsets.symmetric(
//                                               horizontal: 8),
//                                           child: Lottie.asset(
//                                               'assets/onboarding_password.json')),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 40,
//                               ),
//                               Container(
//                                   constraints:
//                                       const BoxConstraints(maxWidth: 500),
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                   child: RichText(
//                                     textAlign: TextAlign.center,
//                                     text: TextSpan(children: <TextSpan>[
//                                       TextSpan(
//                                           text: 'Choosing a hard-to-guess,',
//                                           style: TextStyle(
//                                               color: MyColors.primaryColor)),
//                                       TextSpan(
//                                           text: ' but easy-to-remember\n',
//                                           style: TextStyle(
//                                               color: MyColors.primaryColor,
//                                               fontWeight: FontWeight.bold)),
//                                       TextSpan(
//                                           text: ' password is important!',
//                                           style: TextStyle(
//                                               color: MyColors.primaryColor)),
//                                     ]),
//                                   )),
//                               SizedBox(
//                                 height: 40,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.9,
//                                 child: TextFormField(
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Enter the Password';
//                                     } else if (!RegExp(
//                                             r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
//                                         .hasMatch(value)) {
//                                       return 'Password must have atleast one Uppercase, one Lowercase, one special character, and one numeric value';
//                                     }

//                                     if (value.toString().length < 6) {
//                                       return "length of password cannot be less than 6";
//                                     }
//                                     return null;
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   controller: passwordController,
//                                   obscureText:
//                                       !_passwordVisible, //This will obscure text dynamically
//                                   decoration: InputDecoration(
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(14.0),
//                                       borderSide: BorderSide(
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         width: 1,
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ), //<-- SEE HERE
//                                     ),
//                                     iconColor: Color.fromRGBO(120, 96, 220, 1),
//                                     hoverColor: Color.fromRGBO(120, 96, 220, 1),
//                                     focusColor: Color.fromRGBO(120, 96, 220, 1),
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(14))),
//                                     labelText: 'Password',
//                                     hintText: 'Enter your password',
//                                     labelStyle: TextStyle(
//                                         color: Color.fromRGBO(120, 96, 220, 1)),
//                                     // Here is key idea
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         // Based on passwordVisible state choose the icon
//                                         _passwordVisible
//                                             ? Icons.visibility
//                                             : Icons.visibility_off,
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ),
//                                       onPressed: () {
//                                         // Update the state i.e. toogle the state of passwordVisible variable
//                                         setState(() {
//                                           _passwordVisible = !_passwordVisible;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.9,
//                                 child: TextFormField(
//                                   validator: (value) {
//                                     if (value.toString().length < 6) {
//                                       return "length of password cannot be less than 6";
//                                     }
//                                     return null;
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   controller: confermationpasswordController,
//                                   obscureText:
//                                       !_confermationpasswordVisible, //This will obscure text dynamically
//                                   decoration: InputDecoration(
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(14.0),
//                                       borderSide: BorderSide(
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         width: 1,
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ), //<-- SEE HERE
//                                     ),
//                                     iconColor: Color.fromRGBO(120, 96, 220, 1),
//                                     hoverColor: Color.fromRGBO(120, 96, 220, 1),
//                                     focusColor: Color.fromRGBO(120, 96, 220, 1),
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(14))),
//                                     labelText: 'Confirm Password',
//                                     hintText: 'Enter your password',
//                                     labelStyle: TextStyle(
//                                         color: Color.fromRGBO(120, 96, 220, 1)),
//                                     // Here is key idea
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         // Based on passwordVisible state choose the icon
//                                         _confermationpasswordVisible
//                                             ? Icons.visibility
//                                             : Icons.visibility_off,
//                                         color: Color.fromRGBO(120, 96, 220, 1),
//                                       ),
//                                       onPressed: () {
//                                         // Update the state i.e. toogle the state of passwordVisible variable
//                                         setState(() {
//                                           _confermationpasswordVisible =
//                                               !_confermationpasswordVisible;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 0,
//                           child: Column(
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () async {
//                                   await password(
//                                       context,
//                                       passwordController.text.toString(),
//                                       confermationpasswordController.text
//                                           .toString(),
//                                       widget.email);
//                                   // loginStore.password(
//                                   //     context,
//                                   //     passwordController.text.toString(),
//                                   //     confermationpasswordController.text
//                                   //         .toString(),
//                                   //     widget.email);
//                                   // var result;
//                                   // print("jkjkjkjjk");
//                                   // if (passwordController.text.isNotEmpty &&
//                                   //     confermationpasswordController
//                                   //         .text.isNotEmpty) {
//                                   //   if (passwordController.text.toString() ==
//                                   //       confermationpasswordController.text
//                                   //           .toString()) {
//                                   //     loginStore.isLoginLoading = true;
//                                   //     globals.email = widget.email.toString();
//                                   //     try {
//                                   //       result = await createAccount(
//                                   //           widget.email,
//                                   //           passwordController.text.toString(),
//                                   //           "",
//                                   //           context);
//                                   //     } catch (e) {
//                                   //       setState(() {
//                                   //         loginStore.isLoginLoading = false;
//                                   //       });
//                                   //       print("catch");
//                                   //       print(e);
//                                   //     }
//                                   //   } else {
//                                   //     setState(() {
//                                   //         loginStore.isLoginLoading = false;
//                                   //       });
//                                   //     print("wrong confirm password ");

//                                   //     SnackBar(
//                                   //         content:
//                                   //             Text('wrong confirm password'));
//                                   //   }

//                                   //   if (result != null) {

//                                   //     Navigator.pushReplacement(
//                                   //       context,
//                                   //       MaterialPageRoute(
//                                   //         builder: (context) =>
//                                   //             LoginUsernamePage(),
//                                   //       ),
//                                   //     );
//                                   //   } else {
//                                   //     ScaffoldMessenger.of(context)
//                                   //         .showSnackBar(
//                                   //       const SnackBar(
//                                   //         content: Text('something went wrong'),
//                                   //       ),
//                                   //     );
//                                   //   }
//                                   // } else {
//                                   //   showToast('password does not match');
//                                   // }
//                                 },
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                   constraints:
//                                       const BoxConstraints(maxWidth: 500),
//                                   alignment: Alignment.center,
//                                   decoration: const BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(14)),
//                                       gradient: LinearGradient(
//                                           begin: Alignment.centerLeft,
//                                           end: Alignment.centerRight,
//                                           colors: [
//                                             // Color(0xFF8A2387),
//                                             Color.fromRGBO(120, 96, 220, 1),
//                                             Color.fromRGBO(120, 96, 220, 1),
//                                             Color.fromARGB(255, 88, 52, 246),
//                                           ])),
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 8),
//                                   child: loading
//                                       ? Padding(
//                                           padding: const EdgeInsets.all(6.0),
//                                           child: Container(
//                                               height: 20,
//                                               width: 20,
//                                               child: Center(
//                                                   child:
//                                                       CircularProgressIndicator(
//                                                           color:
//                                                               Colors.white))),
//                                         )
//                                       : Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       12, 0, 0, 0),
//                                               child: Text(
//                                                 'Next',
//                                                 style: TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 255, 255, 255),
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     const BorderRadius.all(
//                                                         Radius.circular(20)),
//                                                 color:
//                                                     MyColors.primaryColorLight,
//                                               ),
//                                               child: Icon(
//                                                 Icons.arrow_forward_ios,
//                                                 color: Colors.white,
//                                                 size: 16,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                 ),
//                               ),
//                               // SizedBox(
//                               //   height: 10,
//                               // ),
//                               // Container(
//                               //   margin: const EdgeInsets.symmetric(
//                               //       horizontal: 20, vertical: 10),
//                               //   constraints:
//                               //       const BoxConstraints(maxWidth: 500),
//                               //   child: RaisedButton(
//                               //     onPressed: () {
//                               //       if (phoneController.text.isNotEmpty) {
//                               //         loginStore.getCodeWithPhoneNumber(context,
//                               //             "+91${phoneController.text.toString()}");
//                               //       } else {
//                               //         loginStore.loginScaffoldKey.currentState
//                               //             ?.showSnackBar(SnackBar(
//                               //           behavior: SnackBarBehavior.floating,
//                               //           backgroundColor: Colors.red,
//                               //           content: Text(
//                               //             'Please enter a phone number',
//                               //             style: TextStyle(color: Colors.white),
//                               //           ),
//                               //         ));
//                               //       }
//                               //     },
//                               //     color: MyColors.primaryColor,
//                               //     shape: const RoundedRectangleBorder(
//                               //         borderRadius: BorderRadius.all(
//                               //             Radius.circular(14))),
//                               //     child: Container(
//                               //       padding: const EdgeInsets.symmetric(
//                               //           vertical: 8, horizontal: 8),
//                               //       child: Row(
//                               //         mainAxisAlignment:
//                               //             MainAxisAlignment.spaceBetween,
//                               //         children: <Widget>[
//                               //           Text(
//                               //             'Next',
//                               //             style: TextStyle(color: Colors.white),
//                               //           ),
//                               //           Container(
//                               //             padding: const EdgeInsets.all(8),
//                               //             decoration: BoxDecoration(
//                               //               borderRadius:
//                               //                   const BorderRadius.all(
//                               //                       Radius.circular(20)),
//                               //               color: MyColors.primaryColorLight,
//                               //             ),
//                               //             child: Icon(
//                               //               Icons.arrow_forward_ios,
//                               //               color: Colors.white,
//                               //               size: 16,
//                               //             ),
//                               //           )
//                               //         ],
//                               //       ),
//                               //     ),
//                               //   ),
//                               // )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> password(BuildContext context, String password, String password2,
//       String email) async {
//     var result;
//     print("jkjkjkjjk");
//     if (password.isNotEmpty && password2.isNotEmpty) {
//       setState(() {
//         loading = true;
//       });
//       if (password.toString() == password2.toString()) {
//         // isLoginLoading = true;
//         globals.email = email.toString();
//         try {
//           result = await createAccount(
//               email, password.toString(), password2.toString(), context);
//           setState(() {
//             loading = false;
//           });
//         } catch (e) {
//           //  showToast(e.toString());
//           setState(() {
//             loading = false;
//           });
//           print("catch");
//           print(e);
//         }
//       } else {
//         setState(() {
//           loading = false;
//         });
//         print("wrong confirm password ");
//         showToast('wrong confirm password');
//         SnackBar(content: Text('wrong confirm password'));
//       }

//       if (result != null) {
//         setState(() {
//           loading = false;
//         });
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginUsernamePage(),
//           ),
//         );
//       } else {
//         setState(() {
//           loading = false;
//         });
//       }
//     } else {
//       setState(() {
//         loading = false;
//       });
//       showToast('password does not match');
//     }
//   }
// }

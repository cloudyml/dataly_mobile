import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/screens/onboarding_phone.dart';
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
import 'package:toast/toast.dart';
import '../../authentication/firebase_auth.dart';

class LoginUsernamePage extends StatefulWidget {
  const LoginUsernamePage({Key? key}) : super(key: key);
  @override
  _LoginUsernamePageState createState() => _LoginUsernamePageState();
}

class _LoginUsernamePageState extends State<LoginUsernamePage> {
  TextEditingController nameController = TextEditingController();

  bool loading = false;
  bool signin = false;

  @override
  void initState() {
    super.initState();
    loginnewuser();
  }

  void loginnewuser() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signInWithCredential(globals.credental);

      signin = true;
    } catch (e) {
      Toast.show(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        // setState(() {
        //   loginStore.isLoginLoading = false;
        // });
        return Scaffold(
          backgroundColor: Colors.white,
          key: loginStore.loginScaffoldKey,
          body: SafeArea(
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
                                // Center(
                                //   child: Container(
                                //     height: 240,
                                //     constraints:
                                //         const BoxConstraints(maxWidth: 500),
                                //     margin: const EdgeInsets.only(top: 100),
                                //     decoration: const BoxDecoration(
                                //         color: Color.fromRGBO(225, 224, 245, 1),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(30))),
                                //   ),
                                // ),
                                Center(
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      constraints:
                                          const BoxConstraints(maxHeight: 340),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Lottie.asset(
                                          'assets/usernameillustration.json')),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('CloudyML',
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800)))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: 'What should we call you?',
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                  TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                ]),
                              )),
                          Container(
                            height: 60,
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: CupertinoTextField(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              controller: nameController,
                              clearButtonMode: OverlayVisibilityMode.editing,
                              keyboardType: TextInputType.name,
                              maxLines: 1,
                              placeholder: 'Name',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              FirebaseAuth _auth = FirebaseAuth.instance;

                              if (signin == false) {
                                var logi = await _auth
                                    .signInWithCredential(globals.credental);
                                userprofile(
                                  linked: "true",
                                    name: nameController.text.toString(),
                                    image: '',
                                    mobilenumber: globals.phone,
                                    authType: 'phoneAuth',
                                    phoneVerified: true,
                                    email: globals.email);
                                print(logi.user?.email);
                                Toast.show("${logi.user!.email}");
                              } else {
                                userprofile(
                                  linked: "true",
                                    name: nameController.text.toString(),
                                    image: '',
                                    mobilenumber: globals.phone,
                                    authType: 'phoneAuth',
                                    phoneVerified: true,
                                    email: globals.email);
                              }

                              if (nameController.text.isNotEmpty) {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  globals.name = nameController.text.toString();
                                  var user = _auth.currentUser;
                                  if (user != null) {
                                    await FirebaseFirestore.instance
                                        .collection('Users_dataly')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "linked": "true",
                                    });
                                    var userDocs;
                                    try {
                                      userDocs = await FirebaseFirestore
                                          .instance
                                          .collection('Users_dataly')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();
                                    } catch (e) {
                                      if (userDocs.data() == null) {
                                        await FirebaseFirestore.instance
                                            .collection('Users_dataly')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "linked": "true",
                                        });
                                        // Toast.show('user data does not exist');

                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    }

                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    Toast.show('user does not exist');
                                    setState(() {
                                      loading = false;
                                    });
                                  }

                                  var value = await FirebaseAuth
                                      .instance.currentUser!.uid;
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('login', "true");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                  setState(() {
                                    loading = false;
                                  });
                                } catch (e) {
                                  Toast.show(e.toString());
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => HomePage(),
                                  //   ),
                                  // );
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                Toast.show('Please enter your name');
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

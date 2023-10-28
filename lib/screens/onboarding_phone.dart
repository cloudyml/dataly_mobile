import 'dart:convert';
import 'dart:math';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/pages/otp_page.dart';
import 'package:cloudyml_app2/screens/stores/login_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:cloudyml_app2/widgets/loader_hud.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../authentication/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  String? name;
  LoginPage({Key? key, this.name}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  late String actualCode;
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String phonenumber = '';

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Container(
      //       padding: const EdgeInsets.all(10),
      //       decoration: BoxDecoration(
      //         borderRadius: const BorderRadius.all(Radius.circular(20)),
      //         color: MyColors.primaryColorLight.withAlpha(20),
      //       ),
      //       child: Icon(
      //         Icons.arrow_back_ios,
      //         color: MyColors.primaryColor,
      //         size: 16,
      //       ),
      //     ),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   brightness: Brightness.light,
      // ),
      // key: loginStore.loginScaffoldKey,
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
                            Center(
                              child: Container(
                                height: 240,
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                margin: const EdgeInsets.only(top: 100),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFE1E0F5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                            Center(
                              child: Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 340),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Lottie.asset('assets/logingif.json')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Dataly',
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
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you ',
                                  style:
                                      TextStyle(color: MyColors.primaryColor)),
                              TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'on this mobile number',
                                  style:
                                      TextStyle(color: MyColors.primaryColor)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            print(phoneController.text);
                            phonenumber = number.phoneNumber.toString();
                            print("phone number: ${phonenumber}");
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: phoneController,
                          formatInput: false,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                            print(phoneController.text);
                          },
                        ),
                      ),

                      // Container(
                      //   height: 40,
                      //   constraints: const BoxConstraints(maxWidth: 500),
                      //   margin: const EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 10),
                      //   child: CupertinoTextField(
                      //     maxLength: 10,
                      //     padding:
                      //         const EdgeInsets.symmetric(horizontal: 16),
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: const BorderRadius.all(
                      //             Radius.circular(4))),
                      //     controller: phoneController,
                      //     clearButtonMode: OverlayVisibilityMode.editing,
                      //     keyboardType: TextInputType.phone,
                      //     maxLines: 1,
                      //     placeholder: '+91...',
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (phoneController.text.isNotEmpty) {
                            globals.phone = phoneController.text.toString();

                            if (phonenumber.toString().substring(0, 3) ==
                                "+91") {
                              if (phonenumber.toString().substring(0, 4) ==
                                  "+910") {
                                phoneController.text = phoneController.text
                                    .toString()
                                    .replaceFirst("0", "");

                                phonenumber =
                                    phonenumber.replaceRange(0, 4, '+91');

                                getCodeWithPhoneNumber(
                                    context, "${phonenumber}");
                              } else {
                                getCodeWithPhoneNumber(
                                    context, "${phonenumber}");
                              }
                            } else {
                              getCodeWithPhoneNumber(context, "${phonenumber}");
                            }
                          } else if (phoneController.text.isEmpty) {
                            Toast.show('Please enter a phone number');
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
                                          10, 0, 0, 0),
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
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            final Uri params = Uri(
                                scheme: 'mailto',
                                path: 'app.support@cloudyml.com',
                                query: 'subject=Query about App');
                            var mailurl = params.toString();
                            if (await canLaunch(mailurl)) {
                              await launch(mailurl);
                            } else {
                              throw 'Could not launch $mailurl';
                            }
                          },
                          child: Text(
                            'Need Help with Login?',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 19,
                                color: Colors.black),
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
  }

  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    setState(() {
      loading = true;
    });
    // if (phoneController.text.toString().substring(1, 4) == '+91') {
    //   if (phoneNumber[0] == '0') {
    //     phoneNumber = phoneNumber.replaceFirst("0", '');
    //     phoneController.text =
    //         phoneController.text.toString().replaceFirst("0", '');
    //   }
    // }

    List<dynamic> items = [];
    var docSnapshots;
    try {
      print("1");
      docSnapshots = await FirebaseFirestore.instance
          .collection('Users_dataly')
          .where('mobilenumber', isEqualTo: phoneController.text.toString())
          .get();
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .where('mobilenumber', isEqualTo: phoneController.text.toString())
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((f) => items.add(f.data()));
      });
      if (items.length == 0) {
        docSnapshots = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('mobilenumber',
                isEqualTo: int.parse(phoneController.text.toString()))
            .get();
        await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('mobilenumber',
                isEqualTo: int.parse(phoneController.text.toString()))
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) => items.add(f.data()));
        });
      }

      if (items.length == 0) {
        if (phonenumber.toString().substring(0, 3) == "+91") {
          docSnapshots = await FirebaseFirestore.instance
              .collection('Users_dataly')
              .where('mobilenumber',
                  isEqualTo: "+910" + phoneController.text.toString())
              .get();
          await FirebaseFirestore.instance
              .collection('Users_dataly')
              .where('mobilenumber',
                  isEqualTo: "+910" + phoneController.text.toString())
              .get()
              .then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((f) => items.add(f.data()));
          });
          if (items.length == 0) {
            docSnapshots = await FirebaseFirestore.instance
                .collection('Users_dataly')
                .where('mobilenumber',
                    isEqualTo: "0" + phoneController.text.toString())
                .get();
            await FirebaseFirestore.instance
                .collection('Users_dataly')
                .where('mobilenumber',
                    isEqualTo: "0" + phoneController.text.toString())
                .get()
                .then((QuerySnapshot snapshot) {
              snapshot.docs.forEach((f) => items.add(f.data()));
            });
          }
        }
      }

      print("2");

      print("1sdkfffffj${items}");

      if (items.length == 0) {
        print("3");
        docSnapshots = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('mobilenumber', isEqualTo: phoneNumber)
            .get();

        print("4");

        await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('mobilenumber', isEqualTo: phoneNumber)
            .get()
            .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) => items.add(f.data()));
        });
        print("wijowi");
      }

      // if (items.length == 0) {
      //   print("3");
      //   docSnapshots = await FirebaseFirestore.instance
      //       .collection('Users')
      //       .where('mobilenumber', isEqualTo: "0"+phoneNumber)
      //       .get();

      //   print("4");

      //   await FirebaseFirestore.instance
      //       .collection('Users')
      //       .where('mobilenumber', isEqualTo: "0"+phoneNumber)
      //       .get()
      //       .then((QuerySnapshot snapshot) {
      //     snapshot.docs.forEach((f) => items.add(f.data()));
      //   });
      // }

      if (items.length == 0) {
        print("llll");
        final docSnapshot = await FirebaseFirestore.instance
            .collection('UserData')
            .doc()
            .set({"phone": phoneNumber, "date": DateTime.now()});
      }

      print(items);

      Map data = items[0];
      globals.googleAuth = data.containsValue("googleAuth").toString();
      globals.phone = data.containsValue("phoneAuth").toString();
      globals.linked = data.containsKey("linked").toString();
      print("ddddddddddddddd");

      print(globals.googleAuth);
      print(globals.linked);
      print(globals.phone);
      print("dsdssssssssssssssssss");
      print("7");
      final userSnapshot = docSnapshots.docs.first;
      print("8");
      globals.phoneNumberexists = userSnapshot.exists.toString();
      print("llllllsfsui");
      print(userSnapshot.exists.toString());
      print("llllllsfsui");
      if (!userSnapshot.exists) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('UserData')
            .doc()
            .set({"phone": phoneNumber, "date": DateTime.now()});
      }
    } catch (e) {
      print(e);
      print("9");
    }
    print("10");
    if (true) {
      print("11");
      setState(() {
        loading = true;
      });
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential auth) async {
            await _auth.signInWithCredential(auth).then((dynamic value) {
              print("1");
              if (value != null && value.user != null) {
                setState(() {
                  loading = false;
                  print("2");
                });
                print('Authentication successful');
              } else {
                setState(() {
                  loading = false;
                });
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(
                    'Invalid code/invalid authentication',
                    style: TextStyle(color: Colors.white),
                  ),
                );
                print("3");
              }
            }).catchError((error) {
              setState(() {
                loading = false;
              });

              Toast.show(error);
            });
          },
          verificationFailed: (dynamic authException) {
            Toast.show('Error message: ' + authException.message);
            print('Error message: ' + authException.message);
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
                style: TextStyle(color: Colors.white),
              ),
            );
            setState(() {
              loading = false;
            });
          },
          codeSent: (String verificationId, int? forceResendingToken) async {
            setState(() {
              loading = false;
            });
            actualCode = verificationId;
            globals.actualCode = verificationId;
            globals.phone = phoneNumber;
            print(
                "tttttttttttttttttttttttttttttttttttttttttttttttttttttttt ${phoneNumber}");

            setState(() {
              loading = false;
            });
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => OtpPage('')));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            actualCode = verificationId;
            globals.actualCode = verificationId;
          });
    }
  }

  // Future<void> onAuthenticationSuccessful(
  //     BuildContext context, dynamic result) async {
  //   // firebaseUser = result.user;

  //   var user = FirebaseAuth.instance.currentUser;
  //   if (globals.name != "") {
  //     if (user != null) {
  //       setState(() {
  //         loading = false;
  //       });
  //       DocumentSnapshot userDocs = await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get();
  //       if (userDocs.data() == null) {
  //         userprofile(
  //             name: globals.name,
  //             image: '',
  //             mobilenumber: globals.phone,
  //             authType: 'phoneAuth',
  //             phoneVerified: true,
  //             email: globals.email);
  //       }
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       Toast.show\('user does not exist');
  //     }
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  //   setState(() {
  //     loading = false;
  //   });

  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => HomePage()),
  //       (Route<dynamic> route) => false);
  // }
}

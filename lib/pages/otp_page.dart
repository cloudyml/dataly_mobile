import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/user_details.dart';
import 'package:cloudyml_app2/pages/survay_page.dart';
import 'package:cloudyml_app2/screens/onboarding_email.dart';
import 'package:cloudyml_app2/screens/stores/login_store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:cloudyml_app2/widgets/loader_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:showcaseview/showcaseview.dart';
import 'package:toast/toast.dart';
import '../catalogue_screen.dart';
import 'onboarding_google_auth.dart';

class OtpPage extends StatefulWidget {
  String fromemailpage;
  OtpPage(this.fromemailpage, {Key? key}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  late String actualCode;

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isOtpLoading,
            key: loginStore.otpScaffoldKey,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: widget.fromemailpage == 'fromemailpage'
                    ? Container()
                    : IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
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
                // brightness: Brightness.light,
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                        'Enter 6 digits verification code sent to your number',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500))),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      otpNumberWidget(0),
                                      otpNumberWidget(1),
                                      otpNumberWidget(2),
                                      otpNumberWidget(3),
                                      otpNumberWidget(4),
                                      otpNumberWidget(5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   constraints: const BoxConstraints(maxWidth: 500),
                          //   child: RaisedButton(
                          //     onPressed: () {
                          //       loginStore.validateOtpAndLogin(context, text);
                          //     },
                          //     color: MyColors.primaryColor,
                          //     shape: const RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(14))),
                          //     child: Container(
                          //       padding: const EdgeInsets.symmetric(
                          //           vertical: 8, horizontal: 8),
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text(
                          //             'Confirm',
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //           Container(
                          //             padding: const EdgeInsets.all(8),
                          //             decoration: BoxDecoration(
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(20)),
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
                          // ),
                          GestureDetector(
                            onTap: () async {
                              await validateOtpAndLogin(context, text);
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
                                            'Confirm',
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
                          NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor: MyColors.primaryColorLight,
                            rightIcon: Icon(
                              Icons.backspace,
                              color: MyColors.primaryColorLight,
                            ),
                            rightButtonFn: () {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            },
                          )
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

  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    var result;
    var output;
    actualCode = globals.actualCode;
    try {
      setState(() {
        loading = true;
      });
      final AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: actualCode, smsCode: smsCode);
      globals.credental = _authCredential;
      onAuthenticationSuccessful(context, output, _authCredential);
    } on FirebaseException catch (e) {
      print(e.toString());
      Toast.show(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  checkauthdevice(navigateto) async {
    String deviceIdentifier = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      try {
        final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        deviceIdentifier = webInfo.vendor! +
            webInfo.userAgent! +
            webInfo.hardwareConcurrency.toString();
        print("web: ${deviceIdentifier}");
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (Platform.isAndroid) {
        try {
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceIdentifier = androidInfo.id;
          print("android: ${deviceIdentifier}");
        } catch (e) {
          print(e.toString());
        }
      } else if (Platform.isIOS) {
        try {
          final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceIdentifier = iosInfo.identifierForVendor!;
          print("ios: ${deviceIdentifier}");
        } catch (e) {
          print(e.toString());
        }
      } else if (Platform.isLinux) {
        try {
          final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
          deviceIdentifier = linuxInfo.machineId!;
          print("linux: ${deviceIdentifier}");
        } catch (e) {
          print(e.toString());
        }
      }
    }
    int lengthofdeviceid = 0;
    bool lethimlogin = false;
    try {
      await FirebaseFirestore.instance
          .collection("Devices")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        var data = value.data()!['deviceid'];
        lengthofdeviceid = data.length;
        if (lengthofdeviceid < 2) {
          FirebaseFirestore.instance
              .collection("Devices")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "deviceid": FieldValue.arrayUnion([deviceIdentifier]),
            "lastlogin": DateTime.now().toString(),
            "lastloginfrom": deviceIdentifier,
            "uid": FirebaseAuth.instance.currentUser!.uid
          });
          lethimlogin = true;
        } else if (lengthofdeviceid == 2) {
          for (var i in data) {
            if (i == deviceIdentifier) {
              lethimlogin = true;
            }
          }
        }
        if (lethimlogin == false) {
          Toast.show("You are not allowed to login from this device");
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
        }
        if (lethimlogin == true) {
          Toast.show("Login Successful");
          //navigate to home page or catelogue page
          if (navigateto == "catelogue") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => CatelogueScreen(),
                ),
                (Route<dynamic> route) => false);
          } else if (navigateto == "showcase") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => ShowCaseWidget(
                          autoPlay: true,
                          onStart: (index, key) {},
                          onComplete: (index, key) {
                            //  log('onComplete: $index, $key');
                            if (index == 8) {
                              SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle.light.copyWith(
                                  statusBarIconBrightness: Brightness.dark,
                                  statusBarColor: Colors.white,
                                ),
                              );
                            }
                          },
                          blurValue: 1,
                          autoPlayDelay: const Duration(seconds: 3),
                          builder: Builder(builder: (context) => HomePage()),
                        )),
                (Route<dynamic> route) => false);
          } else if (navigateto == "googleauth") {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GoogleAuthLogin()));
          } else if (navigateto == "signinscreen") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LoginEmailPage(user: "signin")));
          } else if (navigateto == "signupscreen") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LoginEmailPage(user: "signup")));
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
                (Route<dynamic> route) => false);
          }
        }
      });
    } catch (e) {
      await FirebaseFirestore.instance
          .collection("Devices")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "deviceid": [deviceIdentifier],
        "lastlogin": DateTime.now().toString(),
        "lastloginfrom": deviceIdentifier,
        "uid": FirebaseAuth.instance.currentUser!.uid
      });
      //navigate to home page or catelogue page
      if (navigateto == "catelogue") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => CatelogueScreen(),
            ),
            (Route<dynamic> route) => false);
      } else if (navigateto == "showcase") {
        Toast.show("Login Successful");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => ShowCaseWidget(
                      autoPlay: true,
                      onStart: (index, key) {},
                      onComplete: (index, key) {
                        //  log('onComplete: $index, $key');
                        if (index == 8) {
                          SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle.light.copyWith(
                              statusBarIconBrightness: Brightness.dark,
                              statusBarColor: Colors.white,
                            ),
                          );
                        }
                      },
                      blurValue: 1,
                      autoPlayDelay: const Duration(seconds: 3),
                      builder: Builder(builder: (context) => HomePage()),
                    )),
            (Route<dynamic> route) => false);
      } else if (navigateto == "googleauth") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => GoogleAuthLogin()));
      } else if (navigateto == "signinscreen") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LoginEmailPage(user: "signin")));
      } else if (navigateto == "signupscreen") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LoginEmailPage(user: "signup")));
      } else {
        Toast.show("Login Successful");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
            (Route<dynamic> route) => false);
      }
    }
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, dynamic result, dynamic crediantial) async {
    try {
      print("ttyyifsjoifd");
      print("lllll:${globals.googleAuth}");
      print("oooo:${globals.phoneNumberexists}");
      print("pppp:${globals.linked}");
      if (globals.googleAuth != 'true') {
        if (globals.phoneNumberexists == "true") {
          if (globals.linked == "true") {
            print("here 1");
            try {
              User? user = (await _auth.signInWithCredential(crediantial)).user;
              if (user != null) {
                // when user login
                print(
                    "Login Successful========================================================");

                print(user);
                print(
                    "Login Successful========================================================");
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('login', "true");
                print('hhjjjjjhhghggghhgh');
                print(globals.moneyrefcode);
                if (globals.moneyrefcode != '') {
                  courseId = globals.moneyrefcode.split('-')[1];
                  try {
                    FirebaseFirestore.instance
                        .collection("Users_dataly")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get()
                        .then((value) {
                      if (value.data()!['sendermoneyrefcode'] !=
                          globals.moneyrefcode) {
                        FirebaseFirestore.instance
                            .collection("Users_dataly")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          "sendermoneyrefcode": globals.moneyrefcode,
                          "sendermoneyrefuid":
                              globals.moneyrefcode.split('-')[2],
                          "senderrefvalidfrom": DateTime.now()
                        });
                      }
                    });
                  } catch (e) {
                    print("poooiiieirj${e.toString()}");
                  }
                  checkauthdevice("catelogue");
                } else {
                  final data = await FirebaseFirestore.instance
                      .collection("Users_dataly")
                      .doc(FirebaseAuth.instance.currentUser!.uid);
                  data.get().then((value) {
                    if (value.data()?.containsKey('Choices') == true) {
                      print('The Val :: True');
                      checkauthdevice("showcase");
                    } else {
                      print('The Val :: False');
                      checkauthdevice("catelogue");
                    }
                  });
                }
              } else {
                Toast.show("Login Failed");
                print("Login Failed");
              }
            } catch (e) {
              Toast.show("wrong otp: ${e.toString()}");
            }
          } else if (globals.googleAuth == 'true') {
            checkauthdevice("googleauth");
          } else {
            checkauthdevice("signinscreen");
          }
        } else {
          print("here 2");
          try {
            FirebaseAuth _auth = FirebaseAuth.instance;
            await _auth.signInWithCredential(globals.credental);
            checkauthdevice("signupscreen");
          } catch (e) {
            Toast.show("${e.toString()}");
          }
        }
      } else {
        if (globals.linked == 'true') {
          print(
              "dsdsiudiushdfiuhsdiufhsiudhfisdfiusidfiusdi${globals.moneyrefcode}");
          if (globals.moneyrefcode != '') {
            courseId = globals.moneyrefcode.split('-')[1];
            checkauthdevice("catelogue");
          } else {
            if (globals.moneyrefcode != '') {
              courseId = globals.moneyrefcode.split('-')[1];
              try {
                await FirebaseFirestore.instance
                    .collection("Users_dataly")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) async {
                  try {
                    print(
                        "sdsdfsoijojwjjgsdsdsdrgjei ${value.data()!['sendermoneyrefuid']}");
                    if (value.data()!['sendermoneyrefuid'] !=
                        globals.moneyrefcode.split('-')[2]) {
                      await FirebaseFirestore.instance
                          .collection("Users_dataly")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "sendermoneyrefcode": globals.moneyrefcode,
                        "sendermoneyrefuid": globals.moneyrefcode.split('-')[2],
                        "senderrefvalidfrom": DateTime.now()
                      });
                    }
                  } catch (e) {
                    print("tyuiiiiii${e.toString()}");
                  }
                });
              } catch (e) {
                print("poooiiieirj${e.toString()}");
              }
              checkauthdevice("catelogue");
            } else {
              final data = await FirebaseFirestore.instance
                  .collection("Users_dataly")
                  .doc(FirebaseAuth.instance.currentUser!.uid);
              data.get().then((value) {
                if (value.data()?.containsKey('Choices') == true) {
                  print('The Val :: True');
                  checkauthdevice("showcase");
                } else {
                  print('The Val :: False');
                  checkauthdevice("catelogue");
                }
              });
            }
          }
        } else {
          checkauthdevice("googleauth");
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      Toast.show(e.toString());
    }
  }
}

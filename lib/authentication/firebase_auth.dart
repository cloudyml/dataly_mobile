import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:showcaseview/showcaseview.dart';
import 'package:toast/toast.dart';
import '../catalogue_screen.dart';
import '../pages/otp_page.dart';
import '../screens/onboarding_phone.dart';
import 'package:device_info_plus/device_info_plus.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? gname;
String? gemail;
String? gimageUrl;

class Authenticate extends StatefulWidget {
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  void initState() {
    super.initState();
  }

  var moneyreferrerCode = '';

  String? action;
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    print("oooooppppppp");
    print(globals.action);
    print(globals.signoutvalue);
    print("oooooppppppp");
    if (globals.action == "true") {
      if (user != null) {
        // when user is already logined
        print('ddddddffeee');
        print(globals.moneyrefcode);
        setState(() {
          globals.moneyrefcode;
        });
        if (globals.moneyrefcode != '') {
          // code for updating the sendermoneyrefcode if it is diffrent on the firebase
          FirebaseFirestore.instance
              .collection("Users_dataly")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            if (value.data()!['sendermoneyrefcode'] != globals.moneyrefcode) {
              FirebaseFirestore.instance
                  .collection("Users_dataly")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                "sendermoneyrefcode": globals.moneyrefcode,
                "sendermoneyrefuid": globals.moneyrefcode.split('-')[2],
                "senderrefvalidfrom": DateTime.now()
              });
            }
          });
          courseId = globals.moneyrefcode.split('-')[1];
          return CatelogueScreen();
        } else {
          // if (globals.survay == "done") {
          print("sidfjsodfijsodjfoisijdfo");
          if (globals.moneyrefcode != '') {
            return CatelogueScreen();
          } else {
            // return CatelogueScreen();
            return ShowCaseWidget(
              autoPlay: true,
              onStart: (index, key) {},
              onComplete: (index, key) {
                //  log('onComplete: $index, $key');
                if (index == 7) {
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
            );

            //HomePage();
          }
          // } else {
          //   return CheckboxPage();
          // }
        }
      } else {
        return LoginPage();
      }
    } else {
      return LoginPage();
    }
  }
}

Future<User?> createAccount(
    String email, String password, String text, BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    passwordttt = password;
    await user!.linkWithCredential(globals.credental);
    if (user != null) {
      print("Account Created Successful");
      return user;
    } else {
      print("Account Creation Failed");
      return user;
    }
  } catch (e) {
    print(e);
    Toast.show(e.toString());

    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    passwordttt = password;
    if (user != null) {
      print("Login Successful");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  globals.phone = "";
  globals.email = "";
  globals.name = "";
  globals.phoneNumberexists = 'false';
  globals.linked = 'false';
  dynamic credental;
  globals.moneyrefcode = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("login");
  print(prefs.get(_auth.currentUser!.uid));
  print("222222222222");
  await prefs.setString('signout', 'signout');
  print("33333333333");
  print(prefs.get('signout'));
  print("444444444444");
  print("signoutvalue");
  await removedeviceid(context);
}

removedeviceid(context) async {
  String deviceIdentifier = '';
  print("sdgsdgd3");
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    print("sdgsdgd4");
    try {
      final WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      deviceIdentifier = webInfo.vendor! +
          webInfo.userAgent! +
          webInfo.hardwareConcurrency.toString();
      print("web: ${deviceIdentifier}");
      print("sdgsdgd5");
    } catch (e) {
      print("sdgsdgd6");
      print(e.toString());
    }
  } else {
    print("sdgsdgd7");
    if (Platform.isAndroid) {
      print("sdgsdgd8");
      try {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceIdentifier = androidInfo.id;
        print("android: ${deviceIdentifier}");
        print("sdgsdgd9");
      } catch (e) {
        print("sdgsdgd10");
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
  List lis = [];
  //remove the id from the Device collection in user doc
  try {
    await FirebaseFirestore.instance
        .collection("Devices")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var toremove;
      for (var i in value['deviceid']) {
        print('wiejfowjoefjwo $i');
        if (i == deviceIdentifier) {
          toremove = i;
          print('toremove1 $toremove');
        }
      }
      print('toremove2 $toremove');

      for (var i in value['deviceid']) {
        print('toremove2 $i');
        if (i == deviceIdentifier) {
        } else {
          lis.add(i);
        }
      }
      print('toremove3 ${value['deviceid']}');
      print('toremove30 $lis');

      print('toremove4 $toremove');
    });
    print('toremove5 $lis');
    if (lis.length != 0) {
      try {
        await FirebaseFirestore.instance
            .collection("Devices")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"deviceid": lis, "lastlogoutfrom": deviceIdentifier});
      } catch (e) {
        print('woefjwj$e');
      }
    }
    try {
      try {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        print("sdgsdgd1");

        provider.googlelogout(context);
        print("sdgsdgd2");
      } catch (e) {
        await _auth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print("error $e");
      try {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        print("sdgsdgd1");

        provider.googlelogout(context);
        print("sdgsdgd2");
      } catch (e) {
        await _auth.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  } catch (e) {
    print("ygyggg: ${e.toString()}");
    try {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      print("sdgsdgd1");

      provider.googlelogout(context);
      print("sdgsdgd2");
    } catch (e) {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}

// void updateGroupData(
//   List<String?> paidCourseNames,
//   String? userId,
//   String? userName,
// ) async {
//   for (var courseId in paidCourseNames) {
//     await FirebaseFirestore.instance
//         .collection('courses')
//         .where('id', isEqualTo: courseId)
//         .get()
//         .then(
//       (value) {
//         Map<String, dynamic> groupData = {
//           "name": value.docs[0].data()['name'],
//           "icon": value.docs[0].data()["image_url"],
//           "mentors": value.docs[0].data()["mentors"],
//           value.docs[0].data()["mentors"][0]: 0,
//           value.docs[0].data()["mentors"][1]: 0,
//           value.docs[0].data()["mentors"][2]: 0,
//           value.docs[0].data()["mentors"][3]: 0,
//           'studentCount': 0,
//           "student_id": userId,
//           "student_name": userName,
//         };
//         print(groupData);
//         FirebaseFirestore.instance.collection('groups').add(groupData);
//       },
//     );
//   }
// }

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(
    BuildContext context,
  ) async {
    var otpverified = true;
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      print('user...');
      print(_user);
      final googleAuth = await googleUser.authentication;
      print("this is goooogle-- $googleAuth");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(googleAuth.idToken);
      print("Printing Access Token.........");
      print(googleAuth.accessToken);
      print("Printed");
      // await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);

      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Printed");
      try {
        await FirebaseAuth.instance.currentUser!
            .linkWithCredential(globals.credental);
        await FirebaseFirestore.instance
            .collection('Users_dataly')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "linked": "true",
          "mobilenumber": globals.phone,
          "authType": "phoneAuth",
        });
        print("Printed");
        final prefs = await SharedPreferences.getInstance();
        print("Printed");
        await prefs.setString('login', "true");
        print("Printed");

        print("Printed");
      } catch (e) {
        print("Printed jkkjkjk");
        otpverified = false;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OtpPage("fromemailpage"),
          ),
        );
        print("Printed");
        print(e.toString());
        Toast.show(
          e.toString(),
        );
      }

      // Toast.show('Please wait while we are fetching info...');

      //This is check if User already exist in Database in User Collection
      //If User does not exist create user and groups collection
      if (otpverified) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1234,
              channelKey: 'image',
              title: 'Welcome to CloudyML',
              body: 'It\'s great to have you on CloudyML',
              bigPicture: 'asset://assets/HomeImage.png',
              largeIcon: 'asset://assets/logo2.png',
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true),
        );
        await Provider.of<UserProvider>(context, listen: false)
            .addToNotificationP(
          title: 'Welcome to CloudyML',
          body: 'It\'s great to have you on CloudyML',
          notifyImage:
              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/images%2Fhomeimage.png?alt=media&token=2f4abc37-413f-49c3-b43d-03c02696567e',
          NDate: DateFormat('dd-MM-yyyy | h:mm a').format(DateTime.now()),
        );
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              duration: Duration(milliseconds: 20),
              curve: Curves.bounceInOut,
              type: PageTransitionType.rightToLeftWithFade,
              child:

                  //HomePage()
                  ShowCaseWidget(
                autoPlay: true,
                onStart: (index, key) {},
                onComplete: (index, key) {
                  //  log('onComplete: $index, $key');
                  if (index == 7) {
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
          (route) => false,
        );
      }
      return true;
    } catch (e) {
      print(e.toString());
      Toast.show(e.toString());
      return false;
    }
  }

  Future googlelogout(context) async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e);
    }
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            type: PageTransitionType.rightToLeftWithFade,
            child: LoginPage()),
        (route) => false);
  }
}

void userprofile({
  required String name,
  var mobilenumber,
  var email,
  var image,
  required String authType,
  required bool phoneVerified,
  List<String?>? listOfCourses,
  required String linked,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "name": name,
      "email": email,
    });
  } catch (e) {
    print("updatediiiiiiiiiiii: ${e}");
    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "name": name,
      "linked": linked,
      "mobilenumber": mobilenumber,
      "email": email,
      "paidCourseNames": listOfCourses,
      "authType": authType,
      "phoneVerified": phoneVerified,
      "courseBuyID": "0", //course id will be displayed
      "paid": "False",
      "id": _auth.currentUser!.uid,
      "password": "is it needed",
      "role": "student",
      "couponCodeDetails": {},
      "payInPartsDetails": {},
      "image": image,
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now())
    });
  }
}

void googleloginuser({
  required String name,
  var mobilenumber,
  var email,
  var image,
  required String authType,
  required bool phoneVerified,
  List<String?>? listOfCourses,
  required String linked,
}) async {
  await FirebaseFirestore.instance
      .collection("Users_dataly")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "name": name,
    "mobilenumber": mobilenumber,
    "email": email,
    "linked": "true",
    "authType": "authType",
    "id": _auth.currentUser!.uid,
  });
}

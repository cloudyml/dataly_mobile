import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/authentication/onboardbg.dart';
import 'package:dataly_app/authentication/onboardnew.dart';
import 'package:dataly_app/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/screens/onboarding_phone.dart';
import 'package:dataly_app/pages/otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import 'package:toast/toast.dart';
import '../../authentication/firebase_auth.dart';
import '../../homepage.dart';
import '../../pages/onboarding_signinpassword.dart';
import '../onboarding_email.dart';
import '../onboarding_signuppassword.dart';
import 'onboarding_username.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String actualCode;

  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  dynamic firebaseUser;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = await _auth.currentUser!;
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> email(BuildContext context, String email) async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      if (email != "" || email != null) {
        isLoginLoading = true;
        final docSnapshots = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('email', isEqualTo: "${email}")
            .get();
        try {
          if (docSnapshots.docs.first.exists) {
            print(docSnapshots.docs.first.exists);
            //    setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SigninPasswordPage(email: email),
              ),
            );
          } else {
            //  setState(() {
            //   loginStore.isLoginLoading = false;
            // });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
        } catch (e) {
          // setState(() {
          //   loginStore.isLoginLoading = false;
          // });
          if (e.toString() == "Bad state: No element") {
            // isLoginLoading = false;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginUsernamePage()));
          }
          ;
        }
      } else {
        // setState(() {
        //     loginStore.isLoginLoading = false;
        //   });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a email'),
          ),
        );
        //  setState(() {
        //       loginStore.isLoginLoading = false;
        //     });
      }
    } else {}
  }

  @action
  Future<void> password(BuildContext context, String password, String password2,
      String email) async {
    var result;
    print("jkjkjkjjk");
    if (password.isNotEmpty && password2.isNotEmpty) {
      if (password.toString() == password2.toString()) {
        // isLoginLoading = true;
        globals.email = email.toString();
        try {
          result = await createAccount(
              email, password.toString(), password2.toString(), context);
        } catch (e) {
          print("catch");
          print(e);
        }
      } else {
        print("wrong confirm password ");

        SnackBar(content: Text('wrong confirm password'));
      }

      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginUsernamePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('something went wrong'),
          ),
        );
      }
    } else {
      Toast.show('password does not match');
    }
  }

  @action
  Future<void> getCodeWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    isLoginLoading = true;

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) async {
          await _auth.signInWithCredential(auth).then((dynamic value) {
            if (value != null && value.user != null) {
              print('Authentication successful');
              onAuthenticationSuccessful(context, value);
            } else {
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  'Invalid code/invalid authentication',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }).catchError((error) {
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'Something has gone wrong, please try later',
                style: TextStyle(color: Colors.white),
              ),
            );
          });
        },
        verificationFailed: (dynamic authException) {
          print('Error message: ' + authException.message);
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              'The phone number format is incorrect. Please enter your number in E.164 format. [+][country code][number]',
              style: TextStyle(color: Colors.white),
            ),
          );
          isLoginLoading = false;
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          actualCode = verificationId;
          isLoginLoading = false;
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => OtpPage('')));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode) async {
    var result;
    var output;
    try {
      isOtpLoading = true;
      final AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: actualCode, smsCode: smsCode);
      print("00000000000000000000000000000000000");
      result = await _auth.currentUser!.linkWithCredential(_authCredential);
      output = await _auth.signInWithCredential(_authCredential);
      isOtpLoading = false;
      print("4${result}");
      var value = await FirebaseAuth.instance.currentUser!.uid;
      print("5");
      final prefs = await SharedPreferences.getInstance();
      print("6");
      await prefs.setString('login', "true");
      print("7");
      // if (authResult != null && authResult.user != null) {
      //   print("8");
      //   print('Authentication successful');
      //   print("9");
      onAuthenticationSuccessful(context, output);
      // }
    } on FirebaseException catch (e) {
      if (e.code.toString() == "provider-already-linked") {
        var value = await FirebaseAuth.instance.currentUser!.uid;
        print("5");
        final prefs = await SharedPreferences.getInstance();
        print("6");
        await prefs.setString('login', "true");
        onAuthenticationSuccessful(context, output);
      }
      if (e.code.toString() == "credential-already-in-use") {
        var value = await FirebaseAuth.instance.currentUser!.uid;
        print("5");
        final prefs = await SharedPreferences.getInstance();
        print("6");
        await prefs.setString('login', "true");
        onAuthenticationSuccessful(context, output);
      }

      print("this is error kinga${e}");
      isLoginLoading = false;
    }
    isLoginLoading = false;
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, dynamic result) async {
    isLoginLoading = true;
    isOtpLoading = true;

    // firebaseUser = result.user;

    var user = FirebaseAuth.instance.currentUser;
    if (globals.name != "") {
      if (user != null) {
        DocumentSnapshot userDocs = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (userDocs.data() == null) {
          userprofile(
              linked: "true",
              name: globals.name,
              image: '',
              mobilenumber: globals.phone,
              authType: 'phoneAuth',
              phoneVerified: true,
              email: globals.email);
        }
      } else {
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            'Please enter your name',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
        (Route<dynamic> route) => false);

    isLoginLoading = false;
    isOtpLoading = false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()),
        (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}

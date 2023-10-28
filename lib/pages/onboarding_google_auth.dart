import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/firebase_auth.dart';
import '../globals.dart';
import '../theme.dart';

class GoogleAuthLogin extends StatefulWidget {
  GoogleAuthLogin({Key? key}) : super(key: key);

  @override
  State<GoogleAuthLogin> createState() => _GoogleAuthLoginState();
}

class _GoogleAuthLoginState extends State<GoogleAuthLogin> {
  bool? googleloading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: 65,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            constraints: const BoxConstraints(maxHeight: 640),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Lottie.asset('assets/googlelottie.json')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'CloudyML',
                    style: TextStyle(
                        color: MyColors.primaryColor,
                        fontSize: 27,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "CloudyML's Data Science Online Course is designed for all data science enthusiast who are looking for a step-by-step guide on how to become an expert in Data science",
                            style: TextStyle(color: MyColors.primaryColor)),
                      ],),
                    ),),
                     SizedBox(
                  height: 70,
                ),
              ],
            ),
            SizedBox(
                    height: 40,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 320,
                child: InkWell(
                  onTap: () async {
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
                      color: Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(
                          min(horizontalScale, verticalScale) * 8),
                      boxShadow: [
                       
                        BoxShadow(
                          color: HexColor('977EFF'),
                          blurRadius: 1.0, // soften the shadow
                          offset: Offset(
                            1, // Move to right 10  horizontally
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
                          : Center(
                            child: Row(
                                
                                children: [
                                  SizedBox(width: 50,),
                                  Center(
                                    child: SvgPicture.network(
                                      'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fgoogle.svg?alt=media&token=e8c0aa3a-a131-49a4-be09-8ebfe2990ea7',
                                    
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Center(
                                    child: Text(
                                      'Continue with Google',
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                          fontFamily: 'SemiBold',
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
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

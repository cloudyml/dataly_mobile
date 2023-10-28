import 'dart:math';

import 'package:cloudyml_app2/authentication/loginform.dart';
import 'package:cloudyml_app2/authentication/onboardbg.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/pages/PhoneName.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class newEnterName extends StatefulWidget {
  const newEnterName({Key? key}) : super(key: key);

  @override
  State<newEnterName> createState() => _newEnterNameState();
}

class _newEnterNameState extends State<newEnterName> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    return Scaffold(
      body: Stack(
        children: [
          Onboardbg(),
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: verticalScale * 76,
                  ),
                  Center(
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Flogo.png?alt=media&token=ceb73785-45e6-4100-b38e-6e56c5569a56',
                        height: verticalScale * 80,
                        width: horizontalScale * 238,
                      )),
                  SizedBox(
                    height: verticalScale * 50,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      textScaleFactor: min(horizontalScale, verticalScale),
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          children: [
                            TextSpan(text: "Learn "),
                            TextSpan(
                                text: 'data science \n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "and "),
                            TextSpan(
                                text: 'ML ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "on the go with \nour "),
                            TextSpan(
                                text: 'mobile app ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ])),
                  SizedBox(
                    height: verticalScale * 47.44,
                  ),
                  Container(
                    //color: Colors.black54,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            width * 0.06)),
                                  ),
                                  child: Text(
                                    'Enter Your Name',
                                    textScaleFactor:
                                    min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      color: HexColor('6153D3'),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: PhoneName(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  // SizedBox(
                  //   height: height*0.0705,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

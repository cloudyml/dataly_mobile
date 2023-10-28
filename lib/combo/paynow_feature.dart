import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/new_combo_course.dart';
import 'package:cloudyml_app2/combo/updated_combo_course.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Providers/UserProvider.dart';
import '../globals.dart';
import '../international_payment_screen.dart';
import '../my_Courses.dart';
import '../screens/flutter_flow/flutter_flow_util.dart';
import 'combo_course.dart';

class PayNowBottomSheetfeature extends StatefulWidget {
  String coursePrice;
  Map<String, dynamic> map;
  Map<dynamic, dynamic> usermap;
  bool isItComboCourse;
  String cID;
  BuildContext context;
  PayNowBottomSheetfeature(
      {Key? key,
      required this.coursePrice,
      required this.map,
      required this.usermap,
      required this.isItComboCourse,
      required this.cID,
      required this.context})
      : super(key: key);

  @override
  State<PayNowBottomSheetfeature> createState() =>
      _PayNowBottomSheetfeatureState();
}

class _PayNowBottomSheetfeatureState extends State<PayNowBottomSheetfeature> {
  List<CourseDetails> featuredCourse = [];

  Map userMap1 = Map<String, dynamic>();

  getuserdata() async {
    try {
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userMap1 = userDocs.data() as Map<String, dynamic>;
    } catch (e) {
      print("error $e");
    }
  }

  setFeaturedCourse(List<CourseDetails> course) {
    featuredCourse.clear();
    course.forEach((element) {
      print('element is $element ');
      if (element.courseDocumentId == widget.cID) {
        featuredCourse.add(element);
        // featuredCourse.add(element.courses);

        print('element ${featuredCourse[0].courses} ');
      }
    });
    print('function ');
  }

  void trialCourse() async {
    print(
        'this is name  : ${widget.usermap['name']} ${widget.cID} ${FirebaseAuth.instance.currentUser!.uid} "abc"');

    try {
      var url = Uri.parse(
          'https://us-central1-cloudyml-app.cloudfunctions.net/exceluser/trialAccess');
      final response = await http.post(url, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "GET, POST",
      }, body: {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "cid": featuredCourse[0].courseId,
        "uname": widget.usermap['name'],
        "cname": featuredCourse[0].courseName,
      });
      // print('this is body ${body.toString()}');

      print(response.statusCode);
    } catch (e) {
      print('this is api error ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getuserdata();
    print("usermap1==$userMap1");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    setFeaturedCourse(course);
    return BottomSheet(
      builder: (BuildContext context) {
        return Container(
          height: 32.sp,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 65.sp,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.sp)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: 200,
                        // ),
                        widget.usermap['paidCourseNames'] != null &&
                                widget.usermap['paidCourseNames']
                                    .contains(featuredCourse[0].courseId)
                            ? InkWell(
                                onTap: () {
                                  Get.to(() => NewComboCourse(
                                        courseName:
                                            featuredCourse[0].courseName,
                                        courses: featuredCourse[0].courses,
                                      ));
                                  // Navigator.pushReplacement(
                                  //   widget.context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => HomeScreen(),
                                  //   ),
                                  // );

                                  // GoRouter.of(context).pushNamed(
                                  //     'newcomboCourse',
                                  //     queryParams: {
                                  //       'courseName':
                                  //           featuredCourse[0].courseName,
                                  //       'id': "37",
                                  //     });
                                },
                                child: Center(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Continue Your Course',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Medium',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Colors.deepPurpleAccent[700],
                                          title: Center(
                                            child: Text(
                                              'Start Your ${featuredCourse[0].trialDays} Days Free Trial',
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          content: Container(
                                            height: Adaptive.h(50),
                                            width: Adaptive.w(100),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                featureCPopup(
                                                  Icons.video_file,
                                                  'Get Complete Access to videos and assignments',
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                featureCPopup(
                                                  Icons.mobile_screen_share,
                                                  'Watch tutorial videos from any module',
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                featureCPopup(
                                                  Icons.assistant,
                                                  'Connect with Teaching Assistant for Doubt Clearance',
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                featureCPopup(
                                                  Icons.mobile_friendly,
                                                  'Access videos and chat support over our Mobile App.',
                                                  horizontalScale,
                                                  verticalScale,
                                                ),
                                                SizedBox(
                                                  height: 15.sp,
                                                ),
                                                Container(
                                                    height: Adaptive.h(12),
                                                    width: Adaptive.h(100),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.sp),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.5.sp),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 25.sp,
                                                                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                  child: Image
                                                                      .network(
                                                                    featuredCourse[
                                                                            0]
                                                                        .courseImageUrl,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                child: Text(
                                                                    featuredCourse[
                                                                            0]
                                                                        .courseName,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15.sp)),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(height: 15.sp),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // print(
                                                        //     'idd ${widget.id} ${featuredCourse[0].courseName}');
                                                        // print('this is condition ${userMap['paidCourseNames'].contains(featuredCourse[int.parse(widget.id!)].courseId)}');
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        var paidcourse;
                                                        print(widget.usermap);

                                                        if (widget.usermap[
                                                                'paidCourseNames']
                                                            .contains(
                                                                featuredCourse[
                                                                        0]
                                                                    .courseId)) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'You have already enrolled in this course.');
                                                        } else if (widget
                                                                        .usermap[
                                                                    'trialCourseList'] !=
                                                                null &&
                                                            widget.usermap[
                                                                    'trialCourseList']
                                                                .contains(
                                                                    featuredCourse[
                                                                            0]
                                                                        .courseId)) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'You have already tried this course... Please purchase the course.');
                                                        } else {
                                                          setState(() {
                                                            trialCourse();

                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Congrats!! Course is now available in enrolled courses for ${featuredCourse[0].trialDays} days...');

                                                            ComboCourse.comboId
                                                                    .value =
                                                                featuredCourse[
                                                                        0]
                                                                    .courseId;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Please wait.We are redirectng You To My Courses...');
                                                            Navigator.pop(
                                                                context);
                                                            Timer(
                                                                Duration(
                                                                    seconds: 6),
                                                                () => {
                                                                      Get.to(() =>
                                                                          NewComboCourse(
                                                                            courseName:
                                                                                featuredCourse[0].courseName,
                                                                            courses:
                                                                                featuredCourse[0].courses,
                                                                          )),
                                                                      // Navigator
                                                                      //     .pushReplacement(
                                                                      //   widget
                                                                      //       .context,
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (_) =>
                                                                      //         HomeScreen(),
                                                                      //   ),
                                                                      // )
                                                                    });
                                                            setState(() {
                                                              courseId =
                                                                  featuredCourse[
                                                                          0]
                                                                      .courseDocumentId;
                                                            });
                                                          });
                                                        }
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          'Start your free trial',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Start your free trial now',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Medium',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                        // SizedBox(
                        //   width: 200,
                        // ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 5.sp,
                // ),
                InkWell(
                  onTap: () {
                    if (featuredCourse[0].international != null &&
                        featuredCourse[0].international == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InternationalPaymentScreen(
                            cID: widget.cID,
                            // map: widget.map,
                            isItComboCourse: true,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            cID: widget.cID,
                            // map: widget.map,
                            isItComboCourse: true,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 45.sp,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10.sp)),
                    child: Center(
                      child: Text(
                        'Pay Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Medium',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
      enableDrag: false,
    );
  }
}

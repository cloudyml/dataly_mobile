// ignore: import_of_legacy_library_into_null_safe
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:dataly_app/combo/combo_course.dart';
import 'package:dataly_app/combo/multi_combo_course.dart';
import 'package:dataly_app/combo/multi_combo_feature_screen.dart';
import 'package:get/get.dart';
import 'package:dataly_app/module/pdf_course.dart';
import 'package:dataly_app/module/video_screen.dart';
import 'package:dataly_app/my_Courses.dart';
import 'package:dataly_app/combo/new_combo_course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/Providers/UserProvider.dart';
import 'package:dataly_app/authentication/firebase_auth.dart';
import 'package:dataly_app/api/firebase_api.dart';
import 'package:dataly_app/catalogue_screen.dart';
import 'package:dataly_app/combo/combo_store.dart';
import 'package:dataly_app/home.dart';
import 'package:dataly_app/models/course_details.dart';
import 'package:dataly_app/pages/notificationpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dataly_app/store.dart';
import 'package:flutter/material.dart';
import 'package:dataly_app/fun.dart';
import 'package:dataly_app/models/firebase_file.dart';
import 'package:hive/hive.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
// import 'package:ribbon/ribbon.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:badges/badges.dart' as prefix;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:star_rating/star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'combo/updated_combo_course.dart';
import 'models/user_details.dart';

class Home extends StatefulWidget {
  Home({Key? key, this.one, this.two, this.three}) : super(key: key);
  GlobalKey? one;
  GlobalKey? two;
  GlobalKey? three;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey? one = GlobalKey();
  GlobalKey? two = GlobalKey();
  GlobalKey? three = GlobalKey();
  Future<List<FirebaseFile>>? futureFiles;
  Future<List<FirebaseFile>>? futurefilesComboCourseReviews;
  Future<List<FirebaseFile>>? futurefilesSocialMediaReviews;
  List<Icon> list = [];

  ScrollController? _controller;
  final notificationBox = Hive.box('NotificationBox');
  String numberOfLearners = '17000+ learners';

  showNotification() async {
    try {
      if (notificationBox.isEmpty) {
        notificationBox.put(1, {"count": 0});
      } else {}
    } catch (e) {
      print('showNotification $e');
    }
  }

  List<dynamic> courses = [];

  Map userMap = Map<String, dynamic>();

  bool? load = true;

  void dbCheckerForPayInParts() async {
    try {
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        userMap = userDocs.data() as Map<String, dynamic>;
        globals.quiztrack = userMap['quiztrack'];
      });
    } catch (e) {
      print('dbCheckerForPayInParts $e');
    }
  }

  bool statusOfPayInParts(String id) {
    if (!(userMap['payInPartsDetails'][id] == null)) {
      if (userMap['payInPartsDetails'][id]['outStandingAmtPaid']) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool navigateToCatalogueScreen(String id) {
    if (userMap['payInPartsDetails'][id] != null) {
      final daysLeft = (DateTime.parse(
              userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
          .difference(DateTime.now())
          .inDays);
      print(daysLeft);
      return daysLeft < 1;
    } else {
      return false;
    }
  }

  var isShow;

  _wpshow() async {
    try {
      await FirebaseFirestore.instance
          .collection('Notice')
          .doc('rLwaS5rDufmCQ7Gv5vMI')
          .get()
          .then((value) {
        isShow = value.data()!['show'];
        print("show is===$isShow");
      });
    } catch (e) {
      print('_wpshow() $e');
    }
  }

  _launchWhatsapp() async {
    var note = await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get()
        .then((value) {
      return value.data()!['msg']; // Access your after your get the data
    });

    print("the msg is====$note");
    print("the show is====$isShow");

    var whatsApp1 = await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get()
        .then((value) {
      return value.data()!['number']; // Access your after your get the data
    });

    print("the number is====$whatsApp1");

    // var whatsapp = "+918902530551";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsApp1&text=$note");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  List<CourseDetails> featuredCourse = [];

  setFeaturedCourse(List<CourseDetails> course) {
    featuredCourse.clear();
    course.forEach((element) {
      if (element.FcSerialNumber.isNotEmpty && element.FcSerialNumber != null) {
        featuredCourse.add(element);
      }
    });
    featuredCourse.sort((a, b) {
      return int.parse(a.FcSerialNumber).compareTo(int.parse(b.FcSerialNumber));
    });
  }

  Future fetchCourses() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          if (value.data()!['paidCourseNames'] == null ||
              value.data()!['paidCourseNames'] == []) {
            courses = [];
          } else {
            courses = value.data()!['paidCourseNames'];
            // getPercentageOfCourse();
          }
          load = false;
        });
      });
      print('user enrolled in number of courses ${courses.length}');
    } catch (e) {
      print("kkkk $e}");
    }
  }

  bool isAnnounceMent = false;
  String announcementMsg = '';
  void getAnnouncement() async {
    await FirebaseFirestore.instance
        .collection('Notice')
        .doc('qdsnWW9NtIHwuFOGcuus_Annoucement')
        .get()
        .then((value) {
      setState(() {
        announcementMsg = value.data()!['Message'];
        isAnnounceMent = value.data()!['show'];
        // print("it is===$isAnnounceMent");
      });
    });
  }

  var coursePercent = {};
  var getData;

  getPercentageOfCourse() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          courses = value.data()!['paidCourseNames'];
          load = false;
        });
      });
    } catch (e) {
      print('getPercentageOfCourse ${e.toString()}');
    }
    try {
      if (courses.length != 0) {
        print('2');
        // try {
        //   await FirebaseFirestore.instance
        //       .collection('Users')
        //       .doc(FirebaseAuth.instance.currentUser!.uid)
        //       .get()
        //       .then((value) async {
        //     try {
        //       print('3');
        //       courses = value.data()!['paidCourseNames'];
        //       print("courses = ${courses}");
        //     } catch (e) {
        //       print('donggg ${e.toString()}');
        //     }
        //   });
        // } catch (e) {
        //   print('error 1 ${e.toString()}');
        // }

        try {
          await FirebaseFirestore.instance
              .collection("courseprogress_dataly")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            getData = value.data()!;
            print('4');
          });
          print('getData = $getData');
          for (var courseId in courses) {
            print("ID = = ${courseId}");
            num count = 0;
            try {
              await FirebaseFirestore.instance
                  .collection("courses")
                  .where("id", isEqualTo: courseId)
                  .get()
                  .then((value) async {
                if (value.docs.first.exists) {
                  var coursesName = value.docs.first.data()["courses"];
                  print('coursesName = $coursesName');
                  if (coursesName != null) {
                    print("name");
                    for (var Id in coursesName) {
                      num number = (getData![Id + "percentage"] != null)
                          ? getData[Id + "percentage"]
                          : 0;
                      count += number.toInt();
                      print("Count = ${count.toDouble()}");
                      coursePercent[courseId] =
                          count ~/ (value.docs.first.data()["courses"].length);
                    }
                  } else {
                    print("yy");
                    print(getData![value.docs.first.data()["id"].toString() +
                            "percentage"]
                        .toString());
                    coursePercent[courseId] = getData[
                                value.docs.first.data()["id"].toString() +
                                    "percentage"] !=
                            null
                        ? getData[value.docs.first.data()["id"].toString() +
                            "percentage"]
                        : 0;
                  }
                }
              }).catchError((err) => print("${err.toString()} Error"));
            } catch (err) {
              print('error 3 ${e.toString()}');
            }
          }
        } catch (e) {
          print('error 4 ${e.toString()}');
        }

        print("done");
        setState(() {
          coursePercent;
        });
        print(coursePercent);
      }
    } catch (e) {
      print('getPercentageOfCourse() $e');
    }
  }

  @override
  void initState() {
    _wpshow();
    dbCheckerForPayInParts();
    fetchCourses();
    showNotification();
    getPercentageOfCourse();
    final UserDetails? userCourse =
        Provider.of<UserDetails?>(context, listen: false);
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerNotification =
        Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    setFeaturedCourse(course);
    getAnnouncement();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('440F87'),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Flogo2.png?alt=media&token=5490042c-4e02-4861-980f-359c21b7489b",
              width: 40,
              height: 50,
            ),
            Text(
              "Dataly",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Semibold",
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(
            Icons.menu,
            size: 40,
            color: Colors.white,
          ),
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, data, child) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Notifications")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    //    print("-------------${notificationBox.values}");
                    if (snapshot.data != null &&
                        snapshot.data!.docs.length < data.countNotification) {
                      notificationBox
                          .put(1, {"count": (snapshot.data!.docs.length)});
                      providerNotification.showNotificationHomeScreen(
                          notificationBox.values.first["count"]);
                    }
                    return Showcase(
                      key: two!,
                      description: 'Notifications comes here',
                      disableDefaultTargetGestures: true,
                      child: prefix.Badge(
                          showBadge: snapshot.data != null &&
                                  (data.countNotification ==
                                          snapshot.data!.docs.length ||
                                      snapshot.data!.docs.length <
                                          data.countNotification)
                              ? false
                              : true,
                          child: IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage()),
                              );
                              await notificationBox.put(1, {
                                "count": (snapshot.data != null
                                    ? snapshot.data!.docs.length
                                    : 0)
                              });
                              await providerNotification
                                  .showNotificationHomeScreen(
                                      notificationBox.values.first["count"]);
                              print(
                                  "++++++++++++++++++++++++${notificationBox.values}");
                            },
                            icon: Icon(
                              Icons.notifications_active,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          badgeStyle: BadgeStyle(
                            badgeColor: Colors.red,
                          ),
                          // toAnimate: false,
                          badgeContent: Text(
                            snapshot.data != null
                                ? snapshot.data!.docs.length -
                                            notificationBox
                                                .values.first["count"] >=
                                        0
                                    ? (snapshot.data!.docs.length -
                                            notificationBox
                                                .values.first["count"])
                                        .toString()
                                    : (notificationBox.values.first["count"] -
                                            snapshot.data!.docs.length)
                                        .toString()
                                : '0',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          position: BadgePosition.custom(
                            top: snapshot.data != null
                                ? (2 -
                                        2 *
                                            (snapshot.data!.docs.length)
                                                .toString()
                                                .length) *
                                    verticalScale
                                : 0,
                            end: data.countNotification >= 100 ? 2 : 7,
                          )
                          // BadgePosition(

                          // top: (2 - 2 *
                          //         (snapshot.data!.docs.length)
                          //             .toString()
                          //             .length) *
                          //     verticalScale,
                          // end: data.countNotification >= 100 ? 2 : 7,
                          // (7+((snapshot.data!.docs.length).toString().length))
                          // ),
                          ),
                    );
                  });
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Fwebbg.png?alt=media&token=04326232-0b38-44f3-9722-3dfc1a89e052',
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          return Container(
                            color: HexColor('190037'),
                          );
                        },
                      )),
                  Positioned(
                    bottom: 80,
                    right: 20,
                    left: 20,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Image.asset(
                          'images/ceopic.png',
                          fit: BoxFit.fill,
                        )),
                  ),
                  Positioned(
                    top: 40,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Learn ',
                                style: TextStyle(
                                  color: HexColor('FFFFFF'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Barlow',
                                ),
                              ),
                              Text(
                                'Data Science',
                                style: TextStyle(
                                  color: HexColor('7B4DFF'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Barlow',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'By Doing It!',
                            style: TextStyle(
                              color: HexColor('FFFFFF'),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              fontFamily: 'Barlow',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            width: 300,
                            child: Text(
                              'Get Complete Hands-on Practical Learning Experience with CloudyML and become Job-Ready Data Scientist, Data Analyst, Business Analyst, Research Analyst and ML Engineer.',
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontFamily: 'Barlow Semi Condensed',
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Trusted by $numberOfLearners',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Learn from industry experts',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isAnnounceMent
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 20 * horizontalScale,
                        right: 20 * horizontalScale,
                        bottom: 4
                        // top: 20 * verticalScale,
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Announcements 📣',
                          textScaleFactor: min(horizontalScale, verticalScale),
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Poppins',
                            fontSize: 23,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10 * horizontalScale,
                            right: 10 * horizontalScale,
                            top: 15 * verticalScale,
                            bottom: 15 * verticalScale,

                            // top: 20 * verticalScale,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepPurple.withOpacity(0.12)),
                          child: Center(
                            child: Text(
                              announcementMsg,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            Container(
              height: screenHeight * 1.5,
              width: screenWidth,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 1.5,
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FLanding%20Page.jpg?alt=media&token=c820b5f5-c177-4de8-a5da-e26afc4a8c28',
                      fit: BoxFit.fill,
                    ),
                  ),
                  courses.length > 0
                      ? Positioned(
                          top: 0.sp,
                          left: 15.sp,
                          child: Container(
                            width: screenWidth * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Enrolled Courses',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'See all',
                                        style: TextStyle(
                                            color: HexColor('2369F0'),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: HexColor('2369F0'),
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Container(),
                  Positioned(
                    top: 50,
                    child: Container(
                        height: 325,
                        width: screenWidth,
                        child: courses.length > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // shrinkWrap: true,
                                  itemCount: course.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (course[index].courseName == "null") {
                                      return Container();
                                    }
                                    if (courses
                                        .contains(course[index].courseId)) {
                                      return InkWell(
                                        onTap: (() {
                                          // setModuleId(snapshot.data!.docs[index].id);
                                          // getCourseName();
                                          if (navigateToCatalogueScreen(
                                                  course[index].courseId) &&
                                              !(userMap['payInPartsDetails']
                                                      [course[index].courseId]
                                                  ['outStandingAmtPaid'])) {
                                            if (course[index].multiCombo ==
                                                true) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiComboCourse(
                                                      courseName: course[index]
                                                          .courseName
                                                          .toString(),
                                                      id: course[index]
                                                          .courseId,
                                                    ),
                                                  ));
                                            } else if (!course[index]
                                                .isItComboCourse) {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  child: VideoScreen(
                                                    isdemo: true,
                                                    courseName: course[index]
                                                        .curriculum
                                                        .keys
                                                        .toList()
                                                        .first
                                                        .toString(),
                                                    sr: 1,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  curve: Curves.bounceInOut,
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  child: ComboStore(
                                                    courses:
                                                        course[index].courses,
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            if (course[index].multiCombo ==
                                                true) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiComboCourse(
                                                      courseName: course[index]
                                                          .courseName
                                                          .toString(),
                                                      id: course[index]
                                                          .courseId,
                                                    ),
                                                  ));
                                            } else if (!course[index]
                                                .isItComboCourse) {
                                              if (course[index].courseContent ==
                                                  'pdf') {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.bounceInOut,
                                                    type: PageTransitionType
                                                        .rightToLeftWithFade,
                                                    child: PdfCourseScreen(
                                                      curriculum: course[index]
                                                              .curriculum
                                                          as Map<String,
                                                              dynamic>,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.bounceInOut,
                                                    type: PageTransitionType
                                                        .rightToLeftWithFade,
                                                    child:
                                                        //NewVideoScreen(courseName: course[index].courseName,)

                                                        VideoScreen(
                                                      isdemo: true,
                                                      courseName: course[index]
                                                          .curriculum
                                                          .keys
                                                          .toList()
                                                          .first
                                                          .toString(),
                                                      sr: 1,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ComboCourse.comboId.value =
                                                  course[index].courseId;
                                              Get.to(() => NewComboCourse(
                                                    courseName: course[index]
                                                        .courseName,
                                                    courses:
                                                        course[index].courses,
                                                  ));

                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) => NewScreen(
                                              //     courses: course[index].courses,
                                              //     courseName: course[index].courseName,
                                              //   ),),
                                              // );

                                              // Navigator.push(
                                              //   context,
                                              //   PageTransition(
                                              //     duration: Duration(milliseconds: 400),
                                              //     curve: Curves.bounceInOut,
                                              //     type: PageTransitionType
                                              //         .rightToLeftWithFade,
                                              //     child: ComboCourse(
                                              //       courses: course[index].courses,
                                              //     ),
                                              //   ),
                                              // );
                                            }
                                          }
                                          setState(() {
                                            courseId =
                                                course[index].courseDocumentId;
                                          });
                                        }),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Container(
                                            // height: Adaptive.h(40),
                                            width: width / 1.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: Colors.white),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Container(
                                                    width: width,
                                                    height: height / 5.5,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.network(
                                                          course[index]
                                                              .courseImageUrl,
                                                          fit: BoxFit.fill,
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12, right: 12),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // course[index]
                                                        //     .isItComboCourse
                                                        //     ? Row(
                                                        //   children: [
                                                        //     Container(
                                                        //       width: 70,
                                                        //       height: 37,
                                                        //       decoration:
                                                        //       BoxDecoration(
                                                        //         borderRadius:
                                                        //         BorderRadius.circular(
                                                        //             10),
                                                        //         // gradient: gradient,
                                                        //         color: Color(
                                                        //             0xFF7860DC),
                                                        //       ),
                                                        //       child:
                                                        //       Center(
                                                        //         child:
                                                        //         Text(
                                                        //           'COMBO',
                                                        //           style:
                                                        //           const TextStyle(
                                                        //             fontFamily:
                                                        //             'Bold',
                                                        //             fontSize:
                                                        //             10,
                                                        //             fontWeight:
                                                        //             FontWeight.w500,
                                                        //             color:
                                                        //             Colors.white,
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     )
                                                        //   ],
                                                        // )
                                                        //     : Container(),
                                                        Container(
                                                          height: 35,
                                                          child: Text(
                                                            course[index]
                                                                .courseName,
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '2C2C2C'),
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            // overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        course[index]
                                                                    .isItComboCourse &&
                                                                statusOfPayInParts(
                                                                    course[index]
                                                                        .courseId)
                                                            ? Container(
                                                                child: !navigateToCatalogueScreen(
                                                                        course[index]
                                                                            .courseId)
                                                                    ? Container(
                                                                        height: MediaQuery.of(context).size.width *
                                                                            0.08 *
                                                                            verticalScale,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          color:
                                                                              Color(
                                                                            0xFFC0AAF5,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              'Access ends in days : ',
                                                                              textScaleFactor: min(horizontalScale, verticalScale),
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.grey.shade100,
                                                                              ),
                                                                              width: 30 * min(horizontalScale, verticalScale),
                                                                              height: 30 * min(horizontalScale, verticalScale),
                                                                              // color:
                                                                              //     Color(0xFFaefb2a),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '${(DateTime.parse(userMap['payInPartsDetails'][course[index].courseId]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
                                                                                  textScaleFactor: min(horizontalScale, verticalScale),
                                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
                                                                                      // fontSize: 16,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height: MediaQuery.of(context).size.width *
                                                                            0.08,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              Color(0xFFC0AAF5),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Limited access expired !',
                                                                            textScaleFactor:
                                                                                min(horizontalScale, verticalScale),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.deepOrange[600],
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              )
                                                            : SizedBox(),
                                                        Container(
                                                          child: Text(
                                                            course[index]
                                                                .courseDescription,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Medium',
                                                                color: HexColor(
                                                                    '585858'),
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                course[index]
                                                                        .courseLanguage +
                                                                    "  ||",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Medium',
                                                                    color: HexColor(
                                                                        '585858'),
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              child: Center(
                                                                child: Text(
                                                                  '${course[index].numOfVideos} videos',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Medium',
                                                                      color: HexColor(
                                                                          '585858'),
                                                                      fontSize:
                                                                          8),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0, right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 140,
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: HexColor('8346E1'),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                    ),
                                                                    padding: EdgeInsets.all(0)),
                                                                onPressed: () {
                                                                  // setModuleId(snapshot.data!.docs[index].id);
                                                                  // getCourseName();
                                                                  if (navigateToCatalogueScreen(
                                                                          course[index]
                                                                              .courseId) &&
                                                                      !(userMap[
                                                                          'payInPartsDetails'][course[
                                                                              index]
                                                                          .courseId]['outStandingAmtPaid'])) {
                                                                    if (course[index]
                                                                            .multiCombo ==
                                                                        true) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                MultiComboCourse(
                                                                              courseName: course[index].courseName.toString(),
                                                                              id: course[index].courseId,
                                                                            ),
                                                                          ));
                                                                    } else if (!course[
                                                                            index]
                                                                        .isItComboCourse) {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        PageTransition(
                                                                          duration:
                                                                              Duration(milliseconds: 400),
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          type:
                                                                              PageTransitionType.rightToLeftWithFade,
                                                                          child:
                                                                              VideoScreen(
                                                                            isdemo:
                                                                                true,
                                                                            courseName:
                                                                                course[index].curriculum.keys.toList().first.toString(),
                                                                            sr: 1,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        PageTransition(
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          type:
                                                                              PageTransitionType.rightToLeftWithFade,
                                                                          child:
                                                                              ComboStore(
                                                                            courses:
                                                                                course[index].courses,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  } else {
                                                                    if (course[index]
                                                                            .multiCombo ==
                                                                        true) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                MultiComboCourse(
                                                                              courseName: course[index].courseName.toString(),
                                                                              id: course[index].courseId,
                                                                            ),
                                                                          ));
                                                                    } else if (!course[
                                                                            index]
                                                                        .isItComboCourse) {
                                                                      if (course[index]
                                                                              .courseContent ==
                                                                          'pdf') {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageTransition(
                                                                            duration:
                                                                                Duration(milliseconds: 400),
                                                                            curve:
                                                                                Curves.bounceInOut,
                                                                            type:
                                                                                PageTransitionType.rightToLeftWithFade,
                                                                            child:
                                                                                PdfCourseScreen(
                                                                              curriculum: course[index].curriculum as Map<String, dynamic>,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageTransition(
                                                                            duration:
                                                                                Duration(milliseconds: 400),
                                                                            curve:
                                                                                Curves.bounceInOut,
                                                                            type:
                                                                                PageTransitionType.rightToLeftWithFade,
                                                                            child:
                                                                                //NewVideoScreen(courseName: course[index].courseName,)

                                                                                VideoScreen(
                                                                              isdemo: true,
                                                                              courseName: course[index].curriculum.keys.toList().first.toString(),
                                                                              sr: 1,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    } else {
                                                                      ComboCourse
                                                                          .comboId
                                                                          .value = course[
                                                                              index]
                                                                          .courseId;
                                                                      Get.to(() =>
                                                                          NewComboCourse(
                                                                            courseName:
                                                                                course[index].courseName,
                                                                            courses:
                                                                                course[index].courses,
                                                                          ));

                                                                      // Navigator.push(
                                                                      //   context,
                                                                      //   MaterialPageRoute(builder: (context) => NewScreen(
                                                                      //     courses: course[index].courses,
                                                                      //     courseName: course[index].courseName,
                                                                      //   ),),
                                                                      // );

                                                                      // Navigator.push(
                                                                      //   context,
                                                                      //   PageTransition(
                                                                      //     duration: Duration(milliseconds: 400),
                                                                      //     curve: Curves.bounceInOut,
                                                                      //     type: PageTransitionType
                                                                      //         .rightToLeftWithFade,
                                                                      //     child: ComboCourse(
                                                                      //       courses: course[index].courses,
                                                                      //     ),
                                                                      //   ),
                                                                      // );
                                                                    }
                                                                  }
                                                                  setState(() {
                                                                    courseId = course[
                                                                            index]
                                                                        .courseDocumentId;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .play_arrow_rounded,
                                                                      size: 22,
                                                                    ),
                                                                    FittedBox(
                                                                        fit: BoxFit
                                                                            .fitWidth,
                                                                        child:
                                                                            Text(
                                                                          'Resume Learning',
                                                                          style:
                                                                              TextStyle(fontSize: 10),
                                                                        )),
                                                                  ],
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          CircularPercentIndicator(
                                                            radius: 24,
                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            percent: coursePercent[course[
                                                                            index]
                                                                        .courseId
                                                                        .toString()] !=
                                                                    null
                                                                ? coursePercent[
                                                                        course[index]
                                                                            .courseId] /
                                                                    100
                                                                : 0 / 100,
                                                            progressColor:
                                                                HexColor(
                                                                    "31D198"),
                                                            lineWidth: 4,
                                                            center: Text(
                                                              "${coursePercent[course[index].courseId.toString()] != null ? coursePercent[course[index].courseId] : 0}%",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              )
                            : Container()
                        // Padding(
                        //   padding: EdgeInsets.all(18.sp),
                        //   child: Container(
                        //     width: Adaptive.w(100),
                        //     height: Adaptive.h(66),
                        //     padding: EdgeInsets.all(15.sp),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(20.sp),
                        //     ),
                        //     child: Center(
                        //         child: Text(
                        //           'There are no courses. Please enroll and start learning.',
                        //           style: TextStyle(
                        //             fontSize: 16.sp,
                        //             fontWeight: FontWeight.bold,
                        //             height: 1,
                        //           ),
                        //         )),
                        //   ),
                        // ),
                        ),
                  ),
                  // Positioned(
                  //     top: 80.sp,
                  //     left: 15.sp,
                  //     child: Container(
                  //       width: Adaptive.w(90),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             'Course Reviews',
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 16.sp),
                  //           ),
                  //           InkWell(
                  //             onTap: () {
                  //               GoRouter.of(context)
                  //                   .pushReplacementNamed('reviews');
                  //             },
                  //             child: Row(
                  //               children: [
                  //                 Text(
                  //                   'See all',
                  //                   style: TextStyle(
                  //                       color: HexColor('2369F0'),
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 18.sp),
                  //                 ),
                  //                 Icon(
                  //                   Icons.arrow_forward_rounded,
                  //                   color: HexColor('2369F0'),
                  //                   size: 20.sp,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  // Positioned(
                  //   top: 84.sp,
                  //   left: 20.sp,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           FutureBuilder<List<FirebaseFile>>(
                  //             future: futureFiles,
                  //             builder: (context, snapshot) {
                  //               try {
                  //                 switch (snapshot.connectionState) {
                  //                   case ConnectionState.waiting:
                  //                     return Center(
                  //                         child: CircularProgressIndicator());
                  //                   default:
                  //                     if (snapshot.hasError) {
                  //                       return Center(
                  //                           child: Text(
                  //                         'Some error occurred!',
                  //                         textScaleFactor: min(
                  //                             horizontalScale, verticalScale),
                  //                       ));
                  //                     } else {
                  //                       final files = snapshot.data!;
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(5.0),
                  //                         child: Container(
                  //                           height: screenHeight / 5,
                  //                           width: screenWidth / 2.5,
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15),
                  //                           ),
                  //                           child: CarouselSlider.builder(
                  //                               options: CarouselOptions(
                  //                                 autoPlay: true,
                  //                                 enableInfiniteScroll: true,
                  //                                 enlargeCenterPage: false,
                  //                                 viewportFraction: 1,
                  //                                 aspectRatio: 2.0,
                  //                                 initialPage: 0,
                  //                                 autoPlayCurve:
                  //                                     Curves.fastOutSlowIn,
                  //                                 autoPlayAnimationDuration:
                  //                                     Duration(
                  //                                         milliseconds: 1000),
                  //                               ),
                  //                               itemCount: files.length,
                  //                               itemBuilder:
                  //                                   (BuildContext context,
                  //                                       int index, int pageNo) {
                  //                                 return ClipRRect(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     child: InkWell(
                  //                                       onTap: () {
                  //                                         final file =
                  //                                             files[index];
                  //                                         showDialog(
                  //                                             context: context,
                  //                                             builder: (context) =>
                  //                                                 GestureDetector(
                  //                                                     onTap: () =>
                  //                                                         Navigator.pop(
                  //                                                             context),
                  //                                                     child:
                  //                                                         Container(
                  //                                                       alignment:
                  //                                                           Alignment.center,
                  //                                                       color: Colors
                  //                                                           .transparent,
                  //                                                       height:
                  //                                                           400,
                  //                                                       width:
                  //                                                           300,
                  //                                                       child:
                  //                                                           AlertDialog(
                  //                                                         shape: RoundedRectangleBorder(
                  //                                                             borderRadius: BorderRadius.circular(15.0),
                  //                                                             side: BorderSide.none),
                  //                                                         scrollable:
                  //                                                             true,
                  //                                                         content:
                  //                                                             Container(
                  //                                                           height:
                  //                                                               240,
                  //                                                           width:
                  //                                                               320,
                  //                                                           child:
                  //                                                               ClipRRect(
                  //                                                             borderRadius: BorderRadius.circular(20),
                  //                                                             child: CachedNetworkImage(
                  //                                                               errorWidget: (context, url, error) => Icon(Icons.error),
                  //                                                               imageUrl: file.url,
                  //                                                               fit: BoxFit.fill,
                  //                                                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  //                                                             ),
                  //                                                           ),
                  //                                                         ),
                  //                                                       ),
                  //                                                     )));
                  //                                       },
                  //                                       child: Image.network(
                  //                                           files[index].url),
                  //                                     ));
                  //                               }),
                  //                         ),
                  //                       );
                  //                     }
                  //                 }
                  //               } catch (e) {
                  //                 print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");
                  //
                  //                 Fluttertoast.showToast(msg: e.toString());
                  //                 return Center(
                  //                     child: Text(
                  //                   'Some error occurred!',
                  //                   textScaleFactor:
                  //                       min(horizontalScale, verticalScale),
                  //                 ));
                  //               }
                  //             },
                  //           ),
                  //           FutureBuilder<List<FirebaseFile>>(
                  //             future: futurefilesComboCourseReviews,
                  //             builder: (context, snapshot) {
                  //               try {
                  //                 switch (snapshot.connectionState) {
                  //                   case ConnectionState.waiting:
                  //                     return Center(
                  //                         child: CircularProgressIndicator());
                  //                   default:
                  //                     if (snapshot.hasError) {
                  //                       return Center(
                  //                           child: Text(
                  //                         'Some error occurred!',
                  //                         textScaleFactor: min(
                  //                             horizontalScale, verticalScale),
                  //                       ));
                  //                     } else {
                  //                       final files = snapshot.data!;
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(5.0),
                  //                         child: Container(
                  //                           height: screenHeight / 5,
                  //                           width: screenWidth / 2.5,
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15),
                  //                           ),
                  //                           child: CarouselSlider.builder(
                  //                               options: CarouselOptions(
                  //                                 autoPlay: true,
                  //                                 enableInfiniteScroll: true,
                  //                                 enlargeCenterPage: false,
                  //                                 viewportFraction: 1,
                  //                                 aspectRatio: 2.0,
                  //                                 initialPage: 4,
                  //                                 autoPlayCurve:
                  //                                     Curves.fastOutSlowIn,
                  //                                 autoPlayAnimationDuration:
                  //                                     Duration(
                  //                                         milliseconds: 2000),
                  //                               ),
                  //                               itemCount: files.length,
                  //                               itemBuilder:
                  //                                   (BuildContext context,
                  //                                       int index, int pageNo) {
                  //                                 return ClipRRect(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     child: InkWell(
                  //                                       onTap: () {
                  //                                         final file =
                  //                                             files[index];
                  //                                         showDialog(
                  //                                             context: context,
                  //                                             builder: (context) =>
                  //                                                 GestureDetector(
                  //                                                     onTap: () =>
                  //                                                         Navigator.pop(
                  //                                                             context),
                  //                                                     child:
                  //                                                         Container(
                  //                                                       alignment:
                  //                                                           Alignment.center,
                  //                                                       color: Colors
                  //                                                           .transparent,
                  //                                                       height:
                  //                                                           400,
                  //                                                       width:
                  //                                                           300,
                  //                                                       child:
                  //                                                           AlertDialog(
                  //                                                         shape: RoundedRectangleBorder(
                  //                                                             borderRadius: BorderRadius.circular(15.0),
                  //                                                             side: BorderSide.none),
                  //                                                         scrollable:
                  //                                                             true,
                  //                                                         content:
                  //                                                             Container(
                  //                                                           height:
                  //                                                               240,
                  //                                                           width:
                  //                                                               320,
                  //                                                           child:
                  //                                                               ClipRRect(
                  //                                                             borderRadius: BorderRadius.circular(20),
                  //                                                             child: CachedNetworkImage(
                  //                                                               errorWidget: (context, url, error) => Icon(Icons.error),
                  //                                                               imageUrl: file.url,
                  //                                                               fit: BoxFit.fill,
                  //                                                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  //                                                             ),
                  //                                                           ),
                  //                                                         ),
                  //                                                       ),
                  //                                                     )));
                  //                                       },
                  //                                       child: Image.network(
                  //                                           files[index].url),
                  //                                     ));
                  //                               }),
                  //                         ),
                  //                       );
                  //                     }
                  //                 }
                  //               } catch (e) {
                  //                 print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");
                  //
                  //                 Fluttertoast.showToast(msg: e.toString());
                  //                 return Center(
                  //                     child: Text(
                  //                   'Some error occurred!',
                  //                   textScaleFactor:
                  //                       min(horizontalScale, verticalScale),
                  //                 ));
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           FutureBuilder<List<FirebaseFile>>(
                  //             future: futurefilesComboCourseReviews,
                  //             builder: (context, snapshot) {
                  //               try {
                  //                 switch (snapshot.connectionState) {
                  //                   case ConnectionState.waiting:
                  //                     return Center(
                  //                         child: CircularProgressIndicator());
                  //                   default:
                  //                     if (snapshot.hasError) {
                  //                       return Center(
                  //                           child: Text(
                  //                         'Some error occurred!',
                  //                         textScaleFactor: min(
                  //                             horizontalScale, verticalScale),
                  //                       ));
                  //                     } else {
                  //                       final files = snapshot.data!;
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(5.0),
                  //                         child: Container(
                  //                           height: screenHeight / 5,
                  //                           width: screenWidth / 2.5,
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15),
                  //                           ),
                  //                           child: CarouselSlider.builder(
                  //                               options: CarouselOptions(
                  //                                 autoPlay: true,
                  //                                 enableInfiniteScroll: true,
                  //                                 enlargeCenterPage: false,
                  //                                 viewportFraction: 1,
                  //                                 aspectRatio: 2.0,
                  //                                 initialPage: 4,
                  //                                 autoPlayCurve:
                  //                                     Curves.fastOutSlowIn,
                  //                                 autoPlayAnimationDuration:
                  //                                     Duration(
                  //                                         milliseconds: 2000),
                  //                               ),
                  //                               itemCount: files.length,
                  //                               itemBuilder:
                  //                                   (BuildContext context,
                  //                                       int index, int pageNo) {
                  //                                 return ClipRRect(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     child: InkWell(
                  //                                       onTap: () {
                  //                                         final file =
                  //                                             files[index];
                  //                                         showDialog(
                  //                                             context: context,
                  //                                             builder: (context) =>
                  //                                                 GestureDetector(
                  //                                                     onTap: () =>
                  //                                                         Navigator.pop(
                  //                                                             context),
                  //                                                     child:
                  //                                                         Container(
                  //                                                       alignment:
                  //                                                           Alignment.center,
                  //                                                       color: Colors
                  //                                                           .transparent,
                  //                                                       height:
                  //                                                           400,
                  //                                                       width:
                  //                                                           300,
                  //                                                       child:
                  //                                                           AlertDialog(
                  //                                                         shape: RoundedRectangleBorder(
                  //                                                             borderRadius: BorderRadius.circular(15.0),
                  //                                                             side: BorderSide.none),
                  //                                                         scrollable:
                  //                                                             true,
                  //                                                         content:
                  //                                                             Container(
                  //                                                           height:
                  //                                                               240,
                  //                                                           width:
                  //                                                               320,
                  //                                                           child:
                  //                                                               ClipRRect(
                  //                                                             borderRadius: BorderRadius.circular(20),
                  //                                                             child: CachedNetworkImage(
                  //                                                               errorWidget: (context, url, error) => Icon(Icons.error),
                  //                                                               imageUrl: file.url,
                  //                                                               fit: BoxFit.fill,
                  //                                                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  //                                                             ),
                  //                                                           ),
                  //                                                         ),
                  //                                                       ),
                  //                                                     )));
                  //                                       },
                  //                                       child: Image.network(
                  //                                           files[index].url),
                  //                                     ));
                  //                               }),
                  //                         ),
                  //                       );
                  //                     }
                  //                 }
                  //               } catch (e) {
                  //                 print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");
                  //
                  //                 Fluttertoast.showToast(msg: e.toString());
                  //                 return Center(
                  //                     child: Text(
                  //                   'Some error occurred!',
                  //                   textScaleFactor:
                  //                       min(horizontalScale, verticalScale),
                  //                 ));
                  //               }
                  //             },
                  //           ),
                  //           FutureBuilder<List<FirebaseFile>>(
                  //             future: futurefilesSocialMediaReviews,
                  //             builder: (context, snapshot) {
                  //               try {
                  //                 switch (snapshot.connectionState) {
                  //                   case ConnectionState.waiting:
                  //                     return Center(
                  //                         child: CircularProgressIndicator());
                  //                   default:
                  //                     if (snapshot.hasError) {
                  //                       return Center(
                  //                           child: Text(
                  //                         'Some error occurred!',
                  //                         textScaleFactor: min(
                  //                             horizontalScale, verticalScale),
                  //                       ));
                  //                     } else {
                  //                       final files = snapshot.data!;
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(5.0),
                  //                         child: Container(
                  //                           height: screenHeight / 5,
                  //                           width: screenWidth / 2.5,
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15),
                  //                           ),
                  //                           child: CarouselSlider.builder(
                  //                               options: CarouselOptions(
                  //                                 autoPlay: true,
                  //                                 enableInfiniteScroll: true,
                  //                                 enlargeCenterPage: false,
                  //                                 viewportFraction: 1,
                  //                                 aspectRatio: 2.0,
                  //                                 initialPage: 7,
                  //                                 autoPlayCurve:
                  //                                     Curves.fastOutSlowIn,
                  //                                 autoPlayAnimationDuration:
                  //                                     Duration(
                  //                                         milliseconds: 3000),
                  //                               ),
                  //                               itemCount: files.length,
                  //                               itemBuilder:
                  //                                   (BuildContext context,
                  //                                       int index, int pageNo) {
                  //                                 return ClipRRect(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     child: InkWell(
                  //                                       onTap: () {
                  //                                         final file =
                  //                                             files[index];
                  //                                         showDialog(
                  //                                             context: context,
                  //                                             builder: (context) =>
                  //                                                 GestureDetector(
                  //                                                     onTap: () =>
                  //                                                         Navigator.pop(
                  //                                                             context),
                  //                                                     child:
                  //                                                         Container(
                  //                                                       alignment:
                  //                                                           Alignment.center,
                  //                                                       color: Colors
                  //                                                           .transparent,
                  //                                                       height:
                  //                                                           400,
                  //                                                       width:
                  //                                                           300,
                  //                                                       child:
                  //                                                           AlertDialog(
                  //                                                         shape: RoundedRectangleBorder(
                  //                                                             borderRadius: BorderRadius.circular(15.0),
                  //                                                             side: BorderSide.none),
                  //                                                         scrollable:
                  //                                                             true,
                  //                                                         content:
                  //                                                             Container(
                  //                                                           height:
                  //                                                               240,
                  //                                                           width:
                  //                                                               320,
                  //                                                           child:
                  //                                                               ClipRRect(
                  //                                                             borderRadius: BorderRadius.circular(20),
                  //                                                             child: CachedNetworkImage(
                  //                                                               errorWidget: (context, url, error) => Icon(Icons.error),
                  //                                                               imageUrl: file.url,
                  //                                                               fit: BoxFit.fill,
                  //                                                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  //                                                             ),
                  //                                                           ),
                  //                                                         ),
                  //                                                       ),
                  //                                                     )));
                  //                                       },
                  //                                       child: Image.network(
                  //                                           files[index].url),
                  //                                     ));
                  //                               }),
                  //                         ),
                  //                       );
                  //                     }
                  //                 }
                  //               } catch (e) {
                  //                 print("jjkkjkjkkkkjkjjjjjjjjkkk${e}");
                  //
                  //                 Fluttertoast.showToast(msg: e.toString());
                  //                 return Center(
                  //                     child: Text(
                  //                   'Some error occurred!',
                  //                   textScaleFactor:
                  //                       min(horizontalScale, verticalScale),
                  //                 ));
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                      bottom: 520,
                      // left: 50,
                      child: Container(
                        width: screenWidth,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight / 6,
                                  width: screenWidth / 1.75,
                                  padding: EdgeInsets.only(
                                      left: 15 * verticalScale,
                                      top: 35 * verticalScale),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          colors: [
                                            HexColor('683AB0'),
                                            HexColor('230454'),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Our',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'SemiBold',
                                                fontSize: 18 * verticalScale,
                                                height: 1,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            ' Special',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'SemiBold',
                                                fontSize: 18 * verticalScale,
                                                height: 1,
                                                color: HexColor('FFDB1B')),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10 * verticalScale,
                                      ),
                                      Text('Features for you',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'SemiBold',
                                              fontSize: 18 * verticalScale,
                                              height: 1,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 3.5,
                                    padding: EdgeInsets.all(10 * verticalScale),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30 * verticalScale,
                                          width: 25 * horizontalScale,
                                          child: Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV1.png?alt=media&token=c3c352fc-ae1e-4960-8f14-77307f4f94d9',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10 * verticalScale,
                                        ),
                                        Text(
                                          'Hands-On Learning',
                                          style: TextStyle(
                                            fontSize: 10 * verticalScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5 * verticalScale,
                                        ),
                                        Text(
                                          'Get Complete Hands-on Practical Learning Experience through Assignments & Projects for Proper Confidence Building',
                                          style: TextStyle(
                                            fontSize: 6 * verticalScale,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 3.5,
                                    padding: EdgeInsets.all(10 * verticalScale),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30 * verticalScale,
                                          width: 25 * horizontalScale,
                                          child: Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV2.png?alt=media&token=67c2dedc-c53b-4ee7-af04-4ab36ceea2c7',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10 * verticalScale,
                                        ),
                                        Text(
                                          'Doubt clearance support',
                                          style: TextStyle(
                                            fontSize: 10 * verticalScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5 * verticalScale,
                                        ),
                                        Text(
                                          'Get Complete Hands-on Practical Learning Experience through Assignments & Projects for Proper Confidence Building',
                                          style: TextStyle(
                                            fontSize: 6 * verticalScale,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      height: screenHeight / 6,
                                      width: screenWidth / 3.5,
                                      padding:
                                          EdgeInsets.all(10 * verticalScale),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30 * verticalScale,
                                            width: 25 * horizontalScale,
                                            child: Image.network(
                                              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV3.png?alt=media&token=66b62e70-8c7b-4410-a883-b97e23cbccff',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10 * verticalScale,
                                          ),
                                          Text(
                                            'Lifetime Access',
                                            style: TextStyle(
                                              fontSize: 10 * verticalScale,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5 * verticalScale,
                                          ),
                                          Text(
                                            'Get Complete Hands-on Practical Learning Experience through Assignments & Projects for Proper Confidence Building',
                                            style: TextStyle(
                                              fontSize: 6 * verticalScale,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      height: screenHeight / 6,
                                      width: screenWidth / 3.5,
                                      padding:
                                          EdgeInsets.all(10 * verticalScale),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30 * verticalScale,
                                            width: 25 * horizontalScale,
                                            child: Image.network(
                                              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV4.png?alt=media&token=236df98e-1d4d-477d-9d55-720210caa64a',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10 * verticalScale,
                                          ),
                                          Text(
                                            'Industrial Internship',
                                            style: TextStyle(
                                              fontSize: 10 * verticalScale,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5 * verticalScale,
                                          ),
                                          Text(
                                            'Get Complete Hands-on Practical Learning Experience through Assignments & Projects for Proper Confidence Building',
                                            style: TextStyle(
                                              fontSize: 6 * verticalScale,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                    bottom: 80,
                    child: Container(
                      height: 400,
                      width: screenWidth,
                      color: HexColor('130329'),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              'Most Popular Courses',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'SemiBold',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 320,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: featuredCourse.length,
                                itemBuilder: (BuildContext context, index) {
                                  if (featuredCourse[index].courseName ==
                                      "null") {
                                    return Container();
                                  }
                                  // if (course[index].isItComboCourse == true)
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          courseId = featuredCourse[index]
                                              .courseDocumentId;
                                        });
                                        print(courseId);
                                        if (featuredCourse[index]
                                            .isItComboCourse) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ComboStore(
                                                // international: featuredCourse[index]
                                                //     .international,
                                                trialCourse:
                                                    featuredCourse[index]
                                                        .trialCourse,
                                                courseP: featuredCourse[index]
                                                    .coursePrice,
                                                id: index.toString(),
                                                cID: featuredCourse[index]
                                                    .courseDocumentId,
                                                cName: featuredCourse[index]
                                                    .courseName,
                                                image: featuredCourse[index]
                                                    .courseImageUrl,
                                                courses: featuredCourse[index]
                                                    .courses,
                                                courseName:
                                                    featuredCourse[index]
                                                        .courseName,
                                              ),
                                            ),
                                          );
                                        } else if (featuredCourse[index]
                                                .multiCombo ==
                                            true) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MultiComboFeatureScreen(
                                                          cID: featuredCourse[
                                                                  index]
                                                              .courseDocumentId,
                                                          courseName:
                                                              featuredCourse[
                                                                      index]
                                                                  .courseName,
                                                          id: featuredCourse[
                                                                  index]
                                                              .courseId,
                                                          coursePrice:
                                                              featuredCourse[
                                                                      index]
                                                                  .coursePrice)));
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                     CatelogueScreen()),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Container(
                                          width: width / 1.4,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.black26,
                                            //     offset: Offset(0, 2),
                                            //     blurRadius: 40,
                                            //   ),
                                            // ],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: width / 1.4,
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20)),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    imageUrl:
                                                        featuredCourse[index]
                                                            .courseImageUrl,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                padding: EdgeInsets.only(
                                                    top: 15, left: 5, right: 5),
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            child: StarRating(
                                                              length: 1,
                                                              rating: featuredCourse[
                                                                          index]
                                                                      .reviews
                                                                      .isNotEmpty
                                                                  ? double.parse(
                                                                      featuredCourse[
                                                                              index]
                                                                          .reviews)
                                                                  : 5.0,
                                                              color: HexColor(
                                                                  '31D198'),
                                                              starSize: 25,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            child: Container(
                                                              height: 20,
                                                              width: 40,
                                                              child: Center(
                                                                child: Text(
                                                                  featuredCourse[
                                                                              index]
                                                                          .reviews
                                                                          .isNotEmpty
                                                                      ? featuredCourse[
                                                                              index]
                                                                          .reviews
                                                                      : '5.0',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: HexColor(
                                                                          '585858'),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        featuredCourse[index]
                                                            .courseName,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              '2C2C2C'),
                                                          fontFamily: 'Medium',
                                                          fontSize: 14,
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Container(
                                                    height: 40,
                                                    width: 150,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            courseId =
                                                                featuredCourse[
                                                                        index]
                                                                    .courseDocumentId;
                                                          });

                                                          print(courseId);
                                                          if (featuredCourse[
                                                                  index]
                                                              .isItComboCourse) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ComboStore(
                                                                  trialCourse:
                                                                      featuredCourse[
                                                                              index]
                                                                          .trialCourse,
                                                                  courseP: featuredCourse[
                                                                          index]
                                                                      .coursePrice,
                                                                  id: index
                                                                      .toString(),
                                                                  cID: featuredCourse[
                                                                          index]
                                                                      .courseDocumentId,
                                                                  cName: featuredCourse[
                                                                          index]
                                                                      .courseName,
                                                                  image: featuredCourse[
                                                                          index]
                                                                      .courseImageUrl,
                                                                  courses: featuredCourse[
                                                                          index]
                                                                      .courses,
                                                                  courseName: featuredCourse[
                                                                          index]
                                                                      .courseName,
                                                                ),
                                                              ),
                                                            );
                                                          } else if (featuredCourse[
                                                                      index]
                                                                  .multiCombo ==
                                                              true) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => MultiComboFeatureScreen(
                                                                        cID: featuredCourse[index]
                                                                            .courseDocumentId,
                                                                        courseName:
                                                                            featuredCourse[index]
                                                                                .courseName,
                                                                        id: featuredCourse[index]
                                                                            .courseId,
                                                                        coursePrice:
                                                                            featuredCourse[index].coursePrice)));
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                           CatelogueScreen()),
                                                            );
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              HexColor(
                                                                  "8346E1"),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 15,
                                                                  left: 15),
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Text(
                                                          "Learn More",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                  return Container();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isShow != null && isShow == true
          ? FloatingActionButton.extended(
              elevation: 0,
              backgroundColor: Colors.white10,
              onPressed: _launchWhatsapp,

              label: Showcase(
                key: three!,
                description: 'Message us on whatsApp',
                disableDefaultTargetGestures: true,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fwp.png?alt=media&token=440772d5-f8fa-4a9c-8d3d-8d20456a0983'),
                  maxRadius: 30,
                ),
              ),
              // icon: Icon(Icons.call),
            )
          : SizedBox(),
    );
  }
}

// // ignore: import_of_legacy_library_into_null_safe
// import 'dart:math';
// import 'package:cloudyml_app2/combo/combo_course.dart';
// import 'package:cloudyml_app2/free_course.dart';
// import 'package:cloudyml_app2/module/pdf_course.dart';
// import 'package:cloudyml_app2/module/video_screen.dart';
// import 'package:cloudyml_app2/widgets/curriculam.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudyml_app2/Providers/UserProvider.dart';
// import 'package:cloudyml_app2/authentication/firebase_auth.dart';
// import 'package:cloudyml_app2/api/firebase_api.dart';
// import 'package:cloudyml_app2/catalogue_screen.dart';
// import 'package:cloudyml_app2/combo/combo_store.dart';
// import 'package:cloudyml_app2/home.dart';
// import 'package:cloudyml_app2/models/course_details.dart';
// import 'package:cloudyml_app2/pages/notificationpage.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:cloudyml_app2/store.dart';
// import 'package:flutter/material.dart';
// import 'package:cloudyml_app2/fun.dart';
// import 'package:cloudyml_app2/models/firebase_file.dart';
// import 'package:hive/hive.dart';
// import 'package:is_first_run/is_first_run.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// // import 'package:ribbon/ribbon.dart';
// import 'package:cloudyml_app2/globals.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:badges/badges.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'models/user_details.dart';
//
// class Home extends StatefulWidget {
//   Home({Key? key, required this.one, this.two, this.three}) : super(key: key);
//   GlobalKey? one;
//   GlobalKey? two;
//   GlobalKey? three;
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   late Future<List<FirebaseFile>> futureFiles;
//   List<Icon> list = [];
//
//   late ScrollController _controller;
//   final notificationBox = Hive.box('NotificationBox');
//
//   showNotification() async {
//     final provider = Provider.of<UserProvider>(context, listen: false);
//     if (notificationBox.isEmpty) {
//       notificationBox.put(1, {"count": 0});
//       provider
//           .showNotificationHomeScreen(notificationBox.values.first["count"]);
//     } else {
//       provider
//           .showNotificationHomeScreen(notificationBox.values.first["count"]);
//     }
//   }
//
//   List<dynamic> courses = [];
//
//   Map userMap = Map<String, dynamic>();
//
//   bool? load = true;
//
//   void fetchCourses() async {
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) {
//       setState(() {
//         courses = value.data()!['paidCourseNames'];
//         print("courses = ${courses}");
//         load = false;
//       });
//     });
//   }
//
//   // String? name = '';
//   // void getCourseName() async {
//   //   await FirebaseFirestore.instance
//   //       .collection('courses')
//   //       .doc(courseId)
//   //       .get()
//   //       .then((value) {
//   //     setState(() {
//   //       name = value.data()!['name'];
//   //       print('ufbufb--$name');
//   //     });
//   //   });
//   // }
//   void dbCheckerForPayInParts() async {
//     DocumentSnapshot userDocs = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
//     setState(() {
//       userMap = userDocs.data() as Map<String, dynamic>;
//       // whetherSubScribedToPayInParts =
//       //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
//     });
//   }
//
//   bool statusOfPayInParts(String id) {
//     if (!(userMap['payInPartsDetails'][id] == null)) {
//       if (userMap['payInPartsDetails'][id]['outStandingAmtPaid']) {
//         return false;
//       } else {
//         return true;
//       }
//     } else {
//       return false;
//     }
//   }
//
//   bool navigateToCatalogueScreen(String id) {
//     if (userMap['payInPartsDetails'][id] != null) {
//       final daysLeft = (DateTime.parse(
//           userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
//           .difference(DateTime.now())
//           .inDays);
//       print(daysLeft);
//       return daysLeft < 1;
//     } else {
//       return false;
//     }
//   }
//
//   bool isShow = false;
//
//   _wpshow() async {
//     await FirebaseFirestore.instance
//         .collection('Notice')
//         .doc('rLwaS5rDufmCQ7Gv5vMI')
//         .get()
//         .then((value) {
//       setState(() {
//         isShow = value.data()!['show'];
//       });
//
//       print("show is===$isShow");
//     });
//   }
//
//   _launchWhatsapp() async {
//     var note = await FirebaseFirestore.instance
//         .collection('Notice')
//         .doc('rLwaS5rDufmCQ7Gv5vMI')
//         .get()
//         .then((value) {
//       return value.data()!['msg']; // Access your after your get the data
//     });
//
//     print("the msg is====$note");
//     print("the show is====$isShow");
//
//     var whatsApp1 = await FirebaseFirestore.instance
//         .collection('Notice')
//         .doc('rLwaS5rDufmCQ7Gv5vMI')
//         .get()
//         .then((value) {
//       return value.data()!['number']; // Access your after your get the data
//     });
//
//     print("the number is====$whatsApp1");
//
//     var whatsapp = "+918902530551";
//     var whatsappAndroid =
//     Uri.parse("whatsapp://send?phone=$whatsApp1&text=$note");
//     if (await canLaunchUrl(whatsappAndroid)) {
//       await launchUrl(whatsappAndroid);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("WhatsApp is not installed on the device"),
//         ),
//       );
//     }
//   }
//
//   List<CourseDetails> featuredCourse = [];
//
//   setFeaturedCourse(List<CourseDetails> course) {
//     featuredCourse.clear();
//     course.forEach((element) {
//       if (element.FcSerialNumber.isNotEmpty &&
//           element.FcSerialNumber != null &&
//           element.isItComboCourse == true) {
//         featuredCourse.add(element);
//       }
//     });
//     featuredCourse.sort((a, b) {
//       return int.parse(a.FcSerialNumber).compareTo(int.parse(b.FcSerialNumber));
//     });
//   }
//
//   bool isAnnounceMent = false;
//   String announcementMsg = '';
//   void getAnnouncement() async {
//     await FirebaseFirestore.instance
//         .collection('Notice')
//         .doc('qdsnWW9NtIHwuFOGcuus_Annoucement')
//         .get()
//         .then((value) {
//       setState(() {
//         announcementMsg = value.data()!['Message'];
//         isAnnounceMent = value.data()!['show'];
//         // print("it is===$isAnnounceMent");
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     // getAnnouncement();
//     print("jogwjoijfowoe");
//     _wpshow();
//     fetchCourses();
//     dbCheckerForPayInParts();
//     // getCourseName();
//     showNotification();
//     //fire and forget to fetch the user course detail early
//     final UserDetails? userCourse =
//     Provider.of<UserDetails?>(context, listen: false);
//     _controller = ScrollController();
//     super.initState();
//     futureFiles = FirebaseApi.listAll('reviews/');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final providerNotification =
//     Provider.of<UserProvider>(context, listen: false);
//     final size = MediaQuery.of(context).size;
//     final height = size.height;
//     final width = size.width;
//     List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     var verticalScale = screenHeight / mockUpHeight;
//     var horizontalScale = screenWidth / mockUpWidth;
//     setFeaturedCourse(course);
//     getAnnouncement();
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: screenWidth,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       color: Color.fromRGBO(
//                         0,
//                         0,
//                         0,
//                         0.35,
//                       ),
//                       offset: Offset(5, 5),
//                       blurRadius: 52)
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     width: 414 * horizontalScale,
//                     height: 280 * verticalScale,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(15),
//                         bottomRight: Radius.circular(15),
//                       ),
//                       image: DecorationImage(
//                         alignment: Alignment.center,
//                         image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fh1.png?alt=media&token=5f70f964-0e8e-49fd-b4c6-4924ac18995a'),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       top: 30 * verticalScale,
//                       left: 10 * horizontalScale,
//                       child: Container(
//                         child: Row(
//                           children: [
//                             Showcase(
//                               key: widget.one!,
//                               description: 'Tap to see other menus',
//                               disableDefaultTargetGestures: true,
//                               child: IconButton(
//                                 onPressed: () {
//                                   Scaffold.of(context).openDrawer();
//                                 },
//                                 icon: Icon(
//                                   Icons.menu,
//                                   size:
//                                   30 * min(horizontalScale, verticalScale),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10 * horizontalScale,
//                             ),
//                             Text(
//                               'Home',
//                               textScaleFactor:
//                               min(horizontalScale, verticalScale),
//                               style: TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             )
//                           ],
//                         ),
//                       )),
//                   Positioned(
//                       top: 31 * verticalScale,
//                       right: 2 * horizontalScale,
//                       child: Consumer<UserProvider>(
//                         builder: (context, data, child) {
//                           return StreamBuilder(
//                               stream: FirebaseFirestore.instance
//                                   .collection("Notifications")
//                                   .snapshots(),
//                               builder: (context,
//                                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                                 //    print("-------------${notificationBox.values}");
//                                 if (snapshot.data!.docs.length <
//                                     data.countNotification) {
//                                   notificationBox.put(1,
//                                       {"count": (snapshot.data!.docs.length)});
//                                   providerNotification
//                                       .showNotificationHomeScreen(
//                                       notificationBox
//                                           .values.first["count"]);
//                                 }
//                                 return Showcase(
//                                   key: widget.two!,
//                                   description: 'Notifications comes here',
//                                   disableDefaultTargetGestures: true,
//                                   child: Badge(
//                                     showBadge: data.countNotification ==
//                                         snapshot.data!.docs.length ||
//                                         snapshot.data!.docs.length <
//                                             data.countNotification
//                                         ? false
//                                         : true,
//                                     child: IconButton(
//                                       onPressed: () async {
//                                         await Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   NotificationPage()),
//                                         );
//                                         await notificationBox.put(1, {
//                                           "count": (snapshot.data!.docs.length)
//                                         });
//                                         await providerNotification
//                                             .showNotificationHomeScreen(
//                                             notificationBox
//                                                 .values.first["count"]);
//                                         print(
//                                             "++++++++++++++++++++++++${notificationBox.values}");
//                                       },
//                                       icon: Icon(
//                                         Icons.notifications_active,
//                                         size: 30,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     badgeColor: Colors.red,
//                                     toAnimate: false,
//                                     badgeContent: Text(
//                                       snapshot.data!.docs.length -
//                                           notificationBox
//                                               .values.first["count"] >=
//                                           0
//                                           ? (snapshot.data!.docs.length -
//                                           notificationBox
//                                               .values.first["count"])
//                                           .toString()
//                                           : (notificationBox
//                                           .values.first["count"] -
//                                           snapshot.data!.docs.length)
//                                           .toString(),
//                                       style: TextStyle(
//                                           fontSize: 9,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     position: BadgePosition(
//                                       top: (2 -
//                                           2 *
//                                               (snapshot.data!.docs.length)
//                                                   .toString()
//                                                   .length) *
//                                           verticalScale,
//                                       end:
//                                       data.countNotification >= 100 ? 2 : 7,
//                                       // (7+((snapshot.data!.docs.length).toString().length))
//                                     ),
//                                   ),
//                                 );
//                               });
//                         },
//                       )),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: EdgeInsets.only(
//                   left: 20 * horizontalScale,
//                   top: 20 * verticalScale,
//                   bottom: 5),
//               child: Text(
//                 'What make us different?',
//                 textScaleFactor: min(horizontalScale, verticalScale),
//                 style: TextStyle(
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   fontFamily: 'Poppins',
//                   fontSize: 23,
//                   letterSpacing:
//                   0 /*percentages not used in flutter. defaulting to zero*/,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Container(
//               height: 130,
//               width: width,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: AssetImage(
//                       "assets/UII.png",
//                     )),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.082,
//                       top: 20,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 90,
//                         // width: (width-150)/4.2,
//                         width: width * 0.24,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           "100% industrial internship after course completion",
//                           style: TextStyle(
//                             fontSize: 8,
//                             fontFamily: 'Bold',
//                           ),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.18,
//                       top: 6.8,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 15,
//                         // width: (width-150)/4.2,
//                         width: 15,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: HexColor("#592CA4")),
//                         child: Text(
//                           "1",
//                           style: TextStyle(
//                               fontSize: 8,
//                               fontFamily: 'Bold',
//                               color: Colors.white),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.38,
//                       top: 20,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 90,
//                         // width: (width-150)/4.2,
//                         width: width * 0.24,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           "We provide \n hands on learning experience",
//                           style: TextStyle(
//                             fontSize: 8,
//                             fontFamily: 'Bold',
//                           ),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.48,
//                       top: 6.8,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 15,
//                         // width: (width-150)/4.2,
//                         width: 15,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: HexColor("#592CA4")),
//                         child: Text(
//                           "2",
//                           style: TextStyle(
//                               fontSize: 8,
//                               fontFamily: 'Bold',
//                               color: Colors.white),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.68,
//                       top: 19,
//                       // top:height* 0.018,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 90,
//                         // width: (width-150)/4.2,
//                         // height: height * 0.13,
//                         width: width * 0.24,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           "1-1 teaching assistants for doubt clearance",
//                           style: TextStyle(
//                             fontSize: 8,
//                             fontFamily: 'Bold',
//                           ),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                   Positioned(
//                     // left: (width-150)/12,
//                       left: width * 0.79,
//                       top: 6.8,
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 15,
//                         // width: (width-150)/4.2,
//                         width: 15,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: HexColor("#592CA4")),
//                         child: Text(
//                           "3",
//                           style: TextStyle(
//                               fontSize: 8,
//                               fontFamily: 'Bold',
//                               color: Colors.white),
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//
//             isAnnounceMent
//                 ? Padding(
//               padding: EdgeInsets.only(
//                   left: 20 * horizontalScale,
//                   right: 20 * horizontalScale,
//                   bottom: 4
//                 // top: 20 * verticalScale,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Announcements 📣',
//                     textScaleFactor: min(horizontalScale, verticalScale),
//                     style: TextStyle(
//                       color: Color.fromRGBO(0, 0, 0, 1),
//                       fontFamily: 'Poppins',
//                       fontSize: 23,
//                       letterSpacing:
//                       0 /*percentages not used in flutter. defaulting to zero*/,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(
//                       left: 10 * horizontalScale,
//                       right: 10 * horizontalScale,
//                       top: 15 * verticalScale,
//                       bottom: 15 * verticalScale,
//
//                       // top: 20 * verticalScale,
//                     ),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.deepPurple.withOpacity(0.12)),
//                     child: Center(
//                       child: Text(
//                         announcementMsg,
//                         style: TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//                 : SizedBox(),
//
//             SizedBox(
//               height: 10,
//             ),
//             courses.length > 0
//                 ? Padding(
//               padding:
//               EdgeInsets.only(left: 20 * horizontalScale, bottom: 4
//                 // top: 20 * verticalScale,
//               ),
//               child: Text(
//                 'My Courses',
//                 textScaleFactor: min(horizontalScale, verticalScale),
//                 style: TextStyle(
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   fontFamily: 'Poppins',
//                   fontSize: 23,
//                   letterSpacing:
//                   0 /*percentages not used in flutter. defaulting to zero*/,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             )
//                 : SizedBox(),
//             courses.length > 0
//                 ? Container(
//               width: width,
//               height: 130,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               margin: EdgeInsets.only(top: 2, bottom: 7, left: 10),
//               child: MediaQuery.removePadding(
//                 context: context,
//                 removeTop: true,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   // shrinkWrap: true,
//                   itemCount: course.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (course[index].courseName == "null") {
//                       return Container();
//                     }
//                     if (courses.contains(course[index].courseId)) {
//                       return InkWell(
//                         onTap: (() {
//                           // setModuleId(snapshot.data!.docs[index].id);
//                           // getCourseName();
//                           if (navigateToCatalogueScreen(
//                               course[index].courseId) &&
//                               !(userMap['payInPartsDetails']
//                               [course[index].courseId]
//                               ['outStandingAmtPaid'])) {
//                             if (!course[index].isItComboCourse) {
//                               Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   duration: Duration(milliseconds: 400),
//                                   curve: Curves.bounceInOut,
//                                   type: PageTransitionType
//                                       .rightToLeftWithFade,
//                                   child: VideoScreen(
//                                     isdemo: true,
//                                     courseName: course[index].courseName,
//                                     sr: 1,
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   duration: Duration(milliseconds: 100),
//                                   curve: Curves.bounceInOut,
//                                   type: PageTransitionType
//                                       .rightToLeftWithFade,
//                                   child: ComboStore(
//                                     courses: course[index].courses,
//                                   ),
//                                 ),
//                               );
//                             }
//                           } else {
//                             if (!course[index].isItComboCourse) {
//                               if (course[index].courseContent == 'pdf') {
//                                 Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     duration: Duration(milliseconds: 400),
//                                     curve: Curves.bounceInOut,
//                                     type: PageTransitionType
//                                         .rightToLeftWithFade,
//                                     child: PdfCourseScreen(
//                                       curriculum: course[index].curriculum
//                                       as Map<String, dynamic>,
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 Navigator.push(
//                                   context,
//                                   PageTransition(
//                                     duration: Duration(milliseconds: 400),
//                                     curve: Curves.bounceInOut,
//                                     type: PageTransitionType
//                                         .rightToLeftWithFade,
//                                     child: VideoScreen(
//                                       isdemo: true,
//                                       courseName:
//                                       course[index].courseName,
//                                       sr: 1,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               ComboCourse.comboId.value =
//                                   course[index].courseId;
//                               Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   duration: Duration(milliseconds: 400),
//                                   curve: Curves.bounceInOut,
//                                   type: PageTransitionType
//                                       .rightToLeftWithFade,
//                                   child: ComboCourse(
//                                     courses: course[index].courses,
//                                   ),
//                                 ),
//                               );
//                             }
//                           }
//                           setState(() {
//                             courseId = course[index].courseDocumentId;
//                           });
//                         }),
//                         child: Container(
//                             height: 150,
//                             width: 320,
//                             margin: EdgeInsets.only(right: 10),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Color(0xFFE9E1FC)),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     width: 200,
//                                     height: 150,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                         BorderRadius.circular(5)),
//                                     child: Container(
//                                       margin: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10),
//                                           bottomLeft: Radius.circular(10),
//                                           bottomRight:
//                                           Radius.circular(10),
//                                         ),
//                                         image: DecorationImage(
//                                             image:
//                                             CachedNetworkImageProvider(
//                                               course[index]
//                                                   .courseImageUrl,
//                                             ),
//                                             fit: BoxFit.fitHeight),
//                                       ),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                     child: Container(
//                                         width: 200,
//                                         height: 150,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(
//                                                 10)),
//                                         child: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment
//                                                 .spaceEvenly,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               course[index]
//                                                   .isItComboCourse
//                                                   ? Row(
//                                                 children: [
//                                                   Container(
//                                                     width: 70,
//                                                     height: 37,
//                                                     decoration:
//                                                     BoxDecoration(
//                                                       borderRadius:
//                                                       BorderRadius
//                                                           .circular(
//                                                           10),
//                                                       // gradient: gradient,
//                                                       color: Color(
//                                                           0xFF7860DC),
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         'COMBO',
//                                                         style:
//                                                         const TextStyle(
//                                                           fontFamily:
//                                                           'Bold',
//                                                           fontSize:
//                                                           10,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500,
//                                                           color: Colors
//                                                               .white,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               )
//                                                   : Container(),
//                                               Container(
//                                                 child: Text(
//                                                   course[index]
//                                                       .courseName,
//                                                   style: TextStyle(
//                                                       color:
//                                                       Color.fromRGBO(
//                                                         0,
//                                                         0,
//                                                         0,
//                                                         1,
//                                                       ),
//                                                       fontFamily:
//                                                       'Poppins',
//                                                       fontSize: 13,
//                                                       letterSpacing:
//                                                       0 /*percentages not used in flutter. defaulting to zero*/,
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       height: 1,
//                                                       overflow:
//                                                       TextOverflow
//                                                           .ellipsis),
//                                                   // overflow: TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                 ),
//                                               ),
//                                               course[index]
//                                                   .isItComboCourse &&
//                                                   statusOfPayInParts(
//                                                       course[index]
//                                                           .courseId)
//                                                   ? Container(
//                                                 child: !navigateToCatalogueScreen(
//                                                     course[index]
//                                                         .courseId)
//                                                     ? Container(
//                                                   height: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                       0.08 *
//                                                       verticalScale,
//                                                   decoration:
//                                                   BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(
//                                                       10,
//                                                     ),
//                                                     color:
//                                                     Color(
//                                                       0xFFC0AAF5,
//                                                     ),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceEvenly,
//                                                     children: [
//                                                       SizedBox(
//                                                         width:
//                                                         10,
//                                                       ),
//                                                       Text(
//                                                         'Access ends in days : ',
//                                                         textScaleFactor: min(
//                                                             horizontalScale,
//                                                             verticalScale),
//                                                         style:
//                                                         TextStyle(
//                                                           color:
//                                                           Colors.white,
//                                                           fontSize:
//                                                           13,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                       Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.circular(10),
//                                                           color:
//                                                           Colors.grey.shade100,
//                                                         ),
//                                                         width:
//                                                         30 * min(horizontalScale, verticalScale),
//                                                         height:
//                                                         30 * min(horizontalScale, verticalScale),
//                                                         // color:
//                                                         //     Color(0xFFaefb2a),
//                                                         child:
//                                                         Center(
//                                                           child:
//                                                           Text(
//                                                             '${(DateTime.parse(userMap['payInPartsDetails'][course[index].courseId]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
//                                                             textScaleFactor: min(horizontalScale, verticalScale),
//                                                             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
//                                                               // fontSize: 16,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                                     : Container(
//                                                   height: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                       0.08,
//                                                   decoration:
//                                                   BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10),
//                                                     color: Color(
//                                                         0xFFC0AAF5),
//                                                   ),
//                                                   child:
//                                                   Center(
//                                                     child:
//                                                     Text(
//                                                       'Limited access expired !',
//                                                       textScaleFactor: min(
//                                                           horizontalScale,
//                                                           verticalScale),
//                                                       style:
//                                                       TextStyle(
//                                                         color:
//                                                         Colors.deepOrange[600],
//                                                         fontSize:
//                                                         13,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                                   : SizedBox(),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .start,
//                                                 children: [
//                                                   Container(
//                                                     child: Text(
//                                                       course[index]
//                                                           .courseLanguage +
//                                                           "  ||",
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'Medium',
//                                                           color: Colors
//                                                               .black
//                                                               .withOpacity(
//                                                               0.4),
//                                                           fontSize: 10,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 6,
//                                                   ),
//                                                   Container(
//                                                     child: Center(
//                                                       child: Text(
//                                                         '${course[index].numOfVideos} videos',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                             'Medium',
//                                                             color: Colors
//                                                                 .black
//                                                                 .withOpacity(
//                                                                 0.7),
//                                                             fontSize: 10),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ])))
//                               ],
//                             )),
//                       );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
//               ),
//             )
//                 : SizedBox(),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 20 * horizontalScale,
//                 // top: 20 * verticalScale,
//               ),
//               child: Text(
//                 'Feature Courses',
//                 textScaleFactor: min(horizontalScale, verticalScale),
//                 style: TextStyle(
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   fontFamily: 'Poppins',
//                   fontSize: 23,
//                   letterSpacing:
//                   0 /*percentages not used in flutter. defaulting to zero*/,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Container(
//               width: screenWidth,
//               height: 190,
//               margin: EdgeInsets.only(top: 10, bottom: 5),
//               child: MediaQuery.removePadding(
//                 context: context,
//                 removeTop: true,
//                 removeBottom: true,
//                 removeLeft: true,
//                 removeRight: true,
//                 child: ListView.builder(
//                   // physics: NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   itemCount: featuredCourse.length,
//                   itemBuilder: (BuildContext context, index) {
//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           courseId = featuredCourse[index].courseDocumentId;
//                         });
//
//                         print(courseId);
//                         if (featuredCourse[index].isItComboCourse) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ComboStore(
//                                 courses: featuredCourse[index].courses,
//                               ),
//                             ),
//                           );
//                         } else {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const CatelogueScreen()),
//                           );
//                         }
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: [
//                               HexColor("#2C004F"),
//                               HexColor("#8024C9")
//                             ]),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: HexColor("#8024C9"),
//                                 blurRadius: 1.5, offset: Offset(1, 2),
//                                 // spreadRadius: 0.3
//                               )
//                             ],
//                             borderRadius: BorderRadius.circular(20)),
//                         margin: EdgeInsets.only(left: 15, top: 5, bottom: 5),
//                         padding: EdgeInsets.only(
//                             left: 15, right: 5, top: 15, bottom: 15),
//                         width: 300,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Padding(
//                                 padding: EdgeInsets.only(right: 10),
//                                 child: Text(
//                                     "${featuredCourse[index].courseName}",
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         overflow: TextOverflow.ellipsis,
//                                         fontFamily: 'Bold'),
//                                     maxLines: 1),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 8,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     flex: 5,
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           child: SizedBox(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment
//                                                         .center,
//                                                     children: [
//                                                       RatingBarIndicator(
//                                                         rating: 5.0,
//                                                         itemBuilder:
//                                                             (context, index) =>
//                                                             Icon(
//                                                               Icons.star,
//                                                               color: HexColor(
//                                                                   "#31D198"),
//                                                             ),
//                                                         itemCount: 5,
//                                                         itemSize: 15.0,
//                                                         direction:
//                                                         Axis.horizontal,
//                                                         unratedColor:
//                                                         Colors.purple,
//                                                       ),
//                                                       SizedBox(
//                                                         width: 10,
//                                                       ),
//                                                       Text(
//                                                         "5.0",
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 13),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                     child: Text(
//                                                       "English  ||  ${featuredCourse[index].numOfVideos} Videos",
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           color: Colors.white),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 8,
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             children: [
//                                               Expanded(
//                                                   child: Align(
//                                                     alignment: Alignment.topLeft,
//                                                     child: RichText(
//                                                       text: TextSpan(children: [
//                                                         // TextSpan(text:"3599/-  ",style: TextStyle(color: Colors.white,fontSize: 16,overflow: TextOverflow.ellipsis),),
//                                                         TextSpan(
//                                                           text:
//                                                           "₹${featuredCourse[index].coursePrice}/-",
//                                                           style: TextStyle(
//                                                               color: Colors.white,
//                                                               fontWeight:
//                                                               FontWeight.bold,
//                                                               fontFamily: 'Poppins',
//                                                               fontSize: 20,
//                                                               overflow: TextOverflow
//                                                                   .ellipsis),
//                                                         )
//                                                       ]),
//                                                     ),
//                                                   )),
//                                               Expanded(
//                                                 child: Align(
//                                                   alignment:
//                                                   Alignment.bottomLeft,
//                                                   child: ElevatedButton(
//                                                     style: ButtonStyle(
//                                                         backgroundColor:
//                                                         MaterialStateProperty
//                                                             .all(HexColor(
//                                                             "#2FBF8B")),
//                                                         shape: MaterialStateProperty
//                                                             .all<
//                                                             RoundedRectangleBorder>(
//                                                           RoundedRectangleBorder(
//                                                             borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                 18.0),
//                                                           ),
//                                                         )),
//                                                     onPressed: () async {
//                                                       print("Curriculum");
//                                                       setState(() {
//                                                         courseId = featuredCourse[
//                                                         index]
//                                                             .courseDocumentId;
//                                                       });
//                                                       // print(await course[index].curriculum);
//                                                       // await Navigator.push(
//                                                       //   context,
//                                                       //   MaterialPageRoute(
//                                                       //     builder: (context) => Curriculam(courseDetail: course[index])
//                                                       //   ),
//                                                       // );
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                           const CatelogueScreen(),
//                                                         ),
//                                                       );
//                                                     },
//                                                     child: Text(
//                                                       "Enroll now",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontFamily: 'Regular',
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           fontSize: 14),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 4,
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           child: ClipRRect(
//                                             borderRadius:
//                                             BorderRadius.circular(15),
//                                             child: CachedNetworkImage(
//                                               imageUrl:
//                                               course[index].courseImageUrl,
//                                               placeholder: (context, url) =>
//                                                   Center(
//                                                     child:
//                                                     CircularProgressIndicator(),
//                                                     heightFactor: 30,
//                                                     widthFactor: 30,
//                                                   ),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                   Icon(Icons.error),
//                                               fit: BoxFit.fill,
//                                               height: 100 * verticalScale,
//                                               width: 127 * horizontalScale,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       // Padding(
//                       //   padding: EdgeInsets.only(
//                       //     left: 15,
//                       //     right: 15,
//                       //     top: 15,
//                       //   ),
//                       //   child: Container(
//                       //     width: 366 * horizontalScale,
//                       //     height: 122 * verticalScale,
//                       //     decoration: BoxDecoration(
//                       //       borderRadius: BorderRadius.only(
//                       //         topLeft: Radius.circular(15),
//                       //         topRight: Radius.circular(15),
//                       //         bottomLeft: Radius.circular(15),
//                       //         bottomRight: Radius.circular(15),
//                       //       ),
//                       //       boxShadow: [
//                       //         BoxShadow(
//                       //             color: Color.fromRGBO(31, 31, 31, 0.2),
//                       //             offset: Offset(0, 10),
//                       //             blurRadius: 20)
//                       //       ],
//                       //       color: Color.fromRGBO(255, 255, 255, 1),
//                       //     ),
//                       //     child: Row(
//                       //       children: [
//                       //         SizedBox(
//                       //           width: 5,
//                       //         ),
//                       //         ClipRRect(
//                       //           borderRadius: BorderRadius.circular(15),
//                       //           child: CachedNetworkImage(
//                       //             imageUrl: course[index].courseImageUrl,
//                       //             placeholder: (context, url) =>
//                       //                 CircularProgressIndicator(),
//                       //             errorWidget: (context, url, error) =>
//                       //                 Icon(Icons.error),
//                       //             fit: BoxFit.fill,
//                       //             height: 100 * verticalScale,
//                       //             width: 127 * horizontalScale,
//                       //           ),
//                       //         ),
//                       //         SizedBox(
//                       //           width: 10,
//                       //         ),
//                       //         Column(
//                       //           crossAxisAlignment: CrossAxisAlignment.start,
//                       //           children: [
//                       //             SizedBox(
//                       //               height: 10 * verticalScale,
//                       //             ),
//                       //             Container(
//                       //               width: 194,
//                       //               child: Text(
//                       //                 course[index].courseName,
//                       //                 textScaleFactor:
//                       //                     min(horizontalScale, verticalScale),
//                       //                 textAlign: TextAlign.left,
//                       //                 style: TextStyle(
//                       //                   color: Color.fromRGBO(0, 0, 0, 1),
//                       //                   fontFamily: 'Poppins',
//                       //                   fontSize: 18,
//                       //                   letterSpacing: 0,
//                       //                   fontWeight: FontWeight.bold,
//                       //                   height: 1,
//                       //                 ),
//                       //               ),
//                       //             ),
//                       //             SizedBox(
//                       //               height: 20 * verticalScale,
//                       //             ),
//                       //             Image.asset(
//                       //               'assets/Rating.png',
//                       //               fit: BoxFit.fill,
//                       //               height: 11,
//                       //               width: 71,
//                       //             ),
//                       //             SizedBox(
//                       //               height: 20 * verticalScale,
//                       //             ),
//                       //             Row(
//                       //               children: [
//                       //                 Text(
//                       //                   'English  ||  ${course[index].numOfVideos} Videos',
//                       //                   textAlign: TextAlign.left,
//                       //                   textScaleFactor: min(
//                       //                       horizontalScale, verticalScale),
//                       //                   style: TextStyle(
//                       //                       color:
//                       //                           Color.fromRGBO(88, 88, 88, 1),
//                       //                       fontFamily: 'Poppins',
//                       //                       fontSize: 12,
//                       //                       letterSpacing:
//                       //                           0 /*percentages not used in flutter. defaulting to zero*/,
//                       //                       fontWeight: FontWeight.normal,
//                       //                       height: 1),
//                       //                 ),
//                       //                 SizedBox(
//                       //                   width: 20,
//                       //                 ),
//                       //                 Text(
//                       //                   course[index].coursePrice,
//                       //                   textScaleFactor: min(
//                       //                       horizontalScale, verticalScale),
//                       //                   textAlign: TextAlign.left,
//                       //                   style: TextStyle(
//                       //                       color: Color.fromRGBO(
//                       //                           155, 117, 237, 1),
//                       //                       fontFamily: 'Poppins',
//                       //                       fontSize: 18,
//                       //                       letterSpacing:
//                       //                           0 /*percentages not used in flutter. defaulting to zero*/,
//                       //                       fontWeight: FontWeight.bold,
//                       //                       height: 1),
//                       //                 ),
//                       //               ],
//                       //             ),
//                       //           ],
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                     );
//                     // if (course[index].FcSerialNumber != '') {
//                     //
//                     //
//                     //
//                     //
//                     //    return course[index].isItComboCourse?
//                     //   InkWell(
//                     //     onTap: () {
//                     //       setState(() {
//                     //         courseId = course[index].courseDocumentId;
//                     //       });
//                     //
//                     //       print(courseId);
//                     //       if (course[index].isItComboCourse) {
//                     //         Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //             builder: (context) => ComboStore(
//                     //               courses: course[index].courses,
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //               builder: (context) =>
//                     //                   const CatelogueScreen()),
//                     //         );
//                     //       }
//                     //     },
//                     //     child:
//                     //     Container(
//                     //       decoration: BoxDecoration(
//                     //           gradient: LinearGradient(
//                     //               colors: [
//                     //                 HexColor("#2C004F"),
//                     //                 HexColor("#8024C9")
//                     //               ]
//                     //           ),
//                     //           boxShadow: [
//                     //             BoxShadow(color: HexColor("#8024C9"),
//                     //                 blurRadius: 1.5,offset: Offset(1,2) ,
//                     //                 // spreadRadius: 0.3
//                     //             )
//                     //           ],
//                     //           borderRadius: BorderRadius.circular(20)
//                     //       ),
//                     //       margin: EdgeInsets.only(left: 15,top: 5,bottom: 5),
//                     //       padding: EdgeInsets.only(left: 15,right: 5,top: 15,bottom: 15),
//                     //       width: 300,
//                     //       child: Column(
//                     //         mainAxisAlignment: MainAxisAlignment.center,
//                     //         crossAxisAlignment: CrossAxisAlignment.start,
//                     //         children: [
//                     //           Expanded(
//                     //             flex: 2,
//                     //             child: Padding(
//                     //               padding: EdgeInsets.only(right: 10),
//                     //               child: Text("${course[index].courseName}",
//                     //                   style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontFamily: 'Bold'),
//                     //                   maxLines: 1),
//                     //             ),
//                     //           ),
//                     //           Expanded(
//                     //             flex: 8,
//                     //             child: Row(
//                     //               children: [
//                     //                 Expanded(
//                     //                   flex: 5,
//                     //                   child: Column(
//                     //                     children: [
//                     //                       Expanded(
//                     //                         child: SizedBox(
//                     //                           child: Column(
//                     //                             crossAxisAlignment: CrossAxisAlignment.start,
//                     //                             children: [
//                     //                               Expanded(
//                     //                                 child:
//                     //                                 Row(
//                     //                                   crossAxisAlignment: CrossAxisAlignment.center,
//                     //                                   children: [
//                     //                                     RatingBarIndicator(
//                     //                                       rating: 5.0,
//                     //                                       itemBuilder: (context, index) => Icon(
//                     //                                         Icons.star,
//                     //                                         color: HexColor("#31D198"),
//                     //                                       ),
//                     //                                       itemCount: 5,
//                     //                                       itemSize: 15.0,
//                     //                                       direction: Axis.horizontal,
//                     //                                       unratedColor: Colors.purple,
//                     //                                     ),
//                     //                                     SizedBox(width: 10,),
//                     //                                     Text("5.0",style: TextStyle(color: Colors.white,fontSize: 13),)
//                     //                                   ],
//                     //                                 ),
//                     //                               ),
//                     //                               Expanded(child:   Text("English  ||  ${course[index].numOfVideos} Videos",style: TextStyle(fontSize: 13,color: Colors.white),)
//                     //                               )
//                     //                             ],
//                     //                           ),
//                     //                         ),
//                     //                       ),
//                     //                       SizedBox(height: 8,),
//                     //                       Expanded(
//                     //                         child: Column(
//                     //                           children: [
//                     //                             Expanded(
//                     //                                 child: Align(
//                     //                                   alignment: Alignment.topLeft,
//                     //                                   child: RichText(
//                     //                                     text: TextSpan(
//                     //                                         children: [
//                     //                                           // TextSpan(text:"3599/-  ",style: TextStyle(color: Colors.white,fontSize: 16,overflow: TextOverflow.ellipsis),),
//                     //                                           TextSpan(text:"₹${course[index].coursePrice}/-",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
//                     //                                               fontFamily: 'Poppins',fontSize: 20,
//                     //                                               overflow: TextOverflow.ellipsis),)
//                     //                                         ]
//                     //                                     ),
//                     //                                   ),
//                     //                                 )
//                     //                             ),
//                     //                             Expanded(
//                     //                               child: Align(
//                     //                                 alignment: Alignment.bottomLeft,
//                     //                                 child: ElevatedButton(
//                     //                                   style: ButtonStyle(
//                     //                                       backgroundColor: MaterialStateProperty.all(HexColor("#2FBF8B")),
//                     //                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     //                                         RoundedRectangleBorder(
//                     //                                           borderRadius: BorderRadius.circular(18.0),
//                     //                                         ),
//                     //                                       )
//                     //                                   ),
//                     //                                   onPressed: ()async{
//                     //                                     print("Curriculum");
//                     //                                     setState(() {
//                     //                                       courseId = course[index].courseDocumentId;
//                     //                                     });
//                     //                                     // print(await course[index].curriculum);
//                     //                                     // await Navigator.push(
//                     //                                     //   context,
//                     //                                     //   MaterialPageRoute(
//                     //                                     //     builder: (context) => Curriculam(courseDetail: course[index])
//                     //                                     //   ),
//                     //                                     // );
//                     //                                     Navigator.push(
//                     //                                       context,
//                     //                                       MaterialPageRoute(
//                     //                                         builder: (context) =>
//                     //                                         const CatelogueScreen(),
//                     //                                       ),
//                     //                                     );
//                     //                                   },
//                     //                                   child: Text("Enroll now",style: TextStyle(color: Colors.white,fontFamily: 'Regular',
//                     //                                   fontWeight: FontWeight.bold,fontSize: 14),),
//                     //                                 ),
//                     //                               ),
//                     //                             )
//                     //                           ],
//                     //                         ),
//                     //
//                     //                       )
//                     //                     ],
//                     //                   ),
//                     //                 ),
//                     //                 Expanded(
//                     //                   flex: 4,
//                     //                   child: Column(
//                     //                     children: [
//                     //                       Expanded(
//                     //                         child: ClipRRect(
//                     //                  borderRadius: BorderRadius.circular(15),
//                     //                   child: CachedNetworkImage(
//                     //                   imageUrl: course[index].courseImageUrl,
//                     //             placeholder: (context, url) =>
//                     //                 Center(child: CircularProgressIndicator(),
//                     //                  heightFactor: 30,
//                     //                     widthFactor: 30,),
//                     //             errorWidget: (context, url, error) =>
//                     //                 Icon(Icons.error),
//                     //             fit: BoxFit.fill,
//                     //             height: 100 * verticalScale,
//                     //             width: 127 * horizontalScale,
//                     //           ),
//                     //         ),
//                     //                       ),
//                     //
//                     //                     ],
//                     //                   ),
//                     //                 )
//                     //               ],
//                     //             ),
//                     //           )
//                     //         ],
//                     //       ),
//                     //     ),
//                     //     // Padding(
//                     //     //   padding: EdgeInsets.only(
//                     //     //     left: 15,
//                     //     //     right: 15,
//                     //     //     top: 15,
//                     //     //   ),
//                     //     //   child: Container(
//                     //     //     width: 366 * horizontalScale,
//                     //     //     height: 122 * verticalScale,
//                     //     //     decoration: BoxDecoration(
//                     //     //       borderRadius: BorderRadius.only(
//                     //     //         topLeft: Radius.circular(15),
//                     //     //         topRight: Radius.circular(15),
//                     //     //         bottomLeft: Radius.circular(15),
//                     //     //         bottomRight: Radius.circular(15),
//                     //     //       ),
//                     //     //       boxShadow: [
//                     //     //         BoxShadow(
//                     //     //             color: Color.fromRGBO(31, 31, 31, 0.2),
//                     //     //             offset: Offset(0, 10),
//                     //     //             blurRadius: 20)
//                     //     //       ],
//                     //     //       color: Color.fromRGBO(255, 255, 255, 1),
//                     //     //     ),
//                     //     //     child: Row(
//                     //     //       children: [
//                     //     //         SizedBox(
//                     //     //           width: 5,
//                     //     //         ),
//                     //     //         ClipRRect(
//                     //     //           borderRadius: BorderRadius.circular(15),
//                     //     //           child: CachedNetworkImage(
//                     //     //             imageUrl: course[index].courseImageUrl,
//                     //     //             placeholder: (context, url) =>
//                     //     //                 CircularProgressIndicator(),
//                     //     //             errorWidget: (context, url, error) =>
//                     //     //                 Icon(Icons.error),
//                     //     //             fit: BoxFit.fill,
//                     //     //             height: 100 * verticalScale,
//                     //     //             width: 127 * horizontalScale,
//                     //     //           ),
//                     //     //         ),
//                     //     //         SizedBox(
//                     //     //           width: 10,
//                     //     //         ),
//                     //     //         Column(
//                     //     //           crossAxisAlignment: CrossAxisAlignment.start,
//                     //     //           children: [
//                     //     //             SizedBox(
//                     //     //               height: 10 * verticalScale,
//                     //     //             ),
//                     //     //             Container(
//                     //     //               width: 194,
//                     //     //               child: Text(
//                     //     //                 course[index].courseName,
//                     //     //                 textScaleFactor:
//                     //     //                     min(horizontalScale, verticalScale),
//                     //     //                 textAlign: TextAlign.left,
//                     //     //                 style: TextStyle(
//                     //     //                   color: Color.fromRGBO(0, 0, 0, 1),
//                     //     //                   fontFamily: 'Poppins',
//                     //     //                   fontSize: 18,
//                     //     //                   letterSpacing: 0,
//                     //     //                   fontWeight: FontWeight.bold,
//                     //     //                   height: 1,
//                     //     //                 ),
//                     //     //               ),
//                     //     //             ),
//                     //     //             SizedBox(
//                     //     //               height: 20 * verticalScale,
//                     //     //             ),
//                     //     //             Image.asset(
//                     //     //               'assets/Rating.png',
//                     //     //               fit: BoxFit.fill,
//                     //     //               height: 11,
//                     //     //               width: 71,
//                     //     //             ),
//                     //     //             SizedBox(
//                     //     //               height: 20 * verticalScale,
//                     //     //             ),
//                     //     //             Row(
//                     //     //               children: [
//                     //     //                 Text(
//                     //     //                   'English  ||  ${course[index].numOfVideos} Videos',
//                     //     //                   textAlign: TextAlign.left,
//                     //     //                   textScaleFactor: min(
//                     //     //                       horizontalScale, verticalScale),
//                     //     //                   style: TextStyle(
//                     //     //                       color:
//                     //     //                           Color.fromRGBO(88, 88, 88, 1),
//                     //     //                       fontFamily: 'Poppins',
//                     //     //                       fontSize: 12,
//                     //     //                       letterSpacing:
//                     //     //                           0 /*percentages not used in flutter. defaulting to zero*/,
//                     //     //                       fontWeight: FontWeight.normal,
//                     //     //                       height: 1),
//                     //     //                 ),
//                     //     //                 SizedBox(
//                     //     //                   width: 20,
//                     //     //                 ),
//                     //     //                 Text(
//                     //     //                   course[index].coursePrice,
//                     //     //                   textScaleFactor: min(
//                     //     //                       horizontalScale, verticalScale),
//                     //     //                   textAlign: TextAlign.left,
//                     //     //                   style: TextStyle(
//                     //     //                       color: Color.fromRGBO(
//                     //     //                           155, 117, 237, 1),
//                     //     //                       fontFamily: 'Poppins',
//                     //     //                       fontSize: 18,
//                     //     //                       letterSpacing:
//                     //     //                           0 /*percentages not used in flutter. defaulting to zero*/,
//                     //     //                       fontWeight: FontWeight.bold,
//                     //     //                       height: 1),
//                     //     //                 ),
//                     //     //               ],
//                     //     //             ),
//                     //     //           ],
//                     //     //         ),
//                     //     //       ],
//                     //     //     ),
//                     //     //   ),
//                     //     // ),
//                     //   ):SizedBox();
//                     // } else {
//                     //   return Container();
//                     // }
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 20,
//                 top: 10,
//               ),
//               child: Text(
//                 'Success Stories',
//                 textScaleFactor: min(horizontalScale, verticalScale),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Color.fromRGBO(0, 0, 0, 1),
//                     fontFamily: 'Poppins',
//                     fontSize: 23,
//                     letterSpacing:
//                     0 /*percentages not used in flutter. defaulting to zero*/,
//                     fontWeight: FontWeight.w500,
//                     height: 1),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               // height: screenHeight * 0.81 * verticalScale,
//               height: 200,
//               width: screenWidth,
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: FutureBuilder<List<FirebaseFile>>(
//                 future: futureFiles,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return Center(child: CircularProgressIndicator());
//                     default:
//                       if (snapshot.hasError) {
//                         return Center(
//                             child: Text(
//                               'Some error occurred!',
//                               textScaleFactor: min(horizontalScale, verticalScale),
//                             ));
//                       } else {
//                         final files = snapshot.data!;
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 // physics: NeverScrollableScrollPhysics(),
//                                 itemCount: files.length,
//                                 itemBuilder: (context, index) {
//                                   final file = files[index];
//                                   return Container(
//                                       decoration: BoxDecoration(
//                                           color: HexColor("#FFFFFF"),
//                                           borderRadius:
//                                           BorderRadius.circular(15),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey,
//                                                 blurRadius: 5,
//                                                 offset: Offset(0, 1))
//                                           ]),
//                                       margin: EdgeInsets.only(
//                                           left: 15, top: 5, bottom: 5),
//                                       padding: EdgeInsets.only(
//                                           left: 15,
//                                           right: 15,
//                                           top: 12,
//                                           bottom: 10),
//                                       height: 200,
//                                       width: 300,
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(20),
//                                         child: CachedNetworkImage(
//                                           placeholder: (context, url) => Center(
//                                               child:
//                                               CircularProgressIndicator()),
//                                           errorWidget: (context, url, error) =>
//                                               Icon(Icons.error),
//                                           imageUrl: file.url,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     // Column(
//                                     //   mainAxisAlignment: MainAxisAlignment.center,
//                                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                                     //   children: [
//                                     //     Expanded(
//                                     //       flex:3,
//                                     //       child: Row(
//                                     //         children: [
//                                     //           Expanded(
//                                     //             flex: 2,
//                                     //             child: ClipRRect(
//                                     //               borderRadius: BorderRadius.circular(20),
//                                     //               child: CachedNetworkImage(
//                                     //                 placeholder: (context, url) => CircularProgressIndicator(),
//                                     //                 errorWidget: (context, url, error) => Icon(Icons.error),
//                                     //                 imageUrl: file.url,
//                                     //                 fit: BoxFit.cover,
//                                     //               ),
//                                     //             ),
//                                     //           ),
//                                     //           SizedBox(width: 5,),
//                                     //           Expanded(
//                                     //             flex: 4,
//                                     //             child: Column(
//                                     //               crossAxisAlignment: CrossAxisAlignment.start,
//                                     //               mainAxisAlignment: MainAxisAlignment.center,
//                                     //               children: [
//                                     //                 Text("Srinivas",style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis,
//                                     //                 fontWeight: FontWeight.bold),),
//                                     //                 Text("Data scientist@gmail.com",style: TextStyle(fontSize: 11,overflow: TextOverflow.ellipsis),),
//                                     //                 SizedBox(height: 5,),
//                                     //                 Row(
//                                     //                   children: [
//                                     //                     RatingBarIndicator(
//                                     //                       rating: 5.0,
//                                     //                       itemBuilder: (context, index) => Icon(
//                                     //                         Icons.star,
//                                     //                         color: HexColor("#2FBF8B"),
//                                     //                       ),
//                                     //                       itemCount: 5,
//                                     //                       itemSize: 13.0,
//                                     //                       direction: Axis.horizontal,
//                                     //                       unratedColor: Colors.purple,
//                                     //                     ),
//                                     //                     SizedBox(width: 10,),
//                                     //                     Text("5.0",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
//                                     //                   ],
//                                     //                 )
//                                     //               ],
//                                     //             ),
//                                     //           )
//                                     //         ],
//                                     //       ),
//                                     //     ),
//                                     //     SizedBox(height: 5,),
//                                     //     Expanded(
//                                     //         flex: 5,
//                                     //         child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's"
//                                     //             "standard dummy text ever since the 1500s, when an"
//                                     //             "unknown printer took a galley of type and scrambled it"
//                                     //             "to make a type specimen book. It has survived not only"
//                                     //             "five centuries, but also the leap into electronic typesetting,"
//                                     //             "remaining essentially unchanged. It was popularised in the. ",style: TextStyle(
//                                     //             overflow: TextOverflow.ellipsis,color: Colors.black,
//                                     //             fontSize: 12
//                                     //         ),maxLines: 6,)
//                                     //     )
//                                     //   ],
//                                     // ),
//                                   );
//                                   // buildFile(context, file);
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//                   }
//                 },
//               ),
//             ),
//             //SizedBox(height: 15,),
//             Container(
//               width: 414 * horizontalScale,
//               height: 250 * verticalScale,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   alignment: Alignment.center,
//                   image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fhomeimage2.png?alt=media&token=24573796-2d61-44e1-92ce-91c77f4714fc'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 20,
//                 top: 20,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'About Me',
//                     textScaleFactor: min(horizontalScale, verticalScale),
//                     style: TextStyle(
//                         color: Color.fromRGBO(0, 0, 0, 1),
//                         fontFamily: 'Poppins',
//                         fontSize: 25,
//                         letterSpacing:
//                         0 /*percentages not used in flutter. defaulting to zero*/,
//                         fontWeight: FontWeight.w500,
//                         height: 1),
//                   ),
//                   Container(
//                     width: 60 * horizontalScale,
//                     child: Divider(
//                         color: Color.fromRGBO(156, 91, 255, 1), thickness: 2),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
//               child: Text(
//                 'I have transitioned my career from Manual Tester to Data Scientist by upskilling myself on my own from various online resources and doing lots of Hands-on practice. For internal switch I sent around 150 mails to different project managers, interviewed in 20 and got selected in 10 projects.\nWhen it came to changing company I put papers with NO offers in hand. And in the notice period I struggled to get a job. First 2 months were very difficult but in the last month things started changing miraculously.\nI attended 40+ interviews in span of 3 months with the help of Naukri and LinkedIn profile Optimizations and got offer by 8 companies.\n Based on my career transition and industrial experience, I have designed this course so anyone from any background can learn Data Science and become Job-Ready at affordable price.',
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     left: 20,
//             //     bottom: 10,
//             //   ),
//             //   child: Container(
//             //     decoration: BoxDecoration(
//             //         borderRadius: BorderRadius.circular(15),
//             //         color: Color.fromARGB(255, 6, 240, 185),
//             //         boxShadow: [
//             //           BoxShadow(
//             //             color: Colors.grey,
//             //             blurRadius: 8.0,
//             //             spreadRadius: .09,
//             //             offset: Offset(1, 5),
//             //           )
//             //         ]),
//             //     width: 300 * horizontalScale,
//             //     height: 40 * verticalScale,
//             //     child: Row(
//             //       children: [
//             //         TextButton(
//             //           onPressed: () {
//             //             Navigator.push(
//             //               context,
//             //               MaterialPageRoute(
//             //                   builder: (context) => StoreScreen()),
//             //             );
//             //           },
//             //           child: Text(
//             //             'My Recommended Courses',
//             //             textScaleFactor: min(horizontalScale, verticalScale),
//             //             style: TextStyle(fontSize: 16),
//             //           ),
//             //         ),
//             //         SizedBox(
//             //           width: .01,
//             //         ),
//             //         Icon(
//             //           Icons.arrow_circle_right,
//             //           size: 30,
//             //           color: Colors.white,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//       floatingActionButton: isShow
//           ? FloatingActionButton.extended(
//         elevation: 0,
//         backgroundColor: Colors.white10,
//         onPressed: _launchWhatsapp,
//         //     (){
//         //   Navigator.push(context, MaterialPageRoute(builder: (context) => ResumeCourseScreen(),));
//         // },
//
//         label: Showcase(
//           key: widget.three!,
//           description: 'Message us on whatsApp',
//           disableDefaultTargetGestures: true,
//           child: CircleAvatar(
//             backgroundImage: AssetImage('assets/wp.png'),
//             maxRadius: 30,
//           ),
//         ),
//         // icon: Icon(Icons.call),
//       )
//           : SizedBox(),
//     );
//   }
// }
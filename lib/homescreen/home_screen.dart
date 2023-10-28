import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/homescreen/home_controller.dart';
import 'package:cloudyml_app2/module/video_screen.dart';
import 'package:cloudyml_app2/my_Courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:star_rating/star_rating.dart';
import 'package:badges/badges.dart' as prefix;
import '../Providers/UserProvider.dart';
import '../combo/combo_course.dart';
import '../combo/multi_combo_course.dart';
import '../combo/multi_combo_feature_screen.dart';
import '../combo/new_combo_course.dart';
import '../globals.dart';
import '../models/course_details.dart';
import '../module/pdf_course.dart';
import '../pages/notificationpage.dart';
import '../utils/widget_utils.dart';

class NewHomeScreen extends StatefulWidget {
  NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(context: context),
        builder: (controller) {
          if (controller.course.isEmpty) {
            controller.course.value = Provider.of<List<CourseDetails>>(context);
            controller.setFeaturedCourse(controller.course);
          }
          return Scaffold(
            backgroundColor: HexColor('190037'),
            appBar: AppBar(
              backgroundColor: HexColor('440F87'),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/dataly_min_logo.png",
                    width: 30,
                    height: 30,
                  ),
                  WidgetUtils().horizontalBox(10),
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
                  size: 30,
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
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          //    print("-------------${notificationBox.values}");
                          if (snapshot.data!.docs.length <
                              data.countNotification) {
                            controller.notificationBox.value.put(
                                1, {"count": (snapshot.data!.docs.length)});
                            controller.providerNotification
                                .showNotificationHomeScreen(controller
                                    .notificationBox
                                    .value
                                    .values
                                    .first["count"]);
                          }
                          return prefix.Badge(
                              showBadge: data.countNotification ==
                                          snapshot.data!.docs.length ||
                                      snapshot.data!.docs.length <
                                          data.countNotification
                                  ? false
                                  : true,
                              child: IconButton(
                                onPressed: () async {
                                  await Get.to(() => NotificationPage());
                                  await controller.notificationBox.value.put(1,
                                      {"count": (snapshot.data!.docs.length)});
                                  await controller.providerNotification
                                      .showNotificationHomeScreen(controller
                                          .notificationBox
                                          .value
                                          .values
                                          .first["count"]);
                                },
                                icon: Icon(
                                  Icons.notifications_active,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              badgeStyle: BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              // toAnimate: false,
                              badgeContent: Text(
                                snapshot.data!.docs.length -
                                            controller.notificationBox.value
                                                .values.first["count"] >=
                                        0
                                    ? (snapshot.data!.docs.length -
                                            controller.notificationBox.value
                                                .values.first["count"])
                                        .toString()
                                    : (controller.notificationBox.value.values
                                                .first["count"] -
                                            snapshot.data!.docs.length)
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              position: BadgePosition.custom(
                                top: (2 -
                                        2 *
                                            (snapshot.data!.docs.length)
                                                .toString()
                                                .length) *
                                    MediaQuery.of(context).size.height,
                                end: data.countNotification >= 100 ? 2 : 7,
                              ));
                        });
                  },
                ),
                
                
                WidgetUtils().horizontalBox(10)
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Fwebbg.png?alt=media&token=04326232-0b38-44f3-9722-3dfc1a89e052',
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  color: HexColor('190037'),
                                );
                              },
                            )),
                        Positioned(
                          bottom: 100,
                          right: 20,
                          left: 20,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2Fnewceopic.png?alt=media&token=a16accef-f310-4bb4-9ffa-65ca66c05071&_gl=1*3fd215*_ga*MTIxMDc0Mjg1Ny4xNjczMzM1NjE4*_ga_CW55HF8NVT*MTY4NjIwMjc4NC4xNDkuMS4xNjg2MjA1MDAxLjAuMC4w',
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
                                WidgetUtils().verticalBox(15),
                                Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * .75,
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
                                WidgetUtils().verticalBox(20),
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            WidgetUtils().horizontalBox(10),
                                            Text(
                                                'Trusted by ${controller.numberOfLearners}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      WidgetUtils().verticalBox(10),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                  controller.isAnnouncement.value
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 30
                                  // top: 20 * verticalScale,
                                  ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Announcements 📣',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                WidgetUtils().verticalBox(10),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 15,
                                    bottom: 15,

                                    // top: 20 * verticalScale,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Colors.deepPurple.withOpacity(0.12)),
                                  child: Center(
                                    child: Text(
                                      controller.announcementMsg.value,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    height: MediaQuery.of(context).size.height * 1.25,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FLanding%20Page.jpg?alt=media&token=c820b5f5-c177-4de8-a5da-e26afc4a8c28',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Obx(() => controller.courses.length > 0
                            ? Positioned(
                                top: 0,
                                left: 15,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                  fontSize: 15),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: HexColor('2369F0'),
                                              size: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            : Container()),
                        Obx(() => controller.searchcomplete.value == false
                            ? Positioned(
                                top: 50,
                                child: Container(
                                  height: 270,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: CircularPercentIndicator(
                                      radius: 20,
                                      progressColor: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                              )),
                        Obx(() => controller.courses.length > 0
                            ? Positioned(
                                top: 50,
                                child: Container(
                                  height: 270,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    itemCount: controller.course.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (controller.course[index].courseName ==
                                          "null") {
                                        return Container();
                                      }

                                      if (controller.courses.contains(
                                          controller.course[index].courseId)) {
                                        return InkWell(
                                          onTap: () {
                                            if (controller
                                                    .navigateToCatalogueScreen(
                                                        controller.course[index]
                                                            .courseId) &&
                                                !(controller.userMap[
                                                            'payInPartsDetails']
                                                        [
                                                        controller.course[index]
                                                            .courseId]
                                                    ['outStandingAmtPaid'])) {
                                              if (controller.course[index]
                                                      .multiCombo ==
                                                  true) {
                                                Get.to(() => MultiComboCourse(
                                                      courseName: controller
                                                          .course[index]
                                                          .courseName
                                                          .toString(),
                                                      id: controller
                                                          .course[index]
                                                          .courseId,
                                                    ));
                                              } else if (!controller
                                                  .course[index]
                                                  .isItComboCourse) {
                                                Get.to(() => VideoScreen(
                                                      isdemo: true,
                                                      courseName: controller
                                                          .course[index]
                                                          .curriculum
                                                          .keys
                                                          .toList()
                                                          .first
                                                          .toString(),
                                                      sr: 1,
                                                    ));
                                              } else {
                                                Get.to(() => ComboStore(
                                                      courses: controller
                                                          .course[index]
                                                          .courses,
                                                    ));
                                              }
                                            } else {
                                              if (controller.course[index]
                                                      .multiCombo ==
                                                  true) {
                                                Get.to(() => MultiComboCourse(
                                                      courseName: controller
                                                          .course[index]
                                                          .courseName
                                                          .toString(),
                                                      id: controller
                                                          .course[index]
                                                          .courseId,
                                                    ));
                                              } else if (!controller
                                                  .course[index]
                                                  .isItComboCourse) {
                                                if (controller.course[index]
                                                        .courseContent ==
                                                    'pdf') {
                                                  Get.to(
                                                    () => PdfCourseScreen(
                                                      curriculum: controller
                                                              .course[index]
                                                              .curriculum
                                                          as Map<String,
                                                              dynamic>,
                                                    ),
                                                  );
                                                } else {
                                                  Get.to(
                                                    () => VideoScreen(
                                                      isdemo: true,
                                                      courseName: controller
                                                          .course[index]
                                                          .curriculum
                                                          .keys
                                                          .toList()
                                                          .first
                                                          .toString(),
                                                      sr: 1,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ComboCourse.comboId.value =
                                                    controller
                                                        .course[index].courseId;
                                                Get.to(() => NewComboCourse(
                                                      courseName: controller
                                                          .course[index]
                                                          .courseName,
                                                      courses: controller
                                                          .course[index]
                                                          .courses,
                                                    ));
                                              }
                                            }
                                            courseId = controller
                                                .course[index].courseDocumentId;
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Container(
                                              width: 250,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 130,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.network(
                                                          controller
                                                              .course[index]
                                                              .courseImageUrl,
                                                          fit: BoxFit.fill,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Container(
                                                              width: 150,
                                                              height: 180,
                                                              color: Colors.grey
                                                                  .shade200,
                                                            );
                                                          },
                                                        ),
                                                      ),
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
                                                          Text(
                                                            controller
                                                                .course[index]
                                                                .courseName,
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '2C2C2C'),
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontSize: 12,
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
                                                          // course[index]
                                                          //     .isItComboCourse &&
                                                          //     statusOfPayInParts(
                                                          //         course[index]
                                                          //             .courseId)
                                                          //     ? Container(
                                                          //   child: !navigateToCatalogueScreen(
                                                          //       course[index]
                                                          //           .courseId)
                                                          //       ? Container(
                                                          //     height: MediaQuery.of(context).size.width *
                                                          //         0.08 *
                                                          //         verticalScale,
                                                          //     decoration:
                                                          //     BoxDecoration(
                                                          //       borderRadius:
                                                          //       BorderRadius.circular(
                                                          //         10,
                                                          //       ),
                                                          //       color:
                                                          //       Color(
                                                          //         0xFFC0AAF5,
                                                          //       ),
                                                          //     ),
                                                          //     child:
                                                          //     Row(
                                                          //       mainAxisAlignment:
                                                          //       MainAxisAlignment.spaceEvenly,
                                                          //       children: [
                                                          //         SizedBox(
                                                          //           width: 10,
                                                          //         ),
                                                          //         Text(
                                                          //           'Access ends in days : ',
                                                          //           textScaleFactor: min(horizontalScale, verticalScale),
                                                          //           style: TextStyle(
                                                          //             color: Colors.white,
                                                          //             fontSize: 13,
                                                          //             fontWeight: FontWeight.bold,
                                                          //           ),
                                                          //         ),
                                                          //         Container(
                                                          //           decoration: BoxDecoration(
                                                          //             borderRadius: BorderRadius.circular(10),
                                                          //             color: Colors.grey.shade100,
                                                          //           ),
                                                          //           width: 30 * min(horizontalScale, verticalScale),
                                                          //           height: 30 * min(horizontalScale, verticalScale),
                                                          //           // color:
                                                          //           //     Color(0xFFaefb2a),
                                                          //           child: Center(
                                                          //             child: Text(
                                                          //               '${(DateTime.parse(userMap['payInPartsDetails'][course[index].courseId]['endDateOfLimitedAccess']).difference(DateTime.now()).inDays)}',
                                                          //               textScaleFactor: min(horizontalScale, verticalScale),
                                                          //               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold
                                                          //                 // fontSize: 16,
                                                          //               ),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ],
                                                          //     ),
                                                          //   )
                                                          //       : Container(
                                                          //     height: MediaQuery.of(context).size.width *
                                                          //         0.08,
                                                          //     decoration:
                                                          //     BoxDecoration(
                                                          //       borderRadius:
                                                          //       BorderRadius.circular(10),
                                                          //       color:
                                                          //       Color(0xFFC0AAF5),
                                                          //     ),
                                                          //     child:
                                                          //     Center(
                                                          //       child:
                                                          //       Text(
                                                          //         'Limited access expired !',
                                                          //         textScaleFactor:
                                                          //         min(horizontalScale, verticalScale),
                                                          //         style:
                                                          //         TextStyle(
                                                          //           color: Colors.deepOrange[600],
                                                          //           fontSize: 13,
                                                          //         ),
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // )
                                                          //     : SizedBox(),
                                                          Container(
                                                            child: Text(
                                                              controller
                                                                  .course[index]
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
                                                                  fontSize: 7,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  '${controller.course[index].courseLanguage} ||',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Medium',
                                                                      color: HexColor(
                                                                          '585858'),
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              WidgetUtils()
                                                                  .horizontalBox(
                                                                      5),
                                                              Container(
                                                                child: Center(
                                                                  child: Text(
                                                                    '${controller.course[index].numOfVideos} videos',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Medium',
                                                                        color: HexColor(
                                                                            '585858'),
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0, right: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: 130,
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: HexColor('8346E1'),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18),
                                                                      ),
                                                                      padding: EdgeInsets.all(0)),
                                                                  onPressed: () {
                                                                    if (controller.navigateToCatalogueScreen(controller
                                                                            .course[
                                                                                index]
                                                                            .courseId) &&
                                                                        !(controller.userMap['payInPartsDetails'][controller
                                                                            .course[index]
                                                                            .courseId]['outStandingAmtPaid'])) {
                                                                      if (controller
                                                                              .course[
                                                                                  index]
                                                                              .multiCombo ==
                                                                          true) {
                                                                        Get.to(() =>
                                                                            MultiComboCourse(
                                                                              courseName: controller.course[index].courseName.toString(),
                                                                              id: controller.course[index].courseId,
                                                                            ));
                                                                      } else if (!controller
                                                                          .course[
                                                                              index]
                                                                          .isItComboCourse) {
                                                                        Get.to(() =>
                                                                            VideoScreen(
                                                                              isdemo: true,
                                                                              courseName: controller.course[index].curriculum.keys.toList().first.toString(),
                                                                              sr: 1,
                                                                            ));
                                                                      } else {
                                                                        Get.to(() =>
                                                                            ComboStore(
                                                                              courses: controller.course[index].courses,
                                                                            ));
                                                                      }
                                                                    } else {
                                                                      if (controller
                                                                              .course[
                                                                                  index]
                                                                              .multiCombo ==
                                                                          true) {
                                                                        Get.to(() =>
                                                                            MultiComboCourse(
                                                                              courseName: controller.course[index].courseName.toString(),
                                                                              id: controller.course[index].courseId,
                                                                            ));
                                                                      } else if (!controller
                                                                          .course[
                                                                              index]
                                                                          .isItComboCourse) {
                                                                        if (controller.course[index].courseContent ==
                                                                            'pdf') {
                                                                          Get.to(
                                                                            () =>
                                                                                PdfCourseScreen(
                                                                              curriculum: controller.course[index].curriculum as Map<String, dynamic>,
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          Get.to(
                                                                            () =>
                                                                                VideoScreen(
                                                                              isdemo: true,
                                                                              courseName: controller.course[index].curriculum.keys.toList().first.toString(),
                                                                              sr: 1,
                                                                            ),
                                                                          );
                                                                        }
                                                                      } else {
                                                                        ComboCourse
                                                                            .comboId
                                                                            .value = controller.course[index].courseId;
                                                                        Get.to(() =>
                                                                            NewComboCourse(
                                                                              courseName: controller.course[index].courseName,
                                                                              courses: controller.course[index].courses,
                                                                            ));
                                                                      }
                                                                    }
                                                                    courseId = controller
                                                                        .course[
                                                                            index]
                                                                        .courseDocumentId;
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .play_arrow_rounded,
                                                                        size:
                                                                            18,
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
                                                            Obx(
                                                              () =>
                                                                  CircularPercentIndicator(
                                                                radius: 25,
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .round,
                                                                percent: controller.coursePercent[controller
                                                                            .course[
                                                                                index]
                                                                            .courseId
                                                                            .toString()] !=
                                                                        null
                                                                    ? controller.coursePercent[controller
                                                                            .course[index]
                                                                            .courseId] /
                                                                        100
                                                                    : 0 / 100,
                                                                progressColor:
                                                                    HexColor(
                                                                        "31D198"),
                                                                lineWidth: 4,
                                                                center: Text(
                                                                  "${controller.coursePercent[controller.course[index].courseId.toString()] != null ? controller.coursePercent[controller.course[index].courseId] : 0}%",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
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
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ))
                            : SizedBox()),
                        Positioned(
                            top: 350,
                            // left: 50,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.75,
                                        padding:
                                            EdgeInsets.only(left: 15, top: 30),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                colors: [
                                                  HexColor('683AB0'),
                                                  HexColor('230454'),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Our',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily: 'SemiBold',
                                                      fontSize: 16,
                                                      height: 1,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  ' Special',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontFamily: 'SemiBold',
                                                      fontSize: 16,
                                                      height: 1,
                                                      color:
                                                          HexColor('FFDB1B')),
                                                ),
                                              ],
                                            ),
                                            WidgetUtils().verticalBox(10),
                                            Text('Features for you',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontFamily: 'SemiBold',
                                                    fontSize: 16,
                                                    height: 1,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      featureBox(
                                          imgUrl:
                                              'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV1.png?alt=media&token=c3c352fc-ae1e-4960-8f14-77307f4f94d9',
                                          title: 'Hands-On Learning',
                                          context: context)
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        featureBox(
                                            imgUrl:
                                                'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV2.png?alt=media&token=67c2dedc-c53b-4ee7-af04-4ab36ceea2c7',
                                            title: 'Doubt clearance support',
                                            context: context),
                                        featureBox(
                                            imgUrl:
                                                'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV3.png?alt=media&token=66b62e70-8c7b-4410-a883-b97e23cbccff',
                                            title: 'Lifetime Access',
                                            context: context),
                                        featureBox(
                                            imgUrl:
                                                'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FV4.png?alt=media&token=236df98e-1d4d-477d-9d55-720210caa64a',
                                            title: 'Industrial Internship',
                                            context: context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
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
                                WidgetUtils().verticalBox(10),
                                Container(
                                  height: 320,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.featuredCourse.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        if (controller.featuredCourse[index]
                                                .courseName ==
                                            "null") {
                                          return Container();
                                        }

                                        return InkWell(
                                            // onTap: () {
                                            //   setState(() {
                                            //     courseId = featuredCourse[index]
                                            //         .courseDocumentId;
                                            //   });
                                            //
                                            //   print(courseId);
                                            //   if (featuredCourse[index]
                                            //       .isItComboCourse) {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) => ComboStore(
                                            //           trialCourse:
                                            //           featuredCourse[index]
                                            //               .trialCourse,
                                            //           courseP: featuredCourse[index]
                                            //               .coursePrice,
                                            //           id: index.toString(),
                                            //           cID: featuredCourse[index]
                                            //               .courseDocumentId,
                                            //           cName: featuredCourse[index]
                                            //               .courseName,
                                            //           image: featuredCourse[index]
                                            //               .courseImageUrl,
                                            //           courses: featuredCourse[index]
                                            //               .courses,
                                            //           courseName:
                                            //           featuredCourse[index]
                                            //               .courseName,
                                            //         ),
                                            //       ),
                                            //     );
                                            //   } else if (featuredCourse[index]
                                            //       .multiCombo ==
                                            //       true) {
                                            //     Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 MultiComboFeatureScreen(
                                            //                     cID: featuredCourse[
                                            //                     index]
                                            //                         .courseDocumentId,
                                            //                     courseName:
                                            //                     featuredCourse[
                                            //                     index]
                                            //                         .courseName,
                                            //                     id: featuredCourse[
                                            //                     index]
                                            //                         .courseId,
                                            //                     coursePrice:
                                            //                     featuredCourse[
                                            //                     index]
                                            //                         .coursePrice)));
                                            //   } else {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //           const CatelogueScreen()),
                                            //     );
                                            //   }
                                            // },
                                            child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            width: 280,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: 280,
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 10),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20)),
                                                      child: Image.network(
                                                        controller
                                                            .featuredCourse[
                                                                index]
                                                            .courseImageUrl,
                                                        fit: BoxFit.fill,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Container(
                                                            height: 150,
                                                            width: 280,
                                                            color: Colors
                                                                .grey.shade400,
                                                          );
                                                        },
                                                      )),
                                                ),
                                                Container(
                                                  height: 100,
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      left: 10,
                                                      right: 10),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 8),
                                                              child: StarRating(
                                                                length: 1,
                                                                rating: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .reviews
                                                                        .isNotEmpty
                                                                    ? double.parse(controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .reviews)
                                                                    : 5.0,
                                                                color: HexColor(
                                                                    '31D198'),
                                                                starSize: 20,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                              ),
                                                            ),
                                                            Text(
                                                              controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .reviews
                                                                      .isNotEmpty
                                                                  ? controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .reviews
                                                                  : '5.0',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: HexColor(
                                                                      '585858'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                        WidgetUtils()
                                                            .verticalBox(15),
                                                        Text(
                                                          controller
                                                              .featuredCourse[
                                                                  index]
                                                              .courseName,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                '2C2C2C'),
                                                            fontFamily:
                                                                'Medium',
                                                            fontSize: 14,
                                                            height: 1,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Container(
                                                      height: 35,
                                                      width: 150,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            courseId = controller
                                                                .featuredCourse[
                                                                    index]
                                                                .courseDocumentId;

                                                            if (controller
                                                                .featuredCourse[
                                                                    index]
                                                                .isItComboCourse) {
                                                              Get.to(() =>
                                                                  ComboStore(
                                                                    trialCourse: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .trialCourse,
                                                                    courseP: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .coursePrice,
                                                                    id: index
                                                                        .toString(),
                                                                    cID: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .courseDocumentId,
                                                                    cName: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .courseName,
                                                                    image: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .courseImageUrl,
                                                                    courses: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .courses,
                                                                    courseName: controller
                                                                        .featuredCourse[
                                                                            index]
                                                                        .courseName,
                                                                  ));
                                                            } else if (controller
                                                                    .featuredCourse[
                                                                        index]
                                                                    .multiCombo ==
                                                                true) {
                                                              Get.to(() => MultiComboFeatureScreen(
                                                                  cID: controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .courseDocumentId,
                                                                  courseName: controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .courseName,
                                                                  id: controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .courseId,
                                                                  coursePrice: controller
                                                                      .featuredCourse[
                                                                          index]
                                                                      .coursePrice));
                                                            } else {
                                                              Get.to(() =>
                                                                  CatelogueScreen());
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
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
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
                                      }),
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
            ),
            // floatingActionButton: InkWell(
            //   onTap: () => controller.launchWhatsapp(),
            //   child: Container(
            //     height: 60,
            //     width: 60,
            //     decoration: BoxDecoration(
            //         color: Colors.grey,
            //         border: Border.all(color: Colors.black, width: 0.5),
            //         shape: BoxShape.circle,
            //         image: DecorationImage(
            //             image: NetworkImage(
            //                 'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fwp.png?alt=media&token=440772d5-f8fa-4a9c-8d3d-8d20456a0983'),
            //             fit: BoxFit.cover)),
            //   ),
            // )
          );
        });
  }

  Widget featureBox(
      {required String imgUrl,
      required String title,
      required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width / 3.5,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 25,
              child: Image.network(
                imgUrl,
                fit: BoxFit.fill,
              ),
            ),
            WidgetUtils().verticalBox(10),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            WidgetUtils().verticalBox(5),
            Text(
              'Get Complete Hands-on Practical Learning Experience through Assignments & Projects for Proper Confidence Building',
              style: TextStyle(
                fontSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudyml_app2/Live_doubt_support/live_doubt_screen.dart';
import 'package:cloudyml_app2/combo/controller/combo_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../globals.dart';
import '../module/video_screen.dart';

class NewComboCourse extends StatelessWidget {
  final String? courseName;
  final List<dynamic>? courses;
  const NewComboCourse({
    Key? key,
    required this.courseName,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetX<ComboCourseController>(
        init: ComboCourseController(courses: courses),
        builder: (controller) => Scaffold(
          backgroundColor: HexColor("#fef0ff"),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 20),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 22,
                              color: Colors.black)),
                      TextSpan(
                          text: courseName ?? '',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                controller.courseList.isEmpty
                    ? Container(
                        height: Adaptive.h(100),
                        width: Adaptive.w(100),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent, strokeWidth: 3),
                        ),
                      )
                    : SizedBox(
                        child: ListView.builder(
                          itemCount: controller.courseList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  // Container(
                                  //   width: 110,
                                  //   height: 100,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius:
                                  //       BorderRadius.circular(10)),
                                  //   child: CachedNetworkImage(
                                  //     imageUrl: controller.courseList[index]['image_url'],
                                  //     fit: BoxFit.contain,
                                  //     placeholder: (context, url) =>
                                  //         Container(
                                  //           width: 120,
                                  //           height: 100,
                                  //           decoration: BoxDecoration(
                                  //               color:
                                  //               Colors.grey.withOpacity(0.3),
                                  //               borderRadius:
                                  //               BorderRadius.circular(10)),

                                  //         ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.courseList[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "Estimated learning time: ${controller.courseList[index]['duration']}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 12)),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                onPressed: () {
                                                  courseId = controller
                                                          .courseList[index]
                                                      ['docid'];
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoScreen(
                                                        courseName: controller
                                                            .courseList[index]
                                                                ['curriculum1']
                                                            .keys
                                                            .toList()
                                                            .first
                                                            .toString(),
                                                        isdemo: false,
                                                        sr: 1,
                                                        courses: courses,
                                                        comboCourseName:
                                                            courseName,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "Resume learning",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                color: Colors.purple,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              height: 30,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  Get.to(
                                                      () => LiveDoubtScreen());
                                                },
                                                color: Colors.blue,
                                                height: 30,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                minWidth: 60,
                                                child: Center(
                                                  child: Text(
                                                    'Live Doubt Support',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // index == 0
                                            //     ?
                                            //     SizedBox(
                                            //   width:
                                            //   120,
                                            //   height: 30,
                                            //   child:
                                            //   MaterialButton(
                                            //     shape:
                                            //     RoundedRectangleBorder(
                                            //       borderRadius:
                                            //       BorderRadius
                                            //           .circular(
                                            //           20),
                                            //     ),
                                            //     onPressed: (){
                                            //       courseId = controller.courseList[index]['docid'];
                                            //       Navigator
                                            //           .pushReplacement(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder:
                                            //               (context) =>
                                            //               VideoScreen(
                                            //                 courseName: controller.courseList[index]['name'],
                                            //                 isdemo: false,
                                            //                 sr: 1,
                                            //                 courses: courses,
                                            //                 comboCourseName: courseName,
                                            //               ),
                                            //         ),
                                            //       );
                                            //     },

                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.center,
                                            //       children: [

                                            //         Icon(
                                            //           Icons
                                            //               .play_arrow,
                                            //           color: Colors
                                            //               .white,
                                            //           size: 15,
                                            //         ),
                                            //         Expanded(
                                            //           child: Text(
                                            //             "Resume learning",
                                            //             overflow : TextOverflow.ellipsis,
                                            //             style: TextStyle(
                                            //                 color:
                                            //                 Colors.white,
                                            //                 fontSize: 8),

                                            //           ),
                                            //         )
                                            //       ],
                                            //     ),
                                            //     color:
                                            //     Colors.purple,
                                            //   ),
                                            // ),

                                            //     : controller.courseData[courses![
                                            // 0] +
                                            //     "percentage"] ==
                                            //     100 ||
                                            //     controller.oldModuleProgress.value
                                            //     ?
                                            //     SizedBox(
                                            //   width:
                                            //   120,
                                            //   height: 30,
                                            //   child:
                                            //   MaterialButton(
                                            //     shape:
                                            //     RoundedRectangleBorder(
                                            //       borderRadius:
                                            //       BorderRadius
                                            //           .circular(
                                            //           20),
                                            //     ),

                                            //     onPressed: () {
                                            //       courseId = controller.courseList[index]['docid'];

                                            //       Navigator
                                            //           .pushReplacement(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder:
                                            //               (context) =>
                                            //               VideoScreen(
                                            //                 courseName: controller.courseList[index]['name'],
                                            //                 isdemo: false,
                                            //                 sr: 1,
                                            //                 courses: courses,
                                            //                 comboCourseName: courseName,
                                            //               ),
                                            //         ),
                                            //       );
                                            //     },
                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.center,
                                            //       children: [

                                            //         Icon(
                                            //           Icons
                                            //               .play_arrow,
                                            //           color: Colors
                                            //               .white,
                                            //           size: 15,
                                            //         ),
                                            //         Expanded(
                                            //           child: Text(
                                            //             "Resume learning",
                                            //             overflow : TextOverflow.ellipsis,
                                            //             style: TextStyle(
                                            //                 color:
                                            //                 Colors.white,
                                            //                 fontSize: 8),

                                            //           ),
                                            //         )
                                            //       ],
                                            //     ),
                                            //     color:
                                            //     Colors.purple,
                                            //   ),
                                            // )
                                            //     :
                                            //     Container(
                                            //   width: 100,

                                            //   child: Text(
                                            //     'Complete First Module To Unlock',
                                            //     maxLines: 1,
                                            //     style: TextStyle(
                                            //         fontSize:
                                            //         12,
                                            //         fontWeight:
                                            //         FontWeight
                                            //             .w600,
                                            //         color: Colors
                                            //             .black),
                                            //   ),
                                            // ),

                                            // SizedBox(
                                            //   width:
                                            //   120,
                                            //   height: 30,
                                            //   child:
                                            //   MaterialButton(
                                            //     shape:
                                            //     RoundedRectangleBorder(
                                            //       borderRadius:
                                            //       BorderRadius
                                            //           .circular(
                                            //           20),
                                            //     ),
                                            //     onPressed: (){
                                            //       courseId = controller.courseList[index]['docid'];
                                            //       Navigator
                                            //           .pushReplacement(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder:
                                            //               (context) =>
                                            //               VideoScreen(
                                            //                 courseName: controller.courseList[index]['name'],
                                            //                 isdemo: false,
                                            //                 sr: 1,
                                            //                 courses: courses,
                                            //                 comboCourseName: courseName,
                                            //               ),
                                            //         ),
                                            //       );
                                            //     },

                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.center,
                                            //       children: [

                                            //         Icon(
                                            //           Icons
                                            //               .play_arrow,
                                            //           color: Colors
                                            //               .white,
                                            //           size: 15,
                                            //         ),
                                            //         Expanded(
                                            //           child: Text(
                                            //             "Resume learning",
                                            //             overflow : TextOverflow.ellipsis,
                                            //             style: TextStyle(
                                            //                 color:
                                            //                 Colors.white,
                                            //                 fontSize: 8),

                                            //           ),
                                            //         )
                                            //       ],
                                            //     ),
                                            //     color:
                                            //     Colors.purple,
                                            //   ),
                                            // ),
                                            SizedBox(
                                              width: 10,
                                            ),

                                            controller.courseData.isEmpty
                                                ? SizedBox()
                                                : CircularPercentIndicator(
                                                    radius: 25,
                                                    lineWidth: 3,
                                                    animation: true,
                                                    percent: controller
                                                                    .courseData[
                                                                courses![
                                                                        index] +
                                                                    "percentage"] ==
                                                            null
                                                        ? 0
                                                        : controller.courseData[
                                                                courses![
                                                                        index] +
                                                                    "percentage"] /
                                                            100,
                                                    center: Text(
                                                      controller.courseData[courses![
                                                                      index] +
                                                                  "percentage"] ==
                                                              null
                                                          ? "0%"
                                                          : '${controller.courseData[courses![index] + "percentage"]}%',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black12,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    progressColor: Colors.green,
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

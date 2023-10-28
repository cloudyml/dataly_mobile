import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/global_variable.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/homepage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../module/video_screen.dart';

class NewScreen extends StatefulWidget {
  final List<dynamic>? courses;
  final String? courseName;
  const NewScreen({Key? key, this.courses, this.courseName}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  getAllPaidCourses() async {
    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc()
        .get()
        .then((value) {
      print(value);
    });
  }

  var coursePercent = {};
  var courseData = null;
  getPercentageOfCourse() async {
    var data = await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      tmp.clear();
      for (var i = 0; i < data.data()!.length; i++) {
        try {
          if (i != 0) {
            tmp.add(data.data()![widget.courses![i] + "percentage"]);
          }
        } catch (e) {}
      }
      for (int i = 1; i < tmp.length; i++) {
        if (tmp[i] is int) {
          oldModuleProgress = true;
        }
      }
      courseData = data.data();
    });
  }

  Map<String, dynamic> numberOfCourseHours = {};
  Duration totalDurationOfCourse = Duration.zero;
  bool oldModuleProgress = false;
  List tmp = [];

  /*---- parse Duration srinivas -----*/
  // Duration parseDuration(String s) {
  //   int hours = 0;
  //   int minutes = 0;
  //   int micros;
  //   List<String> parts = s.split(':');
  //   if (parts.length > 2) {
  //     hours = int.parse(parts[parts.length - 3]);
  //   }
  //   if (parts.length > 1) {
  //     minutes = int.parse(parts[parts.length - 2]);
  //   }
  //   micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  //   return Duration(hours: hours, minutes: minutes, microseconds: micros);
  // }
  /*------- total duration of course -------*/
  // getTheDurationOfCourse()
  // async{
  //   // VideoPlayerController playerController = await VideoPlayerController.network("https://media.publit.io/file/kaggleCourse/8-reviewing-a-notebook.mp4"
  //   //   // value.docs.first.data()["curriculum1"][value.docs.first
  //   //   //     .data()["name"]][j]["videos"][k]["url"].toString()
  //   // );
  //   // await playerController.initialize().then((value) {
  //   //   print(playerController.value.duration.inSeconds);
  //   // });
  //   // print("112Seconds  ${await playerController.value.duration.inMinutes}");
  //   for(int i=0;i<widget.courses!.length;i++)
  //   {
  //     await FirebaseFirestore.instance.collection("courses").where("id",isEqualTo: widget.courses![i].toString()).get().then((value) async{
  //       print("length--------- ${value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]].length} ${value.docs.first.data()["name"]}");
  //       for(int j=0;j<value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]].length;j++)
  //       {
  //         for(int k=0;k<value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"].length;k++)
  //         {
  //           print("video-- ${value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["url"]}");
  //           if(value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["type"]=="video") {
  //             // _controller = await VideoPlayerController.network(
  //             //   // "https://media.publit.io/file/kaggleCourse/8-reviewing-a-notebook.mp4"
  //             //     value.docs.first.data()["curriculum1"][value.docs.first
  //             //         .data()["name"]][j]["videos"][k]["url"].toString()
  //             // );
  //
  //             // value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["duration"]!=null?
  //             // totalDurationOfCourse = value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["duration"]+totalDurationOfCourse:null;
  //             if(value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["duration"]!=null) {
  //                  Duration duration = parseDuration(value.docs.first.data()["curriculum1"][value.docs.first.data()["name"]][j]["videos"][k]["duration"].toString());
  //                  totalDurationOfCourse += duration;
  //             }
  //             // await _controller.initialize().then((value) {
  //             //   print("Seconds  ${_controller.value.duration.inSeconds}");
  //             // });
  //             // ..initialize();
  //           }
  //         }
  //       }
  //     });
  //   }
  // }

  static final _stateStreamController = StreamController<List>.broadcast();
  static StreamSink<List> get counterSink => _stateStreamController.sink;
  static Stream<List> get counterStream => _stateStreamController.stream;

  getTheStreamData() async {
    print("calling...");
    await FirebaseFirestore.instance.collection("courses").get().then((value) {
      print("0000000 $value");
      counterSink.add(value.docs);
    });
  }

  Future<String> getProgress(int index) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("courseprogress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      List dataTemp = [];

      for (var i = 0; i < widget.courses!.length; i++) {
        dataTemp.add(data.data()![widget.courses![i] + "percentage"]);
      }

      return dataTemp[index].toString();
    } catch (e) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();

    getTheStreamData();
    // getTheDurationOfCourse();
    //getAllPaidCourses();
    getPercentageOfCourse();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Course%20Images%2FBG.png?alt=media&token=37745622-74c7-4aec-b013-88e9573fff20"),
                fit: BoxFit.fill),
            color: HexColor("#fef0ff"),
          ),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 15),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 20),
                          Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 22,
                              color: Colors.black)),
                      TextSpan(
                          text: "${widget.courseName}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: counterStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && widget.courses != null) {
                          List courseList = [];
                          List<CourseDetails> courses =
                              Provider.of<List<CourseDetails>>(context);

                          for (var i in widget.courses!) {
                            int count = 0;
                            for (var j in courses) {
                              if (i == j.courseId) {
                                courseList.add(j);
                                count = 1;
                              }
                            }
                            count == 0 ? widget.courses?.remove(i) : null;
                          }

                          // return Column(
                          //   children: List.generate(
                          //     courseList.length,
                          //     (index) {
                          //       if (courseList.length > index) {
                          //
                          //         return Container(
                          //           padding: EdgeInsets.symmetric(horizontal: 10),
                          //           margin: EdgeInsets.only(bottom: 15.sp),
                          //           width: 100.w,
                          //           height: 17.h,
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(18.sp),
                          //               color: Colors.white),
                          //           child: Row(
                          //             children: [
                          //               Container(
                          //                 width: 35.w,
                          //                 height: 17.h,
                          //                 decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(18.sp)),
                          //                 child: ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(25.sp),
                          //                   child: CachedNetworkImage(
                          //                     imageUrl: courseList[index]
                          //                         .courseImageUrl,
                          //                     placeholder: (context, url) =>
                          //                         Container(
                          //                       color:
                          //                           Colors.grey.withOpacity(0.3),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 width: 5.sp,
                          //               ),
                          //               Container(
                          //                 width: 57.w,
                          //                 padding: EdgeInsets.only(
                          //                     top: 13.sp,
                          //                     left: 10.sp,
                          //                     right: 10.sp),
                          //                 child: Column(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.start,
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       courseList[index].courseName,
                          //                       style: TextStyle(
                          //                           height: 1,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 16.sp),
                          //                       overflow: TextOverflow.ellipsis,
                          //                       maxLines: 1,
                          //                     ),
                          //                     SizedBox(
                          //                       height: 8.sp,
                          //                     ),
                          //                     Text(
                          //                         "Estimated learning time: ${courseList[index].duration == null ? "0" : courseList[index].duration}",
                          //                         overflow: TextOverflow.ellipsis,
                          //                         style:
                          //                             TextStyle(fontSize: 13.sp)),
                          //                     SizedBox(
                          //                       height: 15.sp,
                          //                     ),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .spaceBetween,
                          //                       children: [
                          //                         Column(
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .spaceBetween,
                          //                           children: [
                          //                             index == 0
                          //                                 ? SizedBox(
                          //                                     width:
                          //                                         Adaptive.w(36),
                          //                                     height: 25.sp,
                          //                                     child:
                          //                                         MaterialButton(
                          //                                       shape:
                          //                                           RoundedRectangleBorder(
                          //                                         borderRadius:
                          //                                             BorderRadius
                          //                                                 .circular(
                          //                                                     20.sp),
                          //                                       ),
                          //                                       padding:
                          //                                           EdgeInsets
                          //                                               .all(
                          //                                                   8.sp),
                          //                                       onPressed: () {
                          //                                         courseId = courseList[
                          //                                                 index]
                          //                                             .courseDocumentId;
                          //                                         // setState(
                          //                                         //         () {
                          //                                         //       courseId = courseList[index].courseDocumentId;
                          //                                         //     });
                          //                                         Navigator
                          //                                             .pushReplacement(
                          //                                           context,
                          //                                           MaterialPageRoute(
                          //                                             builder:
                          //                                                 (context) =>
                          //                                                     VideoScreen(
                          //                                               courseName:
                          //                                                   courseList[index]
                          //                                                       .courseName,
                          //                                               isdemo:
                          //                                                   false,
                          //                                               sr: 1,
                          //                                                       courses: widget.courses,
                          //                                             ),
                          //                                           ),
                          //                                         );
                          //                                       },
                          //                                       child: Row(
                          //                                         children: [
                          //                                           SizedBox(
                          //                                             width: 5,
                          //                                           ),
                          //                                           Expanded(
                          //                                               flex: 1,
                          //                                               child:
                          //                                                   Icon(
                          //                                                 Icons
                          //                                                     .play_arrow,
                          //                                                 color: Colors
                          //                                                     .white,
                          //                                                 size: width <
                          //                                                         200
                          //                                                     ? 2
                          //                                                     : null,
                          //                                               )),
                          //                                           Expanded(
                          //                                               flex: 3,
                          //                                               child:
                          //                                                   Text(
                          //                                                 "Resume learning",
                          //                                                 style: TextStyle(
                          //                                                     color:
                          //                                                         Colors.white,
                          //                                                     fontSize: 13.sp),
                          //                                                 overflow:
                          //                                                     TextOverflow.ellipsis,
                          //                                               ))
                          //                                         ],
                          //                                       ),
                          //                                       color:
                          //                                           Colors.purple,
                          //                                     ),
                          //                                   )
                          //                                 : courseData[widget.courses![
                          //                                                     0] +
                          //                                                 "percentage"] ==
                          //                                             100 ||
                          //                                         oldModuleProgress
                          //                                     ? SizedBox(
                          //                                         width:
                          //                                             36.w,
                          //                                         height: 25.sp,
                          //                                         child:
                          //                                             MaterialButton(
                          //                                           shape:
                          //                                               RoundedRectangleBorder(
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(
                          //                                                     20.sp),
                          //                                           ),
                          //                                           padding:
                          //                                               EdgeInsets
                          //                                                   .all(8
                          //                                                       .sp),
                          //                                           onPressed:
                          //                                               () {
                          //                                             courseId = courseList[
                          //                                                     index]
                          //                                                 .courseDocumentId;
                          //
                          //                                             // setState(() {
                          //                                             //   courseId = courseList[index].courseDocumentId;
                          //                                             // });
                          //                                             Navigator
                          //                                                 .pushReplacement(
                          //                                               context,
                          //                                               MaterialPageRoute(
                          //                                                 builder:
                          //                                                     (context) =>
                          //                                                         VideoScreen(
                          //                                                   courseName:
                          //                                                       courseList[index].courseName,
                          //                                                   isdemo:
                          //                                                       false,
                          //                                                   sr: 1,
                          //                                                           courses: widget.courses,
                          //                                                 ),
                          //                                               ),
                          //                                             );
                          //                                           },
                          //                                           child: Row(
                          //                                             children: [
                          //                                               SizedBox(
                          //                                                 width:
                          //                                                     5,
                          //                                               ),
                          //                                               Expanded(
                          //                                                   flex:
                          //                                                       1,
                          //                                                   child:
                          //                                                       Icon(
                          //                                                     Icons.play_arrow,
                          //                                                     color:
                          //                                                         Colors.white,
                          //                                                     size: width < 200
                          //                                                         ? 2
                          //                                                         : null,
                          //                                                   )),
                          //                                               Expanded(
                          //                                                   flex:
                          //                                                       3,
                          //                                                   child:
                          //                                                       Text(
                          //                                                     "Resume learning",
                          //                                                     style:
                          //                                                         TextStyle(color: Colors.white, fontSize: 13.sp),
                          //                                                     overflow:
                          //                                                         TextOverflow.ellipsis,
                          //                                                   ))
                          //                                             ],
                          //                                           ),
                          //                                           color: Colors
                          //                                               .purple,
                          //                                         ),
                          //                                       )
                          //                                     : Container(
                          //                                         width: 45.sp,
                          //                                         height: 25.sp,
                          //                                         child: Text(
                          //                                           'Complete First Module To Unlock',
                          //                                           maxLines: 2,
                          //                                           style: TextStyle(
                          //                                               fontSize:
                          //                                                   13.sp,
                          //                                               fontWeight:
                          //                                                   FontWeight
                          //                                                       .w600,
                          //                                               color: Colors
                          //                                                   .black),
                          //                                         ),
                          //                                       ),
                          //                             // SizedBox(
                          //                             //   width: width <
                          //                             //       450
                          //                             //       ? 130
                          //                             //       : 190,
                          //                             //   child: MaterialButton(
                          //                             //     onPressed: () {
                          //                             //       GoRouter.of(context).pushNamed('LiveDoubtSession');
                          //                             //     },
                          //                             //     color: Colors.blue,
                          //                             //     height: width >
                          //                             //         700
                          //                             //         ? 50
                          //                             //         : 40,
                          //                             //     shape:
                          //                             //     RoundedRectangleBorder(
                          //                             //       borderRadius:
                          //                             //       BorderRadius.circular(
                          //                             //           20),
                          //                             //     ),
                          //                             //     minWidth:
                          //                             //     width > 700
                          //                             //         ? 100
                          //                             //         : 60,
                          //                             //     child: Center(
                          //                             //       child: Text(
                          //                             //         'Live Doubt Support',
                          //                             //         style: TextStyle(color: Colors.white,
                          //                             //             fontSize: width < 500 ? 10 : null),
                          //                             //         overflow: TextOverflow.ellipsis,
                          //                             //       ),
                          //                             //     ),
                          //                             //   ),
                          //                             // ),
                          //                           ],
                          //                         ),
                          //                         SizedBox(
                          //                           width: 5.sp,
                          //                         ),
                          //                         FutureBuilder(
                          //                           future: getProgress(index),
                          //                           builder: (context, snapshot) {
                          //                           if(snapshot.hasData){
                          //                             return Column(
                          //                               mainAxisAlignment:
                          //                               MainAxisAlignment.end,
                          //                               children: [
                          //                                 CircularPercentIndicator(
                          //                                   radius: 23.sp,
                          //                                   lineWidth: 4.0,
                          //                                   animation: true,
                          //                                   percent: snapshot.data == 'null' ?
                          //                                   0 :
                          //                                   double.parse(snapshot.data.toString()) / 100,
                          //                                   center: Text( snapshot.data == 'null' ?  '0%' :'${snapshot.data}%',
                          //                                     style: TextStyle(
                          //                                         fontSize:
                          //                                         14.sp,
                          //                                         fontWeight:
                          //                                         FontWeight
                          //                                             .w600,
                          //                                         color: Colors
                          //                                             .black),
                          //                                   ),
                          //                                   backgroundColor:
                          //                                   Colors.black12,
                          //                                   circularStrokeCap:
                          //                                   CircularStrokeCap
                          //                                       .round,
                          //                                   progressColor:
                          //                                   Colors.green,
                          //                                 ),
                          //                                 SizedBox(
                          //                                   height: 3,
                          //                                 ),
                          //                               ],
                          //                             );
                          //                           }else{
                          //                             return SizedBox();
                          //                           }
                          //                           }
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //
                          //               // SizedBox(width: 10,),
                          //               // width > 700
                          //               //     ? Column(
                          //               //       mainAxisAlignment:
                          //               //       width > 700
                          //               //           ? MainAxisAlignment
                          //               //           .center
                          //               //           : MainAxisAlignment
                          //               //           .end,
                          //               //       children: [
                          //               //         CircularPercentIndicator(
                          //               //           radius: width > 700
                          //               //               ? 70.0
                          //               //               : 40.0,
                          //               //           lineWidth: 10.0,
                          //               //           animation: true,
                          //               //           percent: courseData !=
                          //               //               null
                          //               //               ? courseData[widget.courses![
                          //               //           index] +
                          //               //               "percentage"] !=
                          //               //               null
                          //               //               ? (courseData[widget.courses![index] + "percentage"]) /
                          //               //               100 >
                          //               //               1
                          //               //               ? 100 /
                          //               //               100
                          //               //               : courseData[widget.courses![index] +
                          //               //               "percentage"] /
                          //               //               100
                          //               //               : 0 / 100
                          //               //               : 0,
                          //               //           center: courseData !=
                          //               //               null
                          //               //               ? courseData[widget.courses![index] + "percentage"] !=
                          //               //               null
                          //               //               ? Text(
                          //               //             courseData[widget.courses![index] + "percentage"] >
                          //               //                 100
                          //               //                 ? "100%"
                          //               //                 : courseData[widget.courses![index] + "percentage"].toString() +
                          //               //                 "%",
                          //               //             style: TextStyle(
                          //               //                 fontSize:
                          //               //                 20.0,
                          //               //                 fontWeight: FontWeight
                          //               //                     .w600,
                          //               //                 color:
                          //               //                 Colors.black),
                          //               //           )
                          //               //               : Text(
                          //               //               0.toString() +
                          //               //                   '%',
                          //               //               style: TextStyle(
                          //               //                   fontSize:
                          //               //                   20.0,
                          //               //                   fontWeight:
                          //               //                   FontWeight
                          //               //                       .w600,
                          //               //                   color:
                          //               //                   Colors
                          //               //                       .black))
                          //               //               : Text("0%",
                          //               //               style: TextStyle(
                          //               //                   fontSize:
                          //               //                   20.0,
                          //               //                   fontWeight:
                          //               //                   FontWeight
                          //               //                       .w600,
                          //               //                   color: Colors
                          //               //                       .black)),
                          //               //           backgroundColor:
                          //               //           Colors.black12,
                          //               //           circularStrokeCap:
                          //               //           CircularStrokeCap
                          //               //               .round,
                          //               //           progressColor:
                          //               //           Colors.green,
                          //               //         ),
                          //               //         SizedBox(
                          //               //           height: 15,
                          //               //         ),
                          //               //         courseData != null
                          //               //             ? Text(courseData[widget.courses![
                          //               //         index] +
                          //               //             "percentage"] !=
                          //               //             null
                          //               //             ? courseData[widget.courses![index] +
                          //               //             "percentage"] >
                          //               //             100
                          //               //             ? "100%"
                          //               //             : courseData[widget.courses![index] +
                          //               //             "percentage"]
                          //               //             .toString() +
                          //               //             "%"
                          //               //             : "0%")
                          //               //             : Text("0%")
                          //               //       ],
                          //               //     )
                          //               //     : SizedBox()
                          //               // Column(
                          //               //   mainAxisAlignment: width>700?MainAxisAlignment.center:MainAxisAlignment.end,
                          //               //   children: [
                          //               //     CircularPercentIndicator(
                          //               //       radius: width>700?70.0:30.0,
                          //               //       lineWidth: width>700?10.0:5.0,
                          //               //       animation: true,
                          //               //       percent: 10/100,
                          //               //       center: Text(
                          //               //         10.toString() + "%",
                          //               //         style: TextStyle(
                          //               //             fontSize: width>700?20.0:14,
                          //               //             fontWeight: FontWeight.w600,
                          //               //             color: Colors.black),
                          //               //       ),
                          //               //       backgroundColor: Colors.black12,
                          //               //       circularStrokeCap: CircularStrokeCap.round,
                          //               //       progressColor: Colors.green,
                          //               //     ),
                          //               //     SizedBox(height: 15,),
                          //               //     Text("10%")
                          //               //   ],
                          //               // ),
                          //             ],
                          //           ),
                          //         );
                          //       } else {
                          //         return Container();
                          //       }
                          //     },
                          //   ),
                          // );

                          return SizedBox(
                            child: ListView.builder(
                              itemCount: courseList.length,
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
                                      //                 width: 110,
                                      //                 height: 100,
                                      //                 decoration: BoxDecoration(
                                      //                     borderRadius:
                                      //                         BorderRadius.circular(10)),
                                      //                 child: CachedNetworkImage(
                                      //                   imageUrl: courseList[index]
                                      //                       .courseImageUrl,fit: BoxFit.contain,
                                      //                   placeholder: (context, url) =>
                                      //                       Container(
                                      //                         width: 120,
                                      //                         height: 100,
                                      //                         decoration: BoxDecoration(
                                      //                             color:
                                      //                             Colors.grey.withOpacity(0.3),
                                      //                             borderRadius:
                                      //                             BorderRadius.circular(10)),

                                      //                   ),
                                      //                 ),
                                      //               ),
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
                                              courseList[index].courseName,
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
                                                "Estimated learning time: ${courseList[index].duration == null ? "0" : courseList[index].duration}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(fontSize: 12)),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                index == 0
                                                    ? SizedBox(
                                                        width: 120,
                                                        height: 30,
                                                        child: MaterialButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          onPressed: () {
                                                            courseId = courseList[
                                                                    index]
                                                                .courseDocumentId;
                                                            // setState(
                                                            //         () {
                                                            //       courseId = courseList[index].courseDocumentId;
                                                            //     });
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        VideoScreen(
                                                                  courseName: courseList[
                                                                          index]
                                                                      .courseName,
                                                                  isdemo: false,
                                                                  sr: 1,
                                                                  courses: widget
                                                                      .courses,
                                                                  comboCourseName:
                                                                      widget
                                                                          .courseName,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "Resume learning",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          8),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          color: Colors.purple,
                                                        ),
                                                      )
                                                    : courseData[widget.courses![
                                                                        0] +
                                                                    "percentage"] ==
                                                                100 ||
                                                            oldModuleProgress
                                                        ? SizedBox(
                                                            width: 120,
                                                            height: 30,
                                                            child:
                                                                MaterialButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              onPressed: () {
                                                                courseId = courseList[
                                                                        index]
                                                                    .courseDocumentId;
                                                                // setState(
                                                                //         () {
                                                                //       courseId = courseList[index].courseDocumentId;
                                                                //     });
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            VideoScreen(
                                                                      courseName:
                                                                          courseList[index]
                                                                              .courseName,
                                                                      isdemo:
                                                                          false,
                                                                      sr: 1,
                                                                      courses:
                                                                          widget
                                                                              .courses,
                                                                      comboCourseName:
                                                                          widget
                                                                              .courseName,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 15,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Resume learning",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              8),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 100,
                                                            child: Text(
                                                              'Complete First Module To Unlock',
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                FutureBuilder(
                                                    future: getProgress(index),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return CircularPercentIndicator(
                                                          radius: 25,
                                                          lineWidth: 3,
                                                          animation: true,
                                                          percent: snapshot
                                                                      .data ==
                                                                  'null'
                                                              ? 0
                                                              : double.parse(
                                                                      snapshot
                                                                          .data
                                                                          .toString()) /
                                                                  100,
                                                          center: Text(
                                                            snapshot.data ==
                                                                    'null'
                                                                ? '0%'
                                                                : '${snapshot.data}%',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          backgroundColor:
                                                              Colors.black12,
                                                          circularStrokeCap:
                                                              CircularStrokeCap
                                                                  .round,
                                                          progressColor:
                                                              Colors.green,
                                                        );
                                                      } else {
                                                        return SizedBox();
                                                      }
                                                    })
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
                          );
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
            ),
          )),
    );
  }
}

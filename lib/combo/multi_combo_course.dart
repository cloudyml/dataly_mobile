import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/controller/multi_combo_course_controller.dart';
import 'package:cloudyml_app2/module/pdf_course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../module/video_screen.dart';
import 'combo_course.dart';
import 'new_combo_course.dart';



class MultiComboCourse extends StatelessWidget {
  final String? id;
  final String? courseName;
  const MultiComboCourse({Key? key, this.id, this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(

        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/test_developer%2FbackGroundImage.jpg?alt=media&token=c7282af8-222d-4761-89b0-35fa206f0ac1"),
                  fit: BoxFit.fill),
              color: HexColor("#fef0ff"),
            ),
            height: double.infinity,
            width: double.infinity,

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                     Get.back();
                    },
                    child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Icon(Icons.arrow_back_rounded),
                              ),
                              Text(
                                'Back',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: width < 850
                                  ? width < 430
                                  ? 25
                                  : 30
                                  : 40,
                              color: Colors.black)),
                      TextSpan(
                          text: courseName,
                          style: TextStyle(
                              fontSize: width < 850
                                  ? width < 430
                                  ? 25
                                  : 30
                                  : 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GetX<MultiComboCourseController>(
                    init: MultiComboCourseController(courseId: id),
                    builder: (controller) =>
                    controller.courseList.isEmpty ?
                    Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(color: Colors.deepPurpleAccent, strokeWidth: 3),
                      ),
                    )  :

                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView.builder(
                            itemCount: controller.courseList.length,
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(bottom: 15),

                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                        height: double.infinity,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            image: DecorationImage(image: NetworkImage(controller.courseList[index]['image_url']),fit: BoxFit.contain)
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),

                                      Expanded(
                                          flex: width < 600 ? 6 : 4,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            // mainAxisAlignment:
                                            // width>700?
                                            // MainAxisAlignment
                                            // .spaceAround,
                                            // :MainAxisAlignment.start,
                                            children: [



                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    controller.courseList[index]['name'],
                                                    style: TextStyle(
                                                        height: 1,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: width >
                                                            700
                                                            ? 25
                                                            : width < 540
                                                            ? 12
                                                            : 14),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 4,
                                                  ),
                                                  SizedBox(
                                                    height: 13,
                                                  ),
                                                  Text(
                                                    controller.courseList[index]['description'],
                                                    style: TextStyle( fontWeight: FontWeight.w500,
                                                        fontSize: width < 540
                                                            ? width < 420
                                                            ? 11
                                                            : 13
                                                            : 14),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 4,

                                                  ),
                                                ],
                                              )
                                              ,
                                              SizedBox(height: 15,),

                                              ElevatedButton(
                                                  onPressed: () async {
                                                    if (!controller.courseList[index]['combo']) {

                                                      if (controller.courseList[index]['courseContent'] ==
                                                          'pdf') {
                                                        Navigator.push(
                                                          context,
                                                          PageTransition(
                                                            duration: Duration(
                                                                milliseconds: 400),
                                                            curve:
                                                            Curves.bounceInOut,
                                                            type: PageTransitionType
                                                                .rightToLeftWithFade,
                                                            child: PdfCourseScreen(

                                                              curriculum: controller.courseList[index]['curriculum1']
                                                              as Map<String,
                                                                  dynamic>,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator.push(
                                                          context,
                                                          PageTransition(
                                                            duration: Duration(milliseconds: 400),
                                                            curve: Curves.bounceInOut,
                                                            type: PageTransitionType
                                                                .rightToLeftWithFade,
                                                            child:
                                                            VideoScreen(
                                                              isdemo: true,
                                                              courseName:
                                                              controller.courseList[index]['curriculum1']
                                                                  .keys
                                                                  .toList()
                                                                  .first
                                                                  .toString(),
                                                              sr: 1,
                                                            ),
                                                          ),
                                                        );


                                                      }
                                                    }  else {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("courses")
                                                          .doc(controller.courseList[index]['docid'])
                                                          .update({
                                                        'fIndex': index.toString(),
                                                      });

                                                      ComboCourse.comboId.value =
                                                      controller.courseList[index]['id'];
                                                      final id = index.toString();
                                                      final courseName =
                                                      controller.courseList[index]['name'];
                                                      Get.to(() => NewComboCourse(courseName: courseName,
                                                        courses: controller.courseList[index]['courses'],
                                                      ));


                                                    }

},
                                                  child: Text("Go To Course"),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),

                                                          )
                                                      )
                                                  )
                                              )

                                            ],
                                          )),

                                    ],
                                  ),
                                ),
                              );

                            }),
                      ),
                    ),
                  ),


                ],
              ),
            )
        ),
      ),
    );


  }
}
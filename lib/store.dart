import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/combo/combo_store.dart';
import 'package:cloudyml_app2/combo/multi_combo_feature_screen.dart';
import 'package:cloudyml_app2/free_course.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/home.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'free_course.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool paidforallcources = false;

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> courseList = Provider.of<List<CourseDetails>>(context);
    List<CourseDetails> course = [];
    List<dynamic> courseToRemove = [];
    var cou = [];
    bool everycourseispurchased = false;
    UserDetails? userCourse = Provider.of<UserDetails?>(context, listen: true);
    print("hhhhhhhhhhhhhhhhh");
    print("course list: ${courseList}");

    for (CourseDetails element in courseList) {
      print("show${element.show}");
      print(userCourse);
      print(userCourse?.paidCoursesId);

      // logic for showing if complete courses has been taken or not
      try {
        for (var i in userCourse!.paidCoursesId) {
          if (i == element.courseId) {
            courseToRemove.add(i);
          }
          if (i == element.courseId) {
            if (element.isItComboCourse) {
              courseToRemove = courseToRemove + element.courses;
            }
          }
          // if (userCourse?.paidCoursesId[i] == "CML1") {
          //   setState(() {
          //     paidforallcources = true;
          //   });
          // }
        }
      } catch (e) {}

      // print(element.courseName);
      // print(userCourse!.paidCoursesId!.contains(element!.courseId));

      // if (userCourse != null &&
      //     userCourse!.paidCoursesId!.contains(element!.courseId)) {
      //   print("sdfsdfsdweddd${element.isItComboCourse}");
      //   // reverse the bool value
      //   // if (!element.isItComboCourse) {
      //   for (String id in element.courses) {
      //     print(id);
      //     courseToRemove.add(id);
      //   }
      //   courseToRemove.add(element!.courseId);
      //   print(courseToRemove);
      //   // }

      // }
      // print("iiiiiiiiiiiiiiiiiii");
    }
    // for (CourseDetails element in courseList) {
    //   if (courseToRemove.isNotEmpty &&
    //       !courseToRemove.contains(element.courseId)) {
    //     print(element.courseName);
    //     if (element.show == true) {
    //       course.add(element);
    //       print("elements $element");
    //     }
    //   }
    // }
    try {
      course = courseList;
      var valuedata = [];
      courseList.forEach((element) {
        courseToRemove.forEach((i) {
          if (element.courseId == i) {
            valuedata.add(element);
          }
        });
      });

      print("startdddddddddddddddd");
      //logic for removing
      var set1 = Set.from(course);
      var set2 = Set.from(valuedata);
      setState(() {
        course = List.from(set1.difference(set2));
        if (course == []) {
          everycourseispurchased = true;
        }
        print("sfjdsdjflsdfls$course");
      });

      //logic for show parameter

      for (var i in course) {
        try {
          if (i.show == true) {
            cou.add(i);
          }
        } catch (e) {
          print("uiooiio${e.toString()}");
        }
      }
      // for (CourseDetails element in courseList) {
      //   for (var i in courseToRemove) {
      //     if (element.courseId == i) {
      //       print(i);
      //       setState(() {
      //         course.remove(element);
      //         print(i);
      //         print(course);
      //       });
      //     }
      //   }
      // }
      // print("enddddddddddddddddd");
      // print(course);
      // for (var j in course) {
      //   print(j.courseId);
      // }

      // setState(() {
      //   course = courseList;
      //   print("dsdsdfsdfwerwer${course}");
      // });
    } catch (e) {
      print("tttttttttttttttttt${e.toString()}");
    }

    return Scaffold(
      key: _scaffoldKey,
      // drawer: dr(context),
      body: Container(
        color: Colors.deepPurple,
        child: Stack(children: [
          Positioned(
            // left: -50,
            // width: 100,
            // height: 100,
            top: -98.00000762939453,
            left: -88.00000762939453,
            // child: CircleAvatar(
            //   radius: 70,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Positioned(
            // right: MediaQuery.of(context).size.width * (-.16),
            // bottom: MediaQuery.of(context).size.height * .7,
            top: 73.00000762939453,
            left: 309,

            // child: CircleAvatar(
            //   radius: 80,
            //   backgroundColor: Color.fromARGB(255, 173, 149, 149),
            // ),
            child: Container(
                width: 161.99998474121094,
                height: 161.99998474121094,
                decoration: BoxDecoration(
                  color: Color.fromARGB(55, 126, 106, 228),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      161.99998474121094, 161.99998474121094)),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Color.fromARGB(214, 83, 109, 254),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          print("yyy");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          // Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                      ),
                      Text(
                        'Store',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                !everycourseispurchased
                    ? Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.white),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        childAspectRatio: .68),
                                itemCount: cou.length,
                                itemBuilder: (context, index) {
                                  print(cou);
                                  print(cou.length);
                                  print(index);
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        courseId = cou[index].courseDocumentId;
                                      });

                                      print("uuuuuuuuuu ${courseId}");
                                      if (cou[index].isItComboCourse) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ComboStore(
                                              courses: cou[index].courses,
                                              cID: courseId,
                                              courseP: cou[index].coursePrice,
                                              courseName: cou[index].courseName,
                                            ),
                                          ),
                                        );
                                      } else if (cou[
                                      index]
                                          .multiCombo ==
                                          true) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MultiComboFeatureScreen(
                                          cID: cou[
                                          index]
                                              .courseDocumentId,
                                          courseName:
                                          cou[
                                          index]
                                              .courseName,
                                          id: cou[
                                          index]
                                              .courseId,
                                          coursePrice: cou[
                                          index]
                                              .coursePrice,

                                        ),));

                                      }else if(cou[index].free == true ||cou[index].free != null){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCourseScreen(),));
                                      }

                                       
                                      else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                   CatelogueScreen()),
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color:
                                            Color.fromARGB(192, 255, 255, 255),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(168, 133, 250,
                                                0.7099999785423279),
                                            offset: Offset(2, 2),
                                            blurRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(08.0),
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      cou[index].courseImageUrl,
                                                  placeholder: (context, url) =>
                                                      // CircularProgressIndicator(),
                                                      Container(
                                                    child: Image(
                                                      // height: MediaQuery.of(context).size.height / 3,
                                                      // fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          'https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fnew.jpg?alt=media&token=49128d37-10f6-4139-ab2c-974ff953f278'),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                              child: Text(
                                                cou[index].courseName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .035),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .004,
                                            ),
                                            Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment
                                              //         .center,
                                              children: [
                                                Text(
                                                  cou[index].courseLanguage,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .03),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .02,
                                                ),
                                                Text(
                                                  '||',
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .03),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .02,
                                                ),
                                                Text(
                                                  cou[index].numOfVideos,
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .03),
                                                ),
                                                // const SizedBox(
                                                //   height: 10,
                                                // ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .015,
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Container(
                                            //       width:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .width *
                                            //               0.20,
                                            //       height:
                                            //           MediaQuery.of(context)
                                            //                   .size
                                            //                   .height *
                                            //               0.030,
                                            //       decoration: BoxDecoration(
                                            //           borderRadius:
                                            //               BorderRadius
                                            //                   .circular(10),
                                            //           color: Colors.green),
                                            //       child: const Center(
                                            //         child: Text(
                                            //           'ENROLL NOW',
                                            //           style: TextStyle(
                                            //               fontSize: 10,
                                            //               color:
                                            //                   Colors.white),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 15,
                                            //     ),
                                            //     Text(
                                            //       map['Course Price'],
                                            //       style: const TextStyle(
                                            //         fontSize: 13,
                                            //         color: Colors.indigo,
                                            //         fontWeight:
                                            //             FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Row(
                                              children: [
                                                // SizedBox(
                                                //     width: MediaQuery.of(
                                                //         context)
                                                //         .size
                                                //         .width *
                                                //         .23),
                                                Text(
                                                  '₹${cou[index].coursePrice}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .03,
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Text(
                            "You have already purchased all the courses,"
                            "\nAny newly added course will start showing here, "
                            "\nHappy Learning",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

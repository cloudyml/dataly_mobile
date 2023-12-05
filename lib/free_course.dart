import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/widgets/curriculam.dart';
import 'package:dataly_app/widgets/start_free_bottomsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

import 'fun.dart';
import 'globals.dart';
import 'home.dart';
import 'models/course_details.dart';
import 'module/video_screen.dart';

class FreeCourseScreen extends StatefulWidget {
  const FreeCourseScreen({Key? key}) : super(key: key);

  @override
  State<FreeCourseScreen> createState() => _FreeCourseScreenState();
}

class _FreeCourseScreenState extends State<FreeCourseScreen> {
  String? couId;
  String? cName;
  @override
  Widget build(BuildContext context) {
    late final size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            // print('Check');
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 20),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottomSheet: StartFreeBottomsheet(onTap: (){


        addCoursetoUser(couId!, cName!);
      }),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: course.length,
            itemBuilder: (BuildContext context, index) {
              if (courseId == course[index].courseDocumentId) {
                couId = course[index].courseId;
                cName = course[index].courseName;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 00.0, right: 18, left: 18, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              course[index].courseImageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            course[index].courseName,
                                            style: TextStyle(
                                                fontFamily: 'Bold',
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            course[index].courseDescription,
                                            style: TextStyle(
                                                fontFamily: 'Regular',
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          includes(context),
                          SizedBox(
                            height: 20,
                          ),
                          //includes(context),
                          Container(
                            child: Curriculam(
                              courseDetail: course[index],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ))
        ],
      ),
    );
  }

  void addCoursetoUser(String id, String courseName) async {
    
    await FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'paidCourseNames': FieldValue.arrayUnion([id])
    });
    Navigator.push(
      context,
      PageTransition(
        duration: Duration(milliseconds: 400),
        curve: Curves.bounceInOut,
        type:
        PageTransitionType.rightToLeftWithFade,
        child: VideoScreen(
          isdemo: true,
          courseName: courseName,
          sr: 1,
        ),
      ),
    );

    // Navigator.pushAndRemoveUntil(
    //     context,
    //
    //     PageTransition(
    //       duration: Duration(milliseconds: 200),
    //       curve: Curves.bounceInOut,
    //       type: PageTransitionType.rightToLeftWithFade,
    //       child: HomePage(),
    //     ),
    //         (route) => false);
  }

}

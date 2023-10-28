import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/combo/paynow_feature.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/widgets/coupon_code.dart';
import 'package:cloudyml_app2/fun.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/catalogue_screen.dart';
import 'package:cloudyml_app2/payment_screen.dart';
import 'package:cloudyml_app2/widgets/pay_now_bottomsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:share_extend/share_extend.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../Services/code_generator.dart';
import '../Services/deeplink_service.dart';
import '../home.dart';
import '../homepage.dart';
import '../my_Courses.dart';

class ComboStore extends StatefulWidget {
  final trialCourse;
  // final international;
  final List<dynamic>? courses;
  final courseName;
  final String? id;
  final String? cName;
  final String? courseP;
  final String? cID;
  final String? image;
  ComboStore(
      {Key? key,
      this.courses,
      // this.international,
      this.courseName,
      this.id,
      this.cName,
      this.courseP,
      this.cID,
      this.image,
      this.trialCourse})
      : super(key: key);

  @override
  State<ComboStore> createState() => _ComboStoreState();
}

class _ComboStoreState extends State<ComboStore> with CouponCodeMixin {
  // var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  String? id;
  final ScrollController _scrollController = ScrollController();

  String couponAppliedResponse = "";

  String coursePrice = "";
  var moneyrefcode;

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  var moneyreferalcode;

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;
  var moneyreferallink;
  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  String name = "";
  GlobalKey _positionKey = GlobalKey();

  List<CourseDetails> featuredCourse = [];

  setFeaturedCourse(List<CourseDetails> course) {
    featuredCourse.clear();

    course.forEach((element) {
      print(' $element ');
      if (element.courseDocumentId == widget.cID) {
        featuredCourse.add(element);
        // featuredCourse.add(element.courses);

        print('element ${featuredCourse[0].courseId} ');
      }
    });
    print('function ');
  }

  void lookformoneyref() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(uid)
          .get()
          .then((value) => {moneyrefcode = value.data()!["moneyrefcode"]});
    } catch (e) {}
    try {
      print("moneyrefcode: ${moneyrefcode}");
      moneyreferalcode = await CodeGenerator()
          .generateCodeformoneyreward('moneyreward-$courseId');
      moneyreferallink =
          await DeepLinkService.instance?.createReferLink(moneyreferalcode);
      print("this is the kings enargy: ${moneyreferallink}");
      if (moneyrefcode == null) {
        FirebaseFirestore.instance.collection("Users_dataly").doc(uid).update({
          "moneyrefcode": "$moneyreferalcode",
        });
      }
    } catch (e) {}
  }

  var international;
  Map<String, dynamic> comboMap = {};
  void getCourseName() async {
    print('this idd ${widget.cID}');
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.cID)
        .get()
        .then((value) {
      comboMap = value.data()!;
      international = value.data()!['international'];
      print('international $international');
    });
  }

  Map userMap = Map<String, dynamic>();

  void dbCheckerForPayInParts() async {
    try {
      DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // print(map['payInPartsDetails'][id]['outStandingAmtPaid']);
      setState(() {
        userMap = userDocs.data() as Map<String, dynamic>;
        // whetherSubScribedToPayInParts =
        //     !(!(map['payInPartsDetails']['outStandingAmtPaid'] == null));
      });
    } catch (e) {
      print("ggggggggggg $e");
    }
  }

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

  @override
  void initState() {
    dbCheckerForPayInParts();
    lookformoneyref();
    getTheStreamData();
    getCourseName();
    super.initState();
  }

  void _scrollListener() {
    RenderBox? box =
        _positionKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double pixels = position.dy;
    // ComboStore._closeBottomSheetAtInCombo.value = pixels;
    // ComboStore._currentPosition.value = _scrollController.position.pixels;
    // print(pixels);
    print(_scrollController.position.pixels);
  }

  @override
  void dispose() {
    super.dispose();
    couponCodeController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final width = MediaQuery.of(context).size.width;
    var horizontalScale = screenWidth / mockUpWidth;
    return Scaffold(
      bottomSheet: widget.trialCourse != null && widget.trialCourse!
          ? PayNowBottomSheetfeature(
              context: context,
              coursePrice: '₹${widget.courseP!}/-',
              map: comboMap,
              isItComboCourse: true,
              cID: widget.cID!,
              usermap: userMap,
            )
          : PayNowBottomSheet(
              coursePrice: widget.courseP!,
              international:
                  international != null && international == true ? true : false,
              map: comboMap,
              cID: widget.cID,
              isItComboCourse: true,
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2FBG.png?alt=media&token=1b65f9eb-26c2-45fc-a70a-dbf0be2bf7f8"),
                    fit: BoxFit.fill),
                color: HexColor("#fef0ff"),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15.sp,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.black,
                              size: 25.sp,
                            ),
                            onPressed: () async {
                              // Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 25.sp,
                            ),
                            onPressed: () async {
                              if (moneyreferallink.toString() != 'null') {
                                ShareExtend.share(
                                    moneyreferallink.toString(), "text");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20.sp,
                                color: Colors.black)),
                        TextSpan(
                            text: '${widget.courseName}',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    StreamBuilder(
                        stream: counterStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && widget.courses != null) {
                            List courseList = [];
                            for (var i in widget.courses!) {
                              int count = 0;
                              for (var j in course) {
                                if (i == j.courseId) {
                                  courseList.add(j);
                                  count = 1;
                                }
                              }
                              count == 0 ? widget.courses?.remove(i) : null;
                              print("**((($count");
                            }
                            print("listoooo $courseList");
                            return Column(
                              children: List.generate(
                                courseList.length,
                                (index) {
                                  print("snapdatassss");
                                  print(
                                      "the data is==${snapshot.data.toString()}");
                                  // print("Courses list ${courseList}");
                                  if (courseList.length > index) {
                                    print(
                                        "Duration ${courseList[index].duration}");
                                    return Container(
                                      padding: EdgeInsets.all(12.sp),
                                      margin: EdgeInsets.only(bottom: 15.sp),
                                      width: Adaptive.w(100),
                                      height: Adaptive.h(18),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.sp),
                                          color: Colors.white),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Expanded(
                                            //     flex: width < 600 ? 4 : 3,
                                            //     child: Padding(
                                            //       padding: EdgeInsets.all(5),
                                            //       child: ClipRRect(
                                            //         borderRadius:
                                            //         BorderRadius.circular(
                                            //             25.sp),
                                            //         // child:
                                            //         // Container(
                                            //         //   // width: 130,
                                            //         //   // height: 95,
                                            //         //   decoration: BoxDecoration(
                                            //         //       borderRadius: BorderRadius.circular(15.sp)),
                                            //         //   child: CachedNetworkImage(
                                            //         //     imageUrl:
                                            //         //     courseList[index]
                                            //         //         .courseImageUrl,
                                            //         //     placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                            //         //     errorWidget: (context, url, error) => Icon(Icons.error),
                                            //         //   ),
                                            //         // ),
                                            //       ),
                                            //     )),

                                            Expanded(
                                                flex: width < 600 ? 6 : 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
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
                                                          courseList[index]
                                                              .courseName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.sp),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 10.sp,
                                                        ),
                                                        Text(
                                                            "Estimates learning time: ${courseList[index].duration == null ? "0" : courseList[index].duration}",
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    14.sp)),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ));
        },
      ),
    );
  }
}

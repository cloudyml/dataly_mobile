import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/models/course_details.dart';
import 'package:dataly_app/widgets/coupon_code.dart';
import 'package:dataly_app/widgets/curriculam.dart';
import 'package:dataly_app/fun.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/widgets/pay_now_bottomsheet.dart';
import 'package:dataly_app/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:share_extend/share_extend.dart';

import 'Services/code_generator.dart';
import 'Services/deeplink_service.dart';

class CatelogueScreen extends StatefulWidget {
  final hideBottomSheet;
  String courseImage;
  String description;
  String courseName;
  CatelogueScreen({Key? key, this.description = '', this.courseName = '', this.hideBottomSheet = true, this.courseImage = ''}) : super(key: key);
  static ValueNotifier<String> coursePrice = ValueNotifier('');
  // static ValueNotifier<Map<String, dynamic>>? map = ValueNotifier({});
  static ValueNotifier<double> _currentPosition = ValueNotifier<double>(0.0);
  static ValueNotifier<double> _closeBottomSheetAt = ValueNotifier<double>(0.0);
  @override
  State<CatelogueScreen> createState() => _CatelogueScreenState();
}

class _CatelogueScreenState extends State<CatelogueScreen>
    with SingleTickerProviderStateMixin, CouponCodeMixin {
  TabController? _tabController;
  // var _razorpay = Razorpay();
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  GlobalKey? _positionKey = GlobalKey();
  var uid = FirebaseAuth.instance.currentUser!.uid;

  // double closeBottomSheetAt = 0.0;
  // final scaffoldState = GlobalKey<ScaffoldState>();
  Map<String, dynamic> courseMap = {};

  String coursePrice = "";

  String? id;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  String? _linkMessage;

  var moneyrefcode;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  bool showCurriculum = false;

  bool bottomSheet = false;

  var moneyreferalcode;

  var moneyreferallink;

  @override
  void initState() {
    super.initState();
    getCourseName();
    lookformoneyref();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  void lookformoneyref() async {
    try {
      print("moneyrefcode: ${moneyrefcode}");
      moneyreferalcode = await CodeGenerator()
          .generateCodeformoneyreward('moneyreward-$courseId');
      moneyreferallink =
          await DeepLinkService.instance?.createReferLink(moneyreferalcode);
      print("this is the kings enargy: ${moneyreferallink}");
    } catch (e) {
      print(e.toString());
    }
  }

  var international;
  void getCourseName() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get()
        .then((value) {
      setState(() {
        courseMap = value.data()!;
        coursePrice = value.data()!['Course Price'];
        international = value.data()!['international'];
      });
    });
  }

  void _scrollListener() {
    RenderBox? box =
        _positionKey!.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double pixels = position.dy;
    CatelogueScreen._closeBottomSheetAt.value = pixels;
    CatelogueScreen._currentPosition.value = _scrollController.position.pixels;
    print(pixels);
    print(_scrollController.position.pixels);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    couponCodeController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    List<CourseDetails> course = Provider.of<List<CourseDetails>>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            moneyreferallink.toString() != 'null' ? false : true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.black,
            ),
            onPressed: () async {
              if (moneyreferallink.toString() != 'null') {
                ShareExtend.share(moneyreferallink.toString(), "text");
              }
            },
          ),
        ],
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
      bottomSheet: widget.hideBottomSheet ? SizedBox() : PayNowBottomSheet(
        international: international != null && international == true
            ? international
            : false,
        coursePrice: coursePrice,
        map: courseMap,
        isItComboCourse: false,
        // closeBottomSheetAt: closeBottomSheetAt(positionKey),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  top: 00.0, right: 18, left: 18, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        widget.courseImage,
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
                          widget.courseName,
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
                          widget.description,
                          style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  includes(context),
                  Container(
                    child: Curriculam(
                      courseDetail: course[0],
                    ),
                  ),
                  Container(
                    key: _positionKey,
                  ),
                  widget.hideBottomSheet ? SizedBox() : Ribbon(
                    nearLength: 1,
                    farLength: .5,
                    title: ' ',
                    titleStyle: TextStyle(
                        color: Colors.black,
                        // Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    color: Color.fromARGB(255, 11, 139, 244),
                    location: RibbonLocation.topStart,
                    child: Container(
                      //  key:key,
                      // width: width * .9,
                      // height: height * .5,
                      color: Color.fromARGB(255, 24, 4, 104),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          //  key:Gkey,
                          children: [
                            SizedBox(
                              height: height * .03,
                            ),
                            Text(
                              'Complete Course Fee',
                              style: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 21,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '( Everything with Lifetime Access )',
                              style: TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 11,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // Text(
                            //   '₹${(course[index].coursePrice).toString()}/-',
                            //   style: TextStyle(
                            //       fontFamily: 'Medium',
                            //       fontSize: 30,
                            //       color: Colors.white),
                            // ),
                            SizedBox(height: 35),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PaymentScreen(
                                //       // map: courseMap,
                                //       isItComboCourse: false,
                                //     ),
                                //   ),
                                // );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    color: Color.fromARGB(
                                        255, 119, 191, 249),
                                    gradient: gradient),
                                height: height * .08,
                                width: width * .6,
                                child: Center(
                                  child: Text(
                                    'Buy Now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ListView.builder(
            //   controller: _scrollController,
            //   itemCount: course.length,
            //   itemBuilder: (BuildContext context, index) {
            // if (course[index].courseName == "null") {
            //   return Container();
            // }
            // if (courseId == course[index].courseDocumentId) {
            //   CatelogueScreen.coursePrice.value = course[index].coursePrice;
            //   // CatelogueScreen.map!.value = map;
            //   return Stack(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(
            //             top: 00.0, right: 18, left: 18, bottom: 10),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             SingleChildScrollView(
            //               child: Column(
            //                 children: [
            //                   ClipRRect(
            //                     borderRadius: BorderRadius.circular(28),
            //                     child: Container(
            //                       height:
            //                           MediaQuery.of(context).size.height *
            //                               0.3,
            //                       width:
            //                           MediaQuery.of(context).size.height *
            //                               0.6,
            //                       child: CachedNetworkImage(
            //                         imageUrl:
            //                             widget.courseImage,
            //                         fit: BoxFit.cover,
            //                         placeholder: (context, url) => Center(
            //                             child:
            //                                 CircularProgressIndicator()),
            //                         errorWidget: (context, url, error) =>
            //                             Icon(Icons.error),
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 20,
            //                   ),
            //                   Column(
            //                     crossAxisAlignment:
            //                         CrossAxisAlignment.start,
            //                     children: [
            //                       Container(
            //                         width: MediaQuery.of(context)
            //                                 .size
            //                                 .width *
            //                             0.9,
            //                         child: Text(
            //                           widget.courseName,
            //                           style: TextStyle(
            //                               fontFamily: 'Bold',
            //                               color: Colors.black,
            //                               fontSize: 20),
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         height: 10,
            //                       ),
            //                       Container(
            //                         width: MediaQuery.of(context)
            //                                 .size
            //                                 .width *
            //                             0.9,
            //                         child: Text(
            //                           widget.description,
            //                           style: TextStyle(
            //                               fontFamily: 'Regular',
            //                               color: Colors.black,
            //                               fontSize: 14),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             SizedBox(
            //               height: 45,
            //             ),
            //             includes(context),
            //             Container(
            //               child: Curriculam(
            //                 courseDetail: course[index],
            //               ),
            //             ),
            //             Container(
            //               key: _positionKey,
            //             ),
            //             widget.hideBottomSheet ? SizedBox() : Ribbon(
            //               nearLength: 1,
            //               farLength: .5,
            //               title: ' ',
            //               titleStyle: TextStyle(
            //                   color: Colors.black,
            //                   // Colors.white,
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold),
            //               color: Color.fromARGB(255, 11, 139, 244),
            //               location: RibbonLocation.topStart,
            //               child: Container(
            //                 //  key:key,
            //                 // width: width * .9,
            //                 // height: height * .5,
            //                 color: Color.fromARGB(255, 24, 4, 104),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(40.0),
            //                   child: Column(
            //                     //  key:Gkey,
            //                     children: [
            //                       SizedBox(
            //                         height: height * .03,
            //                       ),
            //                       Text(
            //                         'Complete Course Fee',
            //                         style: TextStyle(
            //                             fontFamily: 'Bold',
            //                             fontSize: 21,
            //                             color: Colors.white),
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Text(
            //                         '( Everything with Lifetime Access )',
            //                         style: TextStyle(
            //                             fontFamily: 'Bold',
            //                             fontSize: 11,
            //                             color: Colors.white),
            //                       ),
            //                       SizedBox(
            //                         height: 30,
            //                       ),
            //                       Text(
            //                         '₹${(course[index].coursePrice).toString()}/-',
            //                         style: TextStyle(
            //                             fontFamily: 'Medium',
            //                             fontSize: 30,
            //                             color: Colors.white),
            //                       ),
            //                       SizedBox(height: 35),
            //                       InkWell(
            //                         onTap: () {
            //                           // Navigator.push(
            //                           //   context,
            //                           //   MaterialPageRoute(
            //                           //     builder: (context) => PaymentScreen(
            //                           //       // map: courseMap,
            //                           //       isItComboCourse: false,
            //                           //     ),
            //                           //   ),
            //                           // );
            //                         },
            //                         child: Container(
            //                           decoration: BoxDecoration(
            //                               borderRadius:
            //                                   BorderRadius.circular(30),
            //                               color: Color.fromARGB(
            //                                   255, 119, 191, 249),
            //                               gradient: gradient),
            //                           height: height * .08,
            //                           width: width * .6,
            //                           child: Center(
            //                             child: Text(
            //                               'Buy Now',
            //                               textAlign: TextAlign.center,
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontSize: 20),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   );
            // } else {
            //   return Container();
            // }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}

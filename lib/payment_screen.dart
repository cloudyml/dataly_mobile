import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/payment/stripe/checkout.dart';
import 'package:cloudyml_app2/screens/chat_group.dart';
import 'package:cloudyml_app2/screens/flutter_flow/flutter_flow_util.dart';
import 'package:cloudyml_app2/widgets/coupon_code.dart';
import 'package:cloudyml_app2/widgets/inter_payment_portal.dart';
import 'package:cloudyml_app2/widgets/payment_portal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:star_rating/star_rating.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  // final Map<String, dynamic>? map;
  final cID;
  final bool isItComboCourse;
  const PaymentScreen(
      {Key? key, //this.map,
      required this.cID,
      required this.isItComboCourse})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with CouponCodeMixin {
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // GlobalKey key = GlobalKey();
  // final scaffoldState = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showBottomSheet = ValueNotifier(false);
  // VoidCallback? _showPersistentBottomSheetCallBack;

  String? id;
  var coupontext = "Apply Coupon";
  int newcoursevalue = 0;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  bool haveACouponCode = false;
  bool couponCodeApplied = false;
  bool emptyCode = false;
  bool couponExpired = false;
  bool errorOnCoupon = false;
  bool typeOfCouponExpired = false;
  bool isButtonDisabled = false;
  String expiredDate = '';

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  String courseprice = "0";
  String discountvalue = "0";
  bool apply = false;
  String rewardvalue = "0";

  var gstAmount;
  var totalAmount;
  var totalAmountAfterCoupon;
  final textStyle = TextStyle(
      color: Color.fromARGB(223, 48, 48, 49),
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
      fontWeight: FontWeight.w500,
      height: 1);

  Map<String, dynamic> courseMap = {};

  void url_del() {
    FirebaseFirestore.instance.collection('Notice')
      ..doc("7A85zuoLi4YQpbXlbOAh_redirect")
          .update({'url': ""}).whenComplete(() {
        print('feature Deleted');
      });

    FirebaseFirestore.instance.collection('Notice')
      ..doc("NBrEm6KGry8gxOJJkegG_redirect_pay")
          .update({'url': ""}).whenComplete(() {
        print('pay Deleted');
      });
  }

  void getCourseName() async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.cID)
          .get()
          .then((value) {
        setState(() {
          print('course id is ${widget.cID}');
          try {
            courseMap = value.data()!;
          } catch (e) {
            print('courseMap $e');
          }

          // print('paymentscree map ${courseMap.toString()} ');
          // print('gste = ${courseMap['gst'].toString()}');
        });
      });

      // gst function is here

      try {
        if (courseMap['gst'] != null) {
          gstAmount = int.parse('${courseMap['gst']}') *
              0.01 *
              int.parse('${courseMap['Course Price']}');
          print('this is gst ${gstAmount.round()}');

          totalAmount = (int.parse('${courseMap['gst']}') *
                  0.01 *
                  int.parse('${courseMap['Course Price']}')) +
              int.parse('${courseMap['Course Price']}');
          print('this is totalAmount ${totalAmount}');
          totalAmountAfterCoupon = totalAmount;
        } else {
          print('gst is nulll');
        }
      } catch (e) {
        // Fluttertoast.showToast(msg: e.toString());
        print('amount error is here ${e.toString()}');
      }
    } catch (e) {
      print('catalogue screen ${e.toString()} ');
    }

    // reward function
    print("wewewewewew1");
    try {
      courseprice = courseMap['Course Price'].toString().replaceAll("₹", "");
      courseprice = courseprice.replaceAll("/-", "");
    } catch (e) {
      print(e);
    }

    print(courseprice);
    try {
      print("wewewewewew1");
      print(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        print("wewewewewew2");
        rewardvalue = await value.data()!['reward'].toString();
        setState(() {
          rewardvalue;
        });
        print("wewewewewew3");
      });
      print(rewardvalue);
    } catch (e) {
      print("wewewewewew4");
      print(e);
      print("wewewewewew5");
    }
  }

  var couponData;
  var errorOfCouponCode;
  verifyCoupon(couponCode) async {
    try {
      // get firebase id token for authentication
      String? token = await FirebaseAuth.instance.currentUser!.getIdToken();
      var url = Uri.parse(
          'https://us-central1-cloudyml-app.cloudfunctions.net/datalyCheckCouponCode');
      var data = {"couponCode": "$couponCode"};
      var body = json.encode({"data": data});
      print(body);
      var response = await http.post(url, body: body, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
      print("iowefjwefwefwowe");

      if (response.statusCode == 200) {
        couponData = response.body;
        print(response.body);
        return {"Success": true, "message": response.body};
      } else {
        errorOfCouponCode = response.body;
        print(response.body);
        return {"Success": false, "message": response.body};
      }
    } catch (e) {
      print(e);
      return "Failed to get coupon!";
    }
  }

  @override
  void initState() {
    try {
      print("widget yyyyyyyyyyyy: ${widget.cID}");
    } catch (e) {
      print("this is widget.cid ${e}");
    }

    super.initState();
    getCourseName();
  }

  void setcoursevalue() async {
    if (rewardvalue != "0") {
      print(courseprice);
      setState(() {
        discountvalue = rewardvalue;
      });

      print(rewardvalue);
      setState(() {
        rewardvalue = "0";
      });

      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "reward": 0,
      });
    }
  }

  final congoStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 56,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var verticalScale = screenHeight / mockUpHeight;
    var horizontalScale = screenWidth / mockUpWidth;
    url_del();

    return Scaffold(
      // drawer: customDrawer(context),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Payment Details',
            textScaleFactor: min(horizontalScale, verticalScale),
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Poppins',
                fontSize: 35,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
              child: Container(
                height: Adaptive.h(20),
                width: Adaptive.w(100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('Congratulations',
                          textScaleFactor: min(horizontalScale, verticalScale),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.sp,
                            height: 1,
                          )),
                    ),
                    SizedBox(height: 25 * verticalScale),
                    Container(
                      child: Text(
                        '🤩You are just one step away🤩',
                        textScaleFactor: min(horizontalScale, verticalScale),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(
                          2, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                        blurRadius: 25.sp)
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.5.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.sp),
                                child: CachedNetworkImage(
                                  imageUrl: courseMap['image_url'],
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.fill,
                                  height: 50.sp,
                                  width: 53.5.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: Adaptive.w(44.5),
                              padding: EdgeInsets.only(left: 13.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      courseMap['name'],
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Container(
                                    child: Text(
                                      courseMap['description'],
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        height: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'English  ||  online  ||  lifetime',
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                          color: Colors.deepPurple.shade600,
                                          fontSize: 16.sp,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.all(13.sp),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'BILL SUMMARY',
                                      textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DottedLine(
                              dashGapLength: 0,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 13.sp, bottom: 13.sp),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Course Details',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  223, 48, 48, 49),
                                              fontFamily: 'Poppins',
                                              fontSize: 16.sp,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.bold,
                                              height: 1)),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('Unit Price',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  223, 48, 48, 49),
                                              fontFamily: 'Poppins',
                                              fontSize: 16.sp,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.bold,
                                              height: 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DottedLine(
                              dashGapLength: 0,
                            ),
                            SizedBox(height: 15.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Actual Price",
                                    style: textStyle,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    courseMap['dataly_actual_price'] != null ?
                                    'CAD ${courseMap['dataly_actual_price']}' :
                                    courseMap['gst'] != null
                                        ? '₹${courseMap['Amount Payable']}/-'
                                        : courseMap[
                                    'Amount Payable'],
                                    style: TextStyle(
                                        color: Color.fromARGB(223, 48, 48, 49),
                                        fontFamily: 'Poppins',
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 14,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.w500,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Discounted Price',
                                    style: textStyle,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    courseMap['dataly_discounted_price'] != null ?
                                    'CAD ${courseMap['dataly_discounted_price']}' :
                                    courseMap['gst'] != null
                                        ? '₹${courseMap['Course Price']}/-'
                                        : courseMap['Course Price'],
                                    style: textStyle,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.sp),
                            courseMap['dataly_actual_price'] != null ? Container() : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "GST",
                                    style: textStyle,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    courseMap['gst'] != null
                                        ? '₹${gstAmount.round().toString()}/-'
                                        : '18%',
                                    style: textStyle,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.sp,
                            ),
                            haveACouponCode
                                ? Container(
                                    height: 25.sp,
                                    // width: screenWidth/3.5,
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      enabled: !apply ? true : false,
                                      controller: couponCodeController,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        letterSpacing: 1.2,
                                        fontFamily: 'Medium',
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        // constraints: BoxConstraints(minHeight: 52, minWidth: 366),
                                        suffixIcon: TextButton(
                                          child: couponCodeApplied
                                              ? Text(
                                                  'Applied',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 96, 220, 193),
                                                    fontFamily: 'Medium',
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  'Apply',
                                                  style: TextStyle(
                                                    color: Color(0xFF7860DC),
                                                    fontFamily: 'Medium',
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          onPressed:
                                          isButtonDisabled
                                              ? null
                                              : () async {
                                            setState(
                                                    () {
                                                  isButtonDisabled =
                                                  true;
                                                });

                                            try {
                                              if (couponCodeController
                                                  .text
                                                  .isNotEmpty) {

                                                var couponAPI;
                                                couponAPI = await verifyCoupon(
                                                    couponCodeController.text);
                                                if (couponAPI !=
                                                    null) {
                                                }
                                                print(
                                                    'towards logic');
                                                if (couponData !=
                                                    null) {
                                                  print(couponAPI);
                                                  var value =
                                                  json.decode(couponAPI['message']);
                                                  print("return value: ${value['result']}");
                                                  print("return value: ${value['result']['couponType']}");
                                                  print("return value: ${value['result']['couponStartDate']}");

                                                  if (value['result']['couponType'] ==
                                                      'global') {
                                                    var startTime = value['result']['couponStartDate'];
                                                    print(startTime);

                                                    var endTime = value['result']['couponExpiryDate'];
                                                    DateTime dateTime = DateTime.parse(endTime);
                                                    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm a').format(dateTime.toLocal());
                                                    print(formattedDateTime); // prints "2023-04-15"

                                                    if (DateTime.now().isAfter(dateTime)) {
                                                      setState(() {
                                                        emptyCode = false;
                                                        errorOnCoupon = false;
                                                        couponCodeApplied = false;
                                                        couponExpired = true;
                                                        expiredDate = formattedDateTime;
                                                        typeOfCouponExpired = true;
                                                        isButtonDisabled = false;
                                                      });
                                                      // showToast('Sorry, The coupon has expired.');
                                                    } else {
                                                      if (value['result']['couponValue']['type'] == 'percentage') {
                                                        // code for percentage type of coupon
                                                        var percentageValue = int.parse(value['result']['couponValue']['value']) * 0.01;

                                                        print('this is value in $percentageValue');

                                                        if(courseMap['dataly_discounted_price'] != null) {
                                                          discountvalue = (int.parse(courseMap['dataly_discounted_price']) * percentageValue).toString();
                                                        } else {
                                                          discountvalue = (totalAmount * percentageValue).toString();
                                                        }


                                                        print(totalAmount);
                                                        print(discountvalue);

                                                        setState(() {
                                                          totalAmount = totalAmount - double.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          couponExpired = false;
                                                          haveACouponCode = false;
                                                          expiredDate = formattedDateTime;
                                                          typeOfCouponExpired = true;
                                                        });
                                                        print(totalAmount.toString());
                                                        // showToast('Coupon code applied successfully.');
                                                      } else if (value['result']['couponValue']['type'] == 'number') {
                                                        // code for direct amount type of coupon

                                                        var numberValue = int.parse(value['result']['couponValue']['value']);
                                                        print('this is value in $numberValue');
                                                        discountvalue = numberValue.toString();
                                                        print(totalAmount);
                                                        print(discountvalue);

                                                        setState(() {
                                                          totalAmount = totalAmount - int.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          couponExpired = false;
                                                          haveACouponCode = false;
                                                          expiredDate = formattedDateTime;
                                                          typeOfCouponExpired = true;
                                                        });
                                                        print(totalAmount);
                                                        // showToast('Coupon code applied successfully.');
                                                      } else {
                                                        setState(() {
                                                          emptyCode = false;
                                                          errorOnCoupon = true;
                                                          couponCodeApplied = false;
                                                          couponExpired = false;
                                                          isButtonDisabled = false;
                                                        });
                                                        print('111');
                                                        // showToast('invalid type of coupon applied.');
                                                      }
                                                    }
                                                  } else if (value['result']['couponType'] ==
                                                      'course') {
                                                    var startTime = value['result']['couponStartDate'];
                                                    print(startTime);

                                                    var endTime = value['result']['couponExpiryDate'];
                                                    DateTime dateTime = DateTime.parse(endTime);
                                                    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm a').format(dateTime.toLocal());
                                                    print(formattedDateTime); // prints "2023-04-15"

                                                    if (DateTime.now().isAfter(dateTime)) {
                                                      setState(() {
                                                        emptyCode = false;
                                                        errorOnCoupon = false;
                                                        couponCodeApplied = false;
                                                        couponExpired = true;
                                                        expiredDate = formattedDateTime;
                                                        typeOfCouponExpired = true;
                                                        isButtonDisabled = false;
                                                      });
                                                      // showToast('Sorry, The coupon has expired.');
                                                    } else {
                                                      if (value['result']['couponValue']['type'] == 'percentage') {
                                                        // code for percentage type of coupon
                                                        var percentageValue = int.parse(value['result']['couponValue']['value']) * 0.01;
                                                        print('this is value in $percentageValue');
                                                        if(courseMap['dataly_discounted_price'] != null) {
                                                          discountvalue = (int.parse(courseMap['dataly_discounted_price']) * percentageValue).toString();
                                                        } else {
                                                          discountvalue = (totalAmount * percentageValue).toString();
                                                        }
                                                        print(totalAmount);
                                                        print(discountvalue);

                                                        setState(() {
                                                          totalAmount = totalAmount - double.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          couponExpired = false;
                                                          haveACouponCode = false;
                                                          expiredDate = formattedDateTime;
                                                          typeOfCouponExpired = true;
                                                        });
                                                        print(totalAmount.toString());
                                                        // showToast('Coupon code applied successfully.');
                                                      } else if (value['result']['couponValue']['type'] == 'number') {
                                                        // code for direct amount type of coupon

                                                        var numberValue = int.parse(value['result']['couponValue']['value']);
                                                        print('this is value in $numberValue');
                                                        discountvalue = numberValue.toString();
                                                        print(totalAmount);
                                                        print(discountvalue);

                                                        setState(() {
                                                          totalAmount = totalAmount - int.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          couponExpired = false;
                                                          haveACouponCode = false;
                                                          expiredDate = formattedDateTime;
                                                          typeOfCouponExpired = true;
                                                        });
                                                        print(totalAmount);
                                                        // showToast('Coupon code applied successfully.');
                                                      } else {
                                                        setState(() {
                                                          emptyCode = false;
                                                          errorOnCoupon = true;
                                                          couponCodeApplied = false;
                                                          couponExpired = false;
                                                          isButtonDisabled = false;
                                                        });
                                                        print('111');
                                                        // showToast('invalid type of coupon applied.');
                                                      }
                                                    }
                                                  } else if (value['result']['couponType'] ==
                                                      'individual') {
                                                    var endTime = value['result']['couponExpiryDate'];
                                                    DateTime dateTime = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z").parse(endTime, true);
                                                    print("dateTime: ${dateTime}");
                                                    String formattedDateTime = DateFormat('HH:mm a').format(dateTime.toLocal());

                                                    print("printing formatted date ${formattedDateTime}");

                                                    if (DateTime.now().isAfter(dateTime)) {
                                                      setState(() {
                                                        emptyCode = false;
                                                        errorOnCoupon = false;
                                                        couponCodeApplied = false;
                                                        couponExpired = true;
                                                        typeOfCouponExpired = false;
                                                        expiredDate = formattedDateTime;
                                                        isButtonDisabled = false;
                                                      });
                                                    } else {
                                                      if (value['result']['couponValue']['type'] == 'percentage') {
                                                        // code for percentage type of coupon
                                                        var percentageValue = int.parse(value['result']['couponValue']['value']) * 0.01;
                                                        print('this is value in $percentageValue');
                                                        if(courseMap['dataly_discounted_price'] != null) {
                                                          discountvalue = (int.parse(courseMap['dataly_discounted_price']) * percentageValue).toString();
                                                        } else {
                                                          discountvalue = (totalAmount * percentageValue).toString();
                                                        }

                                                        print(totalAmount);
                                                        print(discountvalue);
                                                        setState(() {
                                                          totalAmount = totalAmount - double.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          couponExpired = false;
                                                          haveACouponCode = false;
                                                          typeOfCouponExpired = false;
                                                          expiredDate = formattedDateTime;
                                                        });
                                                        print(totalAmount.toString());
                                                        // showToast('Coupon code applied successfully.');
                                                      } else if (value['result']['couponValue']['type'] == 'number') {
                                                        // code for direct amount type of coupon

                                                        var numberValue = int.parse(value['result']['couponValue']['value']);
                                                        print('this is value in $numberValue');
                                                        discountvalue = numberValue.toString();
                                                        print(totalAmount);
                                                        print(discountvalue);
                                                        setState(() {
                                                          totalAmount = totalAmount - int.parse(discountvalue);
                                                          emptyCode = false;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied = true;
                                                          haveACouponCode = false;
                                                          couponExpired = false;
                                                          typeOfCouponExpired = false;
                                                          expiredDate = formattedDateTime;
                                                        });
                                                        print(totalAmount);
                                                        // showToast('Coupon code applied successfully.');
                                                      } else {
                                                        setState(() {
                                                          emptyCode = false;
                                                          errorOnCoupon = true;
                                                          couponCodeApplied = false;
                                                          couponExpired = false;
                                                          typeOfCouponExpired = false;
                                                          isButtonDisabled = false;
                                                        });
                                                        print('222');
                                                        // showToast('invalid subtype of coupon applied.');
                                                      }
                                                    }
                                                  } else {
                                                    setState(() {
                                                      emptyCode = false;
                                                      errorOnCoupon = true;
                                                      couponCodeApplied = false;
                                                      couponExpired = false;
                                                      typeOfCouponExpired = false;
                                                      isButtonDisabled = false;
                                                    });
                                                    print('333');
                                                    // showToast('invalid type of coupon applied.');
                                                  }
                                                  couponData =
                                                  null;
                                                  couponCodeController.clear();
                                                } else if (errorOfCouponCode !=
                                                    null) {
                                                  print(couponAPI);
                                                  var errorValue =
                                                  json.decode(couponAPI['message']);
                                                  print("reurn: ${errorValue['error']['message']}");
                                                  setState(() {
                                                    emptyCode = false;
                                                    errorOnCoupon = true;
                                                    couponCodeApplied = false;
                                                    couponExpired = false;
                                                    typeOfCouponExpired = false;
                                                    isButtonDisabled = false;
                                                  });
                                                  print('444');
                                                  // showToast('${errorValue['error']['message']}.');
                                                  errorOfCouponCode =
                                                  null;
                                                  couponCodeController.clear();
                                                }
                                              } else {
                                                setState(
                                                        () {
                                                      emptyCode =
                                                      true;
                                                      errorOnCoupon =
                                                      false;
                                                      couponCodeApplied =
                                                      false;
                                                      couponExpired =
                                                      false;
                                                      typeOfCouponExpired =
                                                      false;
                                                      isButtonDisabled =
                                                      false;
                                                    });
                                                // showToast('Please enter a code. Coupon code cannot be empty.');
                                              }
                                            } catch (e) {
                                              setState(
                                                      () {
                                                    emptyCode =
                                                    false;
                                                    errorOnCoupon =
                                                    true;
                                                    couponCodeApplied =
                                                    false;
                                                    couponExpired =
                                                    false;
                                                    typeOfCouponExpired =
                                                    false;
                                                    isButtonDisabled =
                                                    false;
                                                  });
                                              print(
                                                  '555');
                                              // showToast('Invalid coupon code!}');
                                              print(e
                                                  .toString());
                                            }
                                          },
                                        ),
                                        hintText: 'Enter coupon code',
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                        fillColor: Colors.deepPurple.shade100,
                                        filled: true,
                                        // suffixIconConstraints:
                                        // BoxConstraints(minHeight: 52, minWidth: 70),
                                        // contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide.none),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide.none),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          coupontext = value;
                                          print(coupontext);
                                        });
                                      },
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        isButtonDisabled = false;
                                        haveACouponCode = true;
                                        totalAmount = totalAmountAfterCoupon;
                                        couponCodeApplied = false;
                                        typeOfCouponExpired = false;
                                      });
                                    },
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Have a coupon code?',
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                            SizedBox(height: 7.sp),
                            errorOnCoupon
                                ? Text(
                                    'Applied coupon code is invalid. Please enter a valid coupon code.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.sp,
                                    ))
                                : Container(),
                            couponExpired
                                ? Text(
                                    typeOfCouponExpired
                                        ? 'Sorry! The coupon code has expired on $expiredDate.'
                                        : 'Sorry! The coupon code has expired at $expiredDate.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.sp,
                                    ))
                                : Container(),
                            emptyCode
                                ? Text(
                                    'Please enter a code. Coupon code cannot be empty.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.sp,
                                    ))
                                : Container(),
                            couponCodeApplied
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        courseMap['dataly_discounted_price'] != null ?
                                        'Yay! You have got an extra discount of CAD ${double.parse(discountvalue).round().toString()}. This code will expire on $expiredDate.' :
                                        typeOfCouponExpired
                                            ? 'Yay! You have got an extra discount of ₹${double.parse(discountvalue).round().toString()}. This code will expire on $expiredDate.'
                                            : 'Yay! You have got an extra discount of ₹${double.parse(discountvalue).round().toString()}. This code valid till $expiredDate.',
                                        style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 13.sp,
                                        )),
                                  )
                                : Container(),
                            SizedBox(height: 10.sp),
                            DottedLine(
                              dashGapLength: 0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Total Pay',
                                      style: textStyle,
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      couponCodeApplied && courseMap['dataly_discounted_price'] != null ?
                                      'CAD' + ' ${int.parse(courseMap['dataly_discounted_price']) - double.parse(discountvalue).round()}'
                                          :
                                      courseMap['dataly_discounted_price'] != null ?
                                      'CAD ${courseMap['dataly_discounted_price']}' :
                                      NoCouponApplied
                                          ? courseMap['gst'] != null
                                          ? '₹${totalAmount.round().toString()}/-'
                                          : '₹${int.parse(courseprice) - (int.parse(discountvalue) + newcoursevalue)}/-' //courseMap["Amount Payable"]
                                          : finalamountToDisplay,
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DottedLine(
                              dashGapLength: 0,
                            ),
                            SizedBox(height: 15.sp),
                            InkWell(
                              onTap: ()  {
                                setState(() {
                                  getcheckout=true;
                                  print(getcheckout);
                                });

                                // redirectToCheckout(context,
                                //     amount:  couponCodeApplied && courseMap['dataly_discounted_price'] != null ?
                                //     '${int.parse(courseMap['dataly_discounted_price']) - double.parse(discountvalue)}'
                                //         :
                                //     courseMap['dataly_discounted_price'] != null ?
                                //     '${double.parse(courseMap['dataly_discounted_price'])*100}' :
                                //     (double.parse(NoCouponApplied
                                //         ? courseMap['gst'] != null
                                //         ? '${totalAmount.round().toString()}'
                                //         : "${int.parse(courseprice) - int.parse(discountvalue)}"
                                //         : finalAmountToPay) *
                                //         100)
                                //         .toString(),
                                //     courseId:  courseMap['id']);

                                Future.delayed(const Duration(milliseconds: 5000), () {
                                  setState(() {
                                    getcheckout=false;
                                    print(getcheckout);
                                  });});
                              },
                              child: Container(
                                width: screenWidth,
                                height: Device.screenType == ScreenType.mobile
                                    ? 30.sp
                                    : 22.5.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.deepPurple.shade600,
                                ),
                                child: Center(
                                    child: getcheckout?CircularProgressIndicator(color: Colors.white,):
                                    Text(
                                      "Pay Now",
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 24 * verticalScale,
                                          letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    )
                                ),
                              ),
                            ),
                            // Container(
                            //   // width: screenWidth,
                            //   child: PaymentButton(
                            //     couponCode: coupontext,
                            //     couponcodeused: !errorOnCoupon,
                            //     coursePriceMoneyRef: int.parse(courseprice),
                            //     amountString: (double.parse(NoCouponApplied
                            //                 ? courseMap['gst'] != null
                            //                     ? '${totalAmount.round().toString()}'
                            //                     : "${int.parse(courseprice) - int.parse(discountvalue)}"
                            //                 : finalAmountToPay) * //courseMap['Amount_Payablepay']
                            //             100)
                            //         .toString(),
                            //     buttonText: NoCouponApplied
                            //         ? courseMap['gst'] != null
                            //             ? 'PAY ₹${totalAmount.round().toString()}/-'
                            //             : 'PAY ₹${int.parse(courseprice) - int.parse(discountvalue)}/-' //${courseMap['Course Price']}
                            //
                            //         : 'PAY ${finalamountToDisplay}',
                            //     buttonTextForCode: "PAY $finalamountToDisplay",
                            //     changeState: () {
                            //       setState(() {
                            //         // isLoading = !isLoading;
                            //       });
                            //     },
                            //     courseDescription: courseMap['description'],
                            //     courseName: courseMap['name'],
                            //     isPayButtonPressed: isPayButtonPressed,
                            //     NoCouponApplied: NoCouponApplied,
                            //     updateCourseIdToCouponDetails: () {
                            //       void addCourseId() {
                            //         setState(() {
                            //           id = courseMap['id'];
                            //         });
                            //       }
                            //
                            //       addCourseId();
                            //       print(NoCouponApplied);
                            //     },
                            //     outStandingAmountString: (double.parse(
                            //                 NoCouponApplied
                            //                     ? courseMap['Amount_Payablepay']
                            //                     : finalAmountToPay) -
                            //             1000)
                            //         .toStringAsFixed(2),
                            //     courseId: courseMap['id'],
                            //     courseImageUrl: courseMap['image_url'],
                            //     couponCodeText: couponCodeController.text,
                            //     isItComboCourse: widget.isItComboCourse,
                            //     whichCouponCode: couponCodeController.text,
                            //   ),
                            // ),
                            // SizedBox(height: 15.sp),
                            // InkWell(
                            //   onTap: () {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) {
                            //         return Dialog(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(20),
                            //           ),
                            //           child: Container(
                            //             width: screenWidth / 2.5,
                            //             padding: EdgeInsets.all(20),
                            //             child: Column(
                            //               mainAxisSize: MainAxisSize.min,
                            //               children: [
                            //                 Text(
                            //                   'Payment',
                            //                   style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontFamily: 'Poppins',
                            //                     fontSize: 20,
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //                 SizedBox(height: 20),
                            //                 RazorPayInternationalBtn(
                            //                   courseDescription:
                            //                       courseMap['description'],
                            //                   international: false,
                            //                   coursePriceMoneyRef:
                            //                       int.parse(courseprice),
                            //                   courseId: courseMap['id'],
                            //                   NoCouponApplied: NoCouponApplied,
                            //                   couponCodeText:
                            //                       couponCodeController.text,
                            //                   amountString: (double.parse(NoCouponApplied
                            //                               ? courseMap['gst'] != null
                            //                                   ? '${totalAmount.round().toString()}'
                            //                                   : "${(double.parse(courseprice) - double.parse(discountvalue)).round().toString()}"
                            //                               : finalAmountToPay) *
                            //                           100)
                            //                       .toString(),
                            //                   courseName: courseMap['name'],
                            //                   courseImageUrl:
                            //                       courseMap['image_url'],
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            //   child: Center(
                            //     child: Container(
                            //       width: screenWidth,
                            //       height: Device.screenType == ScreenType.mobile
                            //           ? 30.sp
                            //           : 20.sp,
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(5),
                            //         color: Colors.deepPurple.shade600,
                            //       ),
                            //       child: Center(
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //               'Pay Now',
                            //               style: TextStyle(
                            //                   color: Color.fromRGBO(
                            //                       255, 255, 255, 1),
                            //                   fontFamily: 'Poppins',
                            //                   fontSize: 20 * verticalScale,
                            //                   letterSpacing:
                            //                       0 /*percentages not used in flutter. defaulting to zero*/,
                            //                   fontWeight: FontWeight.bold,
                            //                   height: 1),
                            //             ),
                            //             Text(
                            //               '(For International Students)',
                            //               style: TextStyle(
                            //                   color: Color.fromRGBO(
                            //                       255, 255, 255, 1),
                            //                   fontFamily: 'Poppins',
                            //                   fontSize: 15 * verticalScale,
                            //                   letterSpacing:
                            //                       0 /*percentages not used in flutter. defaulting to zero*/,
                            //                   fontWeight: FontWeight.bold,
                            //                   height: 1),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  bool getcheckout=false;
}

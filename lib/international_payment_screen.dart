import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/models/course_details.dart';
import 'package:dataly_app/screens/chat_group.dart';
import 'package:dataly_app/screens/flutter_flow/flutter_flow_util.dart';
import 'package:dataly_app/widgets/coupon_code.dart';
import 'package:dataly_app/widgets/inter_payment_portal.dart';
import 'package:dataly_app/widgets/payment_portal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:star_rating/star_rating.dart';
import 'package:http/http.dart' as http;
import 'fun.dart';
import 'global_variable.dart' as globals;

class InternationalPaymentScreen extends StatefulWidget {
  // final Map<String, dynamic>? map;
  final cID;
  final bool isItComboCourse;
  const InternationalPaymentScreen(
      {Key? key, //this.map,
      required this.cID,
      required this.isItComboCourse})
      : super(key: key);

  @override
  State<InternationalPaymentScreen> createState() =>
      _InternationalPaymentScreenState();
}

class _InternationalPaymentScreenState extends State<InternationalPaymentScreen>
    with CouponCodeMixin {
  var amountcontroller = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // GlobalKey key = GlobalKey();
  // final scaffoldState = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showBottomSheet = ValueNotifier(false);
  // VoidCallback? _showPersistentBottomSheetCallBack;

  String? id;
  int newcoursevalue = 0;

  String couponAppliedResponse = "";

  //If it is false amountpayble showed will be the amount fetched from db
  //If it is true which will be set to true if when right coupon code is
  //applied and the amountpayble will be set using appludiscount to the finalamountpayble variable
  // declared below same for discount
  bool NoCouponApplied = true;

  String finalamountToDisplay = "";

  String finalAmountToPay = "";

  String discountedPrice = "";

  bool isPayButtonPressed = false;

  bool isPayInPartsPressed = false;

  bool isMinAmountCheckerPressed = false;

  bool isOutStandingAmountCheckerPressed = false;

  bool haveACouponCode = false;
  bool couponCodeApplied = false;
  bool emptyCode = false;
  bool couponExpired = false;
  bool errorOnCoupon = false;
  bool typeOfCouponExpired = false;
  bool isButtonDisabled = false;
  String expiredDate = '';
  bool loading = false;
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
      fontSize: 14,
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

    FirebaseFirestore.instance.collection('Notice')
      ..doc("o1Hw1CebDH9I4VfpKuiC_sup_pay")
          .update({'url': ""}).whenComplete(() {
        print('sup pay Deleted');
      });

    FirebaseFirestore.instance.collection('Notice')
      ..doc("M2jEwYyiWdzYWE9gJd8s_de_pay").update({'url': ""}).whenComplete(() {
        print('Data engineering pay Deleted');
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
          courseMap = value.data()!;
          print('paymentscree map ${courseMap.toString()} ');
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

          totalAmount = int.parse('${courseMap['Course Price']}');
          print('this is totalAmount ${totalAmount.round()}');
          totalAmountAfterCoupon = totalAmount;
        } else {
          print('gst is nulll');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print('amount error is here ${e.toString()}');
      }
    } catch (e) {
      print('catalogue screen ${e.toString()} ');
    }

    // reward function
    print("wewewewewew1");
    courseprice = courseMap['Course Price'].toString().replaceAll("₹", "");

    courseprice = courseprice.replaceAll("/-", "");
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

  String currencyRate = '';
  getCurrencyRate() {
    try {
      FirebaseFirestore.instance
          .collection('CurrencyRates')
          .doc('usd')
          .get()
          .then((value) {
        print('rate rate :: ${value.get('rate')}');
        currencyRate = value.get('rate');
      });
    } catch (e) {
      print('Error in getting currency rates');
    }
  }

  @override
  void initState() {
    getCourseName();
    getCurrencyRate();
    super.initState();
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
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
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
                padding: EdgeInsets.only(
                    left: 20.sp, right: 20.sp, top: 15.sp, bottom: 15.sp),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(
                            2, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                          blurRadius: 40)
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10, bottom: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                // height: screenHeight/3.5,
                                // width: screenWidth/3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: courseMap['image_url'],
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    height: 150 * verticalScale,
                                    width: 165 * horizontalScale,
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth / 2.5,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        courseMap['name'],
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                          fontSize: 20 * verticalScale,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10 * verticalScale,
                                    ),
                                    Container(
                                      child: Text(
                                        courseMap['description'],
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                          fontSize: 12 * verticalScale,
                                          height: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 4,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10 * verticalScale,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'English  ||  online  ||  lifetime',
                                        textScaleFactor:
                                            min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                            color: Colors.deepPurple.shade600,
                                            fontSize: 18 * verticalScale,
                                            height: 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15 * verticalScale,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15 * verticalScale,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 10.0, top: 10, bottom: 10, left: 10),
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
                                          fontSize: 34 * verticalScale,
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
                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
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
                                                fontSize: 16 * verticalScale,
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
                                                fontSize: 16 * verticalScale,
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
                              SizedBox(height: 5 * verticalScale),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      '\$${courseMap['Amount Payable']}/-',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5 * verticalScale),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      '\$${((double.parse(courseMap['Course Price']) / double.parse(currencyRate)) + 5).round().toString()}/-',
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15 * verticalScale,
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
                                          fontSize: 15.sp,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Text(
                                                    'Apply',
                                                    style: TextStyle(
                                                      color: Color(0xFF7860DC),
                                                      fontFamily: 'Medium',
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            onPressed: isButtonDisabled
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      isButtonDisabled = true;
                                                    });

                                                    try {
                                                      if (couponCodeController
                                                          .text.isNotEmpty) {
                                                        var couponAPI =
                                                            await verifyCoupon(
                                                                couponCodeController
                                                                    .text);
                                                        print('towards logic');
                                                        if (couponData !=
                                                            null) {
                                                          print(couponAPI);
                                                          var value = json
                                                              .decode(couponAPI[
                                                                  'message']);
                                                          print(
                                                              "return value: ${value['result']}");
                                                          print(
                                                              "return value: ${value['result']['couponType']}");
                                                          print(
                                                              "return value: ${value['result']['couponStartDate']}");

                                                          if (value['result'][
                                                                  'couponType'] ==
                                                              'global') {
                                                            var startTime = value[
                                                                    'result'][
                                                                'couponStartDate'];
                                                            print(startTime);

                                                            var endTime = value[
                                                                    'result'][
                                                                'couponExpiryDate'];
                                                            DateTime dateTime =
                                                                DateTime.parse(
                                                                    endTime);
                                                            String
                                                                formattedDateTime =
                                                                DateFormat(
                                                                        'yyyy-MM-dd HH:mm a')
                                                                    .format(dateTime
                                                                        .toLocal());
                                                            print(
                                                                formattedDateTime); // prints "2023-04-15"

                                                            if (DateTime.now()
                                                                .isAfter(
                                                                    dateTime)) {
                                                              setState(() {
                                                                emptyCode =
                                                                    false;
                                                                errorOnCoupon =
                                                                    false;
                                                                couponCodeApplied =
                                                                    false;
                                                                couponExpired =
                                                                    true;
                                                                expiredDate =
                                                                    formattedDateTime;
                                                                typeOfCouponExpired =
                                                                    true;
                                                                isButtonDisabled =
                                                                    false;
                                                              });
                                                              // showToast('Sorry, The coupon has expired.');
                                                            } else {
                                                              if (value['result']
                                                                          [
                                                                          'couponValue']
                                                                      [
                                                                      'type'] ==
                                                                  'percentage') {
                                                                // code for percentage type of coupon
                                                                var percentageValue =
                                                                    int.parse(value['result']['couponValue']
                                                                            [
                                                                            'value']) *
                                                                        0.01;
                                                                print(
                                                                    'this is value in percerntage $percentageValue');
                                                                discountvalue =
                                                                    (totalAmount *
                                                                            percentageValue)
                                                                        .toString();
                                                                print(
                                                                    totalAmount);
                                                                print(
                                                                    discountvalue);

                                                                setState(() {
                                                                  totalAmount =
                                                                      totalAmount -
                                                                          double.parse(
                                                                              discountvalue);
                                                                  emptyCode =
                                                                      false;
                                                                  errorOnCoupon =
                                                                      false;
                                                                  couponCodeApplied =
                                                                      true;
                                                                  couponExpired =
                                                                      false;
                                                                  haveACouponCode =
                                                                      false;
                                                                  expiredDate =
                                                                      formattedDateTime;
                                                                  typeOfCouponExpired =
                                                                      true;
                                                                });
                                                                print(totalAmount
                                                                    .toString());
                                                                // showToast('Coupon code applied successfully.');
                                                              } else if (value[
                                                                              'result']
                                                                          [
                                                                          'couponValue']
                                                                      [
                                                                      'type'] ==
                                                                  'number') {
                                                                // code for direct amount type of coupon

                                                                var numberValue =
                                                                    int.parse(value['result']
                                                                            [
                                                                            'couponValue']
                                                                        [
                                                                        'value']);
                                                                print(
                                                                    'this is value in $numberValue');
                                                                discountvalue =
                                                                    numberValue
                                                                        .toString();
                                                                print(
                                                                    totalAmount);
                                                                print(
                                                                    discountvalue);

                                                                setState(() {
                                                                  totalAmount =
                                                                      totalAmount -
                                                                          int.parse(
                                                                              discountvalue);
                                                                  emptyCode =
                                                                      false;
                                                                  errorOnCoupon =
                                                                      false;
                                                                  couponCodeApplied =
                                                                      true;
                                                                  couponExpired =
                                                                      false;
                                                                  haveACouponCode =
                                                                      false;
                                                                  expiredDate =
                                                                      formattedDateTime;
                                                                  typeOfCouponExpired =
                                                                      true;
                                                                });
                                                                print(
                                                                    totalAmount);
                                                                // showToast('Coupon code applied successfully.');
                                                              } else {
                                                                setState(() {
                                                                  emptyCode =
                                                                      false;
                                                                  errorOnCoupon =
                                                                      true;
                                                                  couponCodeApplied =
                                                                      false;
                                                                  couponExpired =
                                                                      false;
                                                                  isButtonDisabled =
                                                                      false;
                                                                });
                                                                print('111');
                                                                // showToast('invalid type of coupon applied.');
                                                              }
                                                            }
                                                          } else if (value[
                                                                      'result'][
                                                                  'couponType'] ==
                                                              'individual') {
                                                            var endTime = value[
                                                                    'result'][
                                                                'couponExpiryDate'];
                                                            DateTime dateTime =
                                                                DateFormat(
                                                                        "EEE MMM dd yyyy HH:mm:ss 'GMT'Z")
                                                                    .parse(
                                                                        endTime);
                                                            String
                                                                formattedDateTime =
                                                                DateFormat(
                                                                        'HH:mm a')
                                                                    .format(dateTime
                                                                        .toLocal());

                                                            print(
                                                                formattedDateTime);

                                                            if (DateTime.now()
                                                                .isAfter(
                                                                    dateTime)) {
                                                              setState(() {
                                                                emptyCode =
                                                                    false;
                                                                errorOnCoupon =
                                                                    false;
                                                                couponCodeApplied =
                                                                    false;
                                                                couponExpired =
                                                                    true;
                                                                typeOfCouponExpired =
                                                                    false;
                                                                expiredDate =
                                                                    formattedDateTime;
                                                                isButtonDisabled =
                                                                    false;
                                                              });
                                                            } else {
                                                              if (value['result']
                                                                          [
                                                                          'couponValue']
                                                                      [
                                                                      'type'] ==
                                                                  'percentage') {
                                                                // code for percentage type of coupon
                                                                var percentageValue =
                                                                    int.parse(value['result']['couponValue']
                                                                            [
                                                                            'value']) *
                                                                        0.01;
                                                                print(
                                                                    'this is value in $percentageValue');
                                                                discountvalue =
                                                                    (totalAmount *
                                                                            percentageValue)
                                                                        .toString();
                                                                print(
                                                                    totalAmount);
                                                                print(
                                                                    discountvalue);
                                                                setState(() {
                                                                  totalAmount =
                                                                      totalAmount -
                                                                          double.parse(
                                                                              discountvalue);
                                                                  emptyCode =
                                                                      false;
                                                                  errorOnCoupon =
                                                                      false;
                                                                  couponCodeApplied =
                                                                      true;
                                                                  couponExpired =
                                                                      false;
                                                                  haveACouponCode =
                                                                      false;
                                                                  typeOfCouponExpired =
                                                                      false;
                                                                  expiredDate =
                                                                      formattedDateTime;
                                                                });
                                                                print(totalAmount
                                                                    .toString());
                                                                // showToast('Coupon code applied successfully.');
                                                              } else if (value[
                                                                              'result']
                                                                          [
                                                                          'couponValue']
                                                                      [
                                                                      'type'] ==
                                                                  'number') {
                                                                // code for direct amount type of coupon

                                                                var numberValue =
                                                                    int.parse(value['result']
                                                                            [
                                                                            'couponValue']
                                                                        [
                                                                        'value']);
                                                                print(
                                                                    'this is value in $numberValue');
                                                                discountvalue =
                                                                    numberValue
                                                                        .toString();
                                                                print(
                                                                    totalAmount);
                                                                print(
                                                                    discountvalue);
                                                                setState(() {
                                                                  totalAmount =
                                                                      totalAmount -
                                                                          int.parse(
                                                                              discountvalue);
                                                                  emptyCode =
                                                                      false;
                                                                  errorOnCoupon =
                                                                      false;
                                                                  couponCodeApplied =
                                                                      true;
                                                                  haveACouponCode =
                                                                      false;
                                                                  couponExpired =
                                                                      false;
                                                                  typeOfCouponExpired =
                                                                      false;
                                                                  expiredDate =
                                                                      formattedDateTime;
                                                                });
                                                                print(
                                                                    totalAmount);
                                                                // showToast('Coupon code applied successfully.');
                                                              } else {
                                                                setState(() {
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
                                                                print('222');
                                                                // showToast('invalid subtype of coupon applied.');
                                                              }
                                                            }
                                                          } else {
                                                            setState(() {
                                                              emptyCode = false;
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
                                                            print('333');
                                                            // showToast('invalid type of coupon applied.');
                                                          }
                                                          couponData = null;
                                                          couponCodeController
                                                              .clear();
                                                        } else if (errorOfCouponCode !=
                                                            null) {
                                                          print(couponAPI);
                                                          var errorValue = json
                                                              .decode(couponAPI[
                                                                  'message']);
                                                          print(
                                                              "reurn: ${errorValue['error']['message']}");
                                                          setState(() {
                                                            emptyCode = false;
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
                                                          print('444');
                                                          // showToast('${errorValue['error']['message']}.');
                                                          errorOfCouponCode =
                                                              null;
                                                          couponCodeController
                                                              .clear();
                                                        }
                                                      } else {
                                                        setState(() {
                                                          emptyCode = true;
                                                          errorOnCoupon = false;
                                                          couponCodeApplied =
                                                              false;
                                                          couponExpired = false;
                                                          typeOfCouponExpired =
                                                              false;
                                                          isButtonDisabled =
                                                              false;
                                                        });
                                                        // showToast('Please enter a code. Coupon code cannot be empty.');
                                                      }
                                                    } catch (e) {
                                                      setState(() {
                                                        emptyCode = false;
                                                        errorOnCoupon = true;
                                                        couponCodeApplied =
                                                            false;
                                                        couponExpired = false;
                                                        typeOfCouponExpired =
                                                            false;
                                                        isButtonDisabled =
                                                            false;
                                                      });
                                                      print('555');
                                                      // showToast('Invalid coupon code!}');
                                                      print(e.toString());
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
                                          typeOfCouponExpired
                                              ? 'Yay! You have got an extra discount of \$${(double.parse(discountvalue) / double.parse(currencyRate)).round().toString()}. This code will expire on $expiredDate.'
                                              : 'Yay! You have got an extra discount of \$${(double.parse(discountvalue) / double.parse(currencyRate)).round().toString()}. This code valid till $expiredDate.',
                                          style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontSize: 13.sp,
                                          )),
                                    )
                                  : Container(),
                              SizedBox(height: 8.sp),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
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
                                        couponCodeApplied
                                            ? '\$${(((double.parse(courseMap['Course Price']) / double.parse(currencyRate)) + 5).round() - (double.parse(discountvalue) / double.parse(currencyRate))).round().toString()}/-'
                                            : '\$${((double.parse(courseMap['Course Price']) / double.parse(currencyRate)) + 5).round().toString()}/-',
                                        style: textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DottedLine(
                                dashGapLength: 0,
                              ),
                              SizedBox(height: 25 * verticalScale),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          width: screenWidth / 2.5,
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Payment',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              RazorPayInternationalBtn(
                                                international: true,
                                                courseDescription:
                                                    courseMap['description'],
                                                coursePriceMoneyRef:
                                                    int.parse(courseprice),
                                                courseId: courseMap['id'],
                                                NoCouponApplied:
                                                    NoCouponApplied,
                                                couponCodeText:
                                                    couponCodeController.text,
                                                amountString: couponCodeApplied
                                                    ? '${((totalAmount * 100).round() - double.parse(discountvalue).round()).toString()}'
                                                    : '${((totalAmount * 100).round().toString())}',
                                                courseName: courseMap['name'],
                                                courseImageUrl:
                                                    courseMap['image_url'],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    width: screenWidth,
                                    height:
                                        Device.screenType == ScreenType.mobile
                                            ? 30.sp
                                            : 20.sp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.deepPurple.shade600,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Pay Now',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontFamily: 'Poppins',
                                            fontSize: 20 * verticalScale,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
        ));
  }
}

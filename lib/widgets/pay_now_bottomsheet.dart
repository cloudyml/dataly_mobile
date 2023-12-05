import 'package:dataly_app/international_payment_screen.dart';
import 'package:dataly_app/payment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../globals.dart';

class PayNowBottomSheet extends StatelessWidget {
  String coursePrice;
  Map<String, dynamic> map;
  String? cID;
  bool international;
  bool isItComboCourse;
  // double closeBottomSheetAt;

  PayNowBottomSheet({
    required this.coursePrice,
    required this.map,
    required this.international,
    required this.isItComboCourse,
    this.cID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return Container(
          height: 33.sp,
          width: MediaQuery.of(context).size.width,
          // duration: Duration(milliseconds: 1000),
          // curve: Curves.easeIn,
          child: Center(
            child: InkWell(
              onTap: () {
                if (international != null && international == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InternationalPaymentScreen(
                        // map: map,
                        cID: courseId,
                        isItComboCourse: isItComboCourse,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        // map: map,
                        cID: courseId,
                        isItComboCourse: isItComboCourse,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 33.sp,
                // width: 300,
                color: Colors.purple,
                child: Center(
                  child: Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Medium',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onClosing: () {},
    );
  }
}

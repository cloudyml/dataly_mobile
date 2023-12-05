import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/screens/moneyref/edit_payment_detail.dart';
import 'package:dataly_app/screens/moneyref/ref_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'add_payment_method.dart';

class ReferScreen extends StatefulWidget {
  ReferScreen({Key? key}) : super(key: key);

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  void initState() {
    super.initState();
    print("woefjwoeifjowieofw");
    calculateVariables();
    checkifaccountexist();
  }

  bool accountexist = false;
  var bankname = "";
  var accountnumber = "";
  var ifsc = "";
  var upi = "";
  var name = "";

  var showlast4digit = "";
  checkifaccountexist() async {
    await FirebaseFirestore.instance
        .collection("MoneyRefPayment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        try {
          value.data()!["AccountDetail"];
          bankname = value.data()!["AccountDetail"]["BankName"];
          accountnumber = value.data()!["AccountDetail"]["AccountNumber"];
          ifsc = value.data()!["AccountDetail"]["IFSCCode"];
          upi = value.data()!["AccountDetail"]["upiId"];
          name = value.data()!["AccountDetail"]["AccountHolderName"];

          showlast4digit = accountnumber.substring(accountnumber.length - 4);

          setState(() {
            accountexist = true;
          });
        } catch (e) {
          setState(() {
            accountexist = false;
          });
        }
      });
    });
  }

  var moneyreflist = [];
  num amount = 0;
  var totalref = 0;
  var totalmonthref = 0;

  calculateVariables() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          moneyreflist = value.data()!["moneyreflist"];
          totalref = moneyreflist.length;
          print("moneyreflist: ${moneyreflist}");
          print(moneyreflist[0]["date"].toDate().month);
          for (var i = 0; i < moneyreflist.length; i++) {
            try {
              amount = amount + moneyreflist[i]["price"];
              if (moneyreflist[i]["date"].toDate().month ==
                  DateTime.now().month) {
                totalmonthref = totalmonthref + 1;
              }
            } catch (e) {
              print("sdfisdofsef: ${e.toString()}");
            }
          }
        });
      });
    } catch (e) {
      print("soifjiowejio: ${e.toString()}");
    }
  }

  @override
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: Text('Transactions',
          style: TextStyle(
              shadows: <Shadow>[],
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'InriaSans',
              color: Color.fromARGB(255, 108, 77, 122))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Text("1",
                      style: TextStyle(
                          shadows: <Shadow>[],
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InriaSans',
                          color: Color.fromARGB(255, 108, 77, 122))),
                  Spacer(),
                  Text("\ ${amount}",
                      style: TextStyle(
                          shadows: <Shadow>[],
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InriaSans',
                          color: Color.fromARGB(255, 108, 77, 122))),
                  Spacer(),
                  SizedBox(height: 2.h, child: Image.asset("assets/minus.png"))
                ],
              );
            },
          ),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPopupDialog2(BuildContext context) {
    return new AlertDialog(
      title: Text('Details',
          style: TextStyle(
              shadows: <Shadow>[],
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'InriaSans',
              color: Color.fromARGB(255, 108, 77, 122))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Account number'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your first name.';
              }
            },
            onSaved: (val) => setState(() {}),
          ),
          SizedBox(
            height: 3.h,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'IFSC Code '),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your first name.';
              }
            },
            onSaved: (val) => setState(() {}),
          ),
          SizedBox(
            height: 3.h,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'User Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your first name.';
              }
            },
            onSaved: (val) => setState(() {}),
          ),
          SizedBox(
            height: 3.h,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'UPI ID'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your first name.';
              }
            },
            onSaved: (val) => setState(() {}),
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Slice 1.png"),
                  fit: BoxFit.fitWidth),
              borderRadius: BorderRadius.all(Radius.circular(10.sp))),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: [
                    SizedBox(width: 5.w),
                    Image.asset("assets/back-button.png"),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      "Referal Screen",
                      style: TextStyle(
                          shadows: <Shadow>[],
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InriaSans',
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              BigBox.bigbox("${amount}"),
              Option.textFormFieldComponent(
                  "assets/people.png", "${totalref}", "learners added"),
              Option.textFormFieldComponent(
                  "assets/calender.png", "${totalmonthref}", "coins/month"),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RefHistory(
                                  reflist: moneyreflist,
                                )));
                  },
                  child: Option.textFormFieldComponent(
                      "assets/history.png", "History", "")),
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog2(context),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      !accountexist
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentpageWidget()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymenteditdetailWidget(
                                      bankname,
                                      accountnumber,
                                      ifsc,
                                      name,
                                      upi)));
                    },
                    child: !accountexist
                        ? Center(child: Image.asset("assets/Slice2.png"))
                        : Container(
                            height: 200,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[900],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '**** **** **** $showlast4digit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CARD HOLDER',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '$name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'IFSC',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '$ifsc',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
              //   child: Center(child: Image.asset("assets/Slice3.png")),
              // ),
            ],
          ),
        )
      ],
    ));
  }
}

class BigBox {
  static bigbox(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w, bottom: 1.h),
      child: Container(
        height: 28.h,
        width: 200.w,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 217, 217, 217),
            borderRadius: BorderRadius.all(Radius.circular(10.sp))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                "Total coins earned :",
                style: TextStyle(
                    shadows: <Shadow>[],
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans',
                    color: Color.fromARGB(255, 108, 77, 122)),
                textAlign: TextAlign.center,
              )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100.0, 20, 50, 20),
                  child: Row(
                    children: [
                      Image.asset("assets/money.png", height: 5.h, width: 5.h),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'InriaSans',
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.w),
                        child: Image.asset("assets/info.png"),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Knowledge can only be volunteered\nit cannot be conscripted",
                style: TextStyle(
                    shadows: <Shadow>[],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans',
                    color: Color.fromARGB(255, 108, 77, 122)),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Text(
                    "Congratulations!! for being a part of it",
                    style: TextStyle(
                        shadows: <Shadow>[],
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InriaSans',
                        color: Color.fromARGB(255, 108, 77, 122)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w, bottom: 5.w),
                    child: Image.asset("assets/party.png"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Option {
  static textFormFieldComponent(String location, String text, String text2) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, left: 10.w, right: 10.w, bottom: 2.h),
      child: Container(
        height: 7.5.h,
        width: 200.w,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 217, 217, 217),
            borderRadius: BorderRadius.all(Radius.circular(10.sp))),
        child: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Row(
            children: [
              Image.asset(location, height: 5.h, width: 5.h),
              Spacer(),
              Text(
                text,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans',
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 4.w, right: 5.w),
                child: Text(
                  text2,
                  style: TextStyle(
                      shadows: <Shadow>[],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'InriaSans',
                      color: Color.fromARGB(255, 108, 77, 122)),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

const List<String> list = <String>[
  'Select Bank',
  'Allahabad Bank',
  'Andhra Bank',
  'Axis Bank',
  'Bank of Bahrain and Kuwait',
  'Bank of Baroda - Corporate Banking',
  'Bank of Baroda - Retail Banking',
  'Bank of India',
  'Bank of Maharashtra',
  'Canara Bank',
  'Central Bank of India',
  'City Union Bank',
  'Corporation Bank',
  'Deutsche Bank',
  'Development Credit Bank',
  'Dhanlaxmi Bank',
  'Federal Bank',
  'ICICI Bank',
  'IDBI Bank',
  'Indian Bank',
  'Indian Overseas Bank',
  'IndusInd Bank',
  'ING Vysya Bank',
  'Jammu and Kashmir Bank',
  'Karnataka Bank Ltd',
  'Karur Vysya Bank',
  'Kotak Bank',
  'Laxmi Vilas Bank',
  'Oriental Bank of Commerce',
  'Punjab National Bank - Corporate Banking',
  'Punjab National Bank - Retail Banking',
  'Punjab & Sind Bank',
  'Shamrao Vitthal Co-operative Bank',
  'South Indian Bank',
  'State Bank of Bikaner & Jaipur',
  'State Bank of Hyderabad',
  'State Bank of India',
  'State Bank of Mysore',
  'State Bank of Patiala',
  'State Bank of Travancore',
  'Syndicate Bank',
  'Tamilnad Mercantile Bank Ltd.',
  'UCO Bank',
  'Union Bank of India',
  'United Bank of India',
  'Vijaya Bank',
  'Yes Bank Ltd',
];

class PaymenteditdetailWidget extends StatefulWidget {
  var bankname;
  var accountnumber;
  var ifsccode;
  var accountholdername;
  var upiId;
  PaymenteditdetailWidget(this.bankname, this.accountnumber, this.ifsccode,
      this.accountholdername, this.upiId,
      {Key? key})
      : super(key: key);

  @override
  _PaymenteditdetailWidgetState createState() =>
      _PaymenteditdetailWidgetState();
}

class _PaymenteditdetailWidgetState extends State<PaymenteditdetailWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final accountnumber = TextEditingController();
  final ifsccode = TextEditingController();
  final accountholdername = TextEditingController();
  final upiId = TextEditingController();

  @override
  void initState() {
    super.initState();
    accountnumber.text = widget.accountnumber;
    ifsccode.text = widget.ifsccode;
    accountholdername.text = widget.accountholdername;
    upiId.text = widget.upiId;
    dropdownValue = widget.bankname;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  bool isValidIFSC(String ifscCode) {
    if (ifscCode.length != 11) {
      return false;
    }

    RegExp regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!regex.hasMatch(ifscCode)) {
      return false;
    }

    String bankCode = ifscCode.substring(0, 4).toUpperCase();
    String branchCode = ifscCode.substring(6).toUpperCase();

    // You can add your own logic here to validate the bank and branch codes.
    // This example assumes that any bank code and branch code combination is valid.

    return true;
  }

  bool isValidAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty) {
      return false;
    }

    RegExp regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(accountNumber)) {
      return false;
    }

    // You can add additional validation rules specific to your use case or known account number formats here.

    return true;
  }

  bool isValidUpiId(String upiId) {
    if (upiId.isEmpty) {
      return false;
    }

    // UPI ID format regex pattern
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(18, 28, 18, 18),
                      child: DropdownButtonExample()),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(18, 0, 18, 18),
                    child: TextField(
                      controller: accountnumber,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Account Number',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(18, 0, 18, 18),
                    child: TextFormField(
                      controller: ifsccode,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'IFSC Code',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(18, 0, 18, 18),
                    child: TextFormField(
                      controller: accountholdername,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Account Holder Name',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(18, 0, 18, 18),
                    child: TextFormField(
                      controller: upiId,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'UPI ID',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () async {
                        if (!isValidIFSC(ifsccode.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid IFSC Code"),
                          ));
                          return;
                        }
                        if (!isValidAccountNumber(accountnumber.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid Account Number"),
                          ));
                          return;
                        }

                        if (!isValidUpiId(upiId.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Invalid upi id"),
                          ));
                          return;
                        }
                        try {
                          await FirebaseFirestore.instance
                              .collection("MoneyRefPayment")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "AccountDetail": {
                              "AccountNumber": accountnumber.text,
                              "IFSCCode": ifsccode.text,
                              "AccountHolderName": accountholdername.text,
                              "BankName": dropdownValue,
                              "upiId": upiId.text,
                            }
                          }).whenComplete(() {
                            Toast.show("Account Updated");
                          });
                        } catch (e) {
                          await FirebaseFirestore.instance
                              .collection("MoneyRefPayment")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "AccountDetail": {
                              "AccountNumber": accountnumber.text,
                              "IFSCCode": ifsccode.text,
                              "AccountHolderName": accountholdername.text,
                              "BankName": dropdownValue,
                              "upiId": upiId.text,
                            }
                          }).whenComplete(() {
                            Toast.show("Account Added");
                          });
                        }
                      },
                      child: Text("Update Details")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String dropdownValue = list.first;

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({Key? key}) : super(key: key);

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

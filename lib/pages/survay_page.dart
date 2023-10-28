// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:toast/toast.dart';

// import '../home.dart';

// class CheckboxPage extends StatefulWidget {
//   const CheckboxPage({Key? key}) : super(key: key);

//   @override
//   State<CheckboxPage> createState() => _CheckboxPageState();
// }

// class _CheckboxPageState extends State<CheckboxPage> {
//   bool? ischanged = false;
//   bool? ischanged1 = false;
//   bool? ischanged2 = false;
//   bool? ischanged3 = false;
//   String invisible = '';
//   double opacity_textfield = 0.0;
//   final _auth = FirebaseAuth.instance.currentUser;
//   late List lst1 = [];
//   late Map<String, String> lst = {};
//   late Map<String, Map<String, String>> addToDB = {};
//   final _controller = TextEditingController();
//   String name = '';
//   late String text_widget = '';
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // print(controller.text);
//   }

//   addData(map) async {
//     // var _id1;
//     // await FirebaseFirestore.instance
//     //     .collection('notify')
//     //     .where('phone', isEqualTo: _auth!.phoneNumber)
//     //     .get()
//     //     .then((values) => values.docs.forEach((element) {
//     //           _id1 = element.get('id');
//     //         }));
//     // print("this the String:::" + _id1);
//     try {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update(map);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('survay', 'done');
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             shadowColor: Color.fromARGB(255, 162, 77, 219),
//         backgroundColor: Color.fromARGB(255, 129, 31, 194),
//           title: Center(child: Text(invisible.isEmpty ? "Let Us Know" : invisible)),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image(
//                 image: const NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fthinking_person.jpg?alt=media&token=22fa77b6-3e48-4ad5-aa40-afd3eceb489e'),
//                 fit: BoxFit.fill,
//                 width: WidgetsBinding.instance.window.physicalGeometry.width,
//               ),
//               const SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                   child: Text(
//                     'Which roles are  you interested in ?',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//               CheckboxListTile(
//                   secondary: const Image(
//                       image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fdata-science.png?alt=media&token=33c170f7-ca80-46d4-bc69-8af9ae450d04'),
//                       fit: BoxFit.fill,
//                       width: 30),
//                   title: const Text(
//                     "Data Scientist",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   selectedTileColor: Colors.blueAccent,
//                   value: ischanged,
//                   onChanged: (value) {
//                     setState(() {
//                       ischanged = value;
//                       if (ischanged!) {
//                         lst['Selected1'] = "Data Scientist";
//                       } else {
//                         lst.remove('Selected1');
//                       }
//                       print(lst);
//                     });
//                   }),
//               CheckboxListTile(
//                   secondary: const Image(
//                       image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fdata-analytics-icon.png?alt=media&token=b1ce44e2-7da5-4522-bec1-4d39c5cb2b65'),
//                       fit: BoxFit.fill,
//                       width: 30),
//                   title: const Text(
//                     "Data Analyst",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   value: ischanged1,
//                   onChanged: (value) {
//                     setState(() {
//                       ischanged1 = value;
//                       if (ischanged1!) {
//                         lst['Selected2'] = "Data Analyst";
//                       } else {
//                         lst.remove('Selected2');
//                       }
//                       //print(lst);
//                     });
//                   }),
//               CheckboxListTile(
//                   secondary: const Image(
//                       image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fpresentation.png?alt=media&token=d686180d-70b1-408e-ae8e-e968770c68a4'),
//                       fit: BoxFit.fill,
//                       width: 30),
//                   title: const Text(
//                     "Business Analyst",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   selectedTileColor: Colors.blueAccent,
//                   value: ischanged2,
//                   onChanged: (value) {
//                     setState(() {
//                       ischanged2 = value;
//                       if (ischanged2!) {
//                         lst['Selected3'] = "Business Analyst";
//                       } else {
//                         lst.remove('Selected3');
//                       }
//                       print(lst);
//                     });
//                   }),
//               CheckboxListTile(
//                   secondary: const Image(
//                       image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cloudyml-app.appspot.com/o/Assets%2Fmore-information.png?alt=media&token=643b0294-585d-4c44-95df-d6070f60357f'),
//                       fit: BoxFit.fill,
//                       width: 30),
//                   title: const Text(
//                     'Others',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   selectedTileColor: Colors.blueAccent,
//                   value: ischanged3,
//                   onChanged: (value) {
//                     setState(() {
//                       ischanged3 = value;
//                       if (ischanged3!) {
//                         opacity_textfield = 1.0;
//                       } else {
//                         opacity_textfield = 0.0;
//                         setState(() {
//                           text_widget = '';
//                         });
//                       }
//                       print(lst);
//                     });
//                   }),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
//                   child: Text(
//                     text_widget,
//                     style: const TextStyle(color: Colors.red),
//                   )),
//               Opacity(
//                 opacity: opacity_textfield,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Enter your other interests",
//                     ),
//                     onChanged: (value) {},
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: TextButton(
//                     onPressed: () async {
//                       if (ischanged == false &&
//                           ischanged1 == false &&
//                           ischanged2 == false &&
//                           ischanged3 == false) {
//                         setState(() {
//                           invisible = "Please Select your Roles/Interests";
//                           Toast.show(invisible);
//                         });
//                       } else if (ischanged3 == true &&
//                           _controller.text.isEmpty) {
//                         setState(() {
//                           text_widget = "Please enter your choice";
//                           Toast.show(text_widget);
//                         });
//                       } else {
//                         setState(() {
//                           if (_controller.text.isNotEmpty) {
//                             lst['others'] = _controller.text;
//                           }
//                         });
//                         addToDB.addAll({"Choices": lst});
//                         print(addToDB);
//                         await addData(addToDB);
//                         Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(
//                               builder: (_) =>

//                                   ShowCaseWidget(
//                                     autoPlay: true,
//                                     onStart: (index, key) {

//                                     },
//                                     onComplete: (index, key) {
//                                     //  log('onComplete: $index, $key');
//                                       if (index == 7) {
//                                         SystemChrome.setSystemUIOverlayStyle(
//                                           SystemUiOverlayStyle.light.copyWith(
//                                             statusBarIconBrightness: Brightness.dark,
//                                             statusBarColor: Colors.white,
//                                           ),
//                                         );
//                                       }
//                                     },
//                                     blurValue: 1,
//                                     autoPlayDelay: const Duration(seconds: 3),
//                                     builder: Builder(
//                                         builder : (context)=> HomePage()
//                                     ),
//                                   ),
//                                  // HomePage(),
//                             ),
//                             (Route<dynamic> route) => false);
//                       }
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.black87,
//                       backgroundColor: Colors.purple.shade300,
//                       elevation: 3,
//                       shadowColor: Colors.purple.shade100,
//                       minimumSize: const Size(120, 30),
//                     ),
//                     child: const Text(
//                       "Submit",
//                       style: TextStyle(fontSize: 20),
//                     )),
//               )
//             ],
//           ),
//         ));
//   }
// }

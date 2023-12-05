import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/services/local_notificationservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:dataly_app/global_variable.dart' as globals;

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  var authorizationToken;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final myBox = Hive.box('myBox');
  FirebaseAuth auth = FirebaseAuth.instance;

  void insertToken() async {
    print("insertToken");
    final token = await FirebaseMessaging.instance.getToken();

    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"token": token});
    final data = await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    authorizationToken = await FirebaseAuth.instance.currentUser!.getIdToken();

    final response = data.get().then((DocumentSnapshot doc) {
      final data2 = doc.data() as Map<String, dynamic>;
      print(data2);
    });
    print(response);
    print("insertedToken");
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  List<dynamic> listOfGroupListData = [];
  String documentID = "";
  _getGroupListData() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authorizationToken}'
    };

    try {
      var response = await http.post(
          Uri.parse(
              "https://us-central1-cloudyml-app.cloudfunctions.net/Grouplist/groupList"),
          headers: headers,
          body: json.encode({"documentID": documentID}));
      var responseData = await jsonDecode(response.body);
      print(response.statusCode);
      print(responseData["responseData"][0]["data"]["student_name"]);
      if (response.statusCode == 200) {
        documentID = responseData["responseData"]
                [responseData["responseData"].length - 1]["id"]
            .toString();
        listOfGroupListData.addAll(responseData["responseData"]);
        print("added");
        // printWrapped("ggggggggggggggg${listOfGroupListData}");
        print(listOfGroupListData.length);
        var count = 0;
        for (var i = 0; i < listOfGroupListData.length; i++) {
          try {
            if (listOfGroupListData[i]['data']['groupChatCountNew']
                    [FirebaseAuth.instance.currentUser!.uid] >
                0) {
              count += 1;
            }
          } catch (e) {
            print(e);
          }
        }
        print("this is count: ${count}");
        globals.chatcount = count;
        print(listOfGroupListData[0]['data']['time']);
      } else {
        print("Error in groupList");
      }
    } catch (err) {
      print("GroupList error");
      print(err);
    }
  }

  @override
  void initState() {
    // TODO:implement initState
    super.initState();
    insertToken();

    //listnerNotifications();
    //gives you the message on which user taps and opens
    //the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        final prefs = await SharedPreferences.getInstance();
        globals.action = await prefs.getString("login");
        try {
          globals.survay = await prefs.getString("survay");
        } catch (e) {}

        print("333333333333333333333333333");
        print(globals.action);
        globals.signoutvalue = await prefs.getString("signout");
        print("0000000000000000000");
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
        _getGroupListData();
      },
    );

    ////foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data["SenderId"] != null || message.data["SenderId"] != "") {
        print(message.notification!.title);
        print(message.notification!.body);

        var expression = true;
        print(await myBox.values.toString() + "ppppppp");
        final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        var data = {
          "ID": id,
          "student_id": FirebaseAuth.instance.currentUser!.uid,
          "senderID": message.data["SenderId"],
          "DocumentId": message.data["DocumentId"],
          "count": 1
        };
        var dataValues = await myBox.values;
        int count;
        if (dataValues.isNotEmpty) {
          for (var i in dataValues) {
            if (i["senderID"] == data["senderID"]) {
              expression = false;
              count = i["count"] + 1;
              removeNotification(i["ID"]);
              await LocalNotificationService.display(message, "", id, count);
              data = {
                "ID": id,
                "student_id": FirebaseAuth.instance.currentUser!.uid,
                "senderID": i["senderID"],
                "DocumentId": i["DocumentId"],
                "count": count
              };
              await myBox.put(data["ID"], data);
            }
          }
          if (expression) {
            await LocalNotificationService.display(message, "", id, 1);
            await myBox.put(data["ID"], data);
          }
        } else {
          await LocalNotificationService.display(message, "", id, 1);
          await myBox.put(data["ID"], data);
        }
      } else {
        LocalNotificationService.createanddisplaynotification(message);
      }
    });

    ////app is background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // String imageUrl = message.notification!.android!.imageUrl??'';
      // _firestore.collection('Notifications')
      //     .add({
      //   'title':message.notification!.title,
      //   'description':message.notification!.body,
      //   'icon':imageUrl
      // });
      final routeFromMessage = message.data["route"];
      print("route = " + routeFromMessage);
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  // StreamSubscription<String?> listnerNotifications(){
  //   return LocalNotificationService.onNotifications.stream.listen(onClickedNotification);
  // }
  // void onClickedNotification(String? payload) {
  //   //dispose();
  //   if(!mounted){
  //     // setState((){
  //       Navigator.of(context).pushNamed('account');
  //     //});
  //   }
  // }
  Future<void> share() async {
    final prefs = await SharedPreferences.getInstance();
    globals.action = await prefs.getString("login");
    print("333333333333333333333333333");
    print(globals.action);
    print("0000000000000000000");
  }

  removeNotification(ID) async {
    await _flutterLocalNotificationsPlugin.cancel(ID);
    await myBox.delete(ID);
  }

  void pushToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Authenticate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Color(0xFF7860DC),
              // Color(0xFFC0AAF5),
              // Color(0xFFDDD2FB),
              Color.fromARGB(255, 158, 2, 148),
              // Color.fromARGB(255, 5, 2, 180),
              // Color.fromARGB(255, 3, 193, 218)
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Lottie.asset(
              'assets/splash.json',
              width: width * .5,
              height: height * .3,
            ),
            // DropShadowImage(
            //   image: Image.asset(
            //     'assets/DP_png.png',
            //     width: width * .45,
            //     height: height * .2,
            //   ),
            //   offset: const Offset(3, 8),
            //   scale: .9,
            //   blurRadius: 10,
            //   borderRadius: 0,
            // ),
            SizedBox(height: 10),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 70,
                fontWeight:
                    FontWeight.lerp(FontWeight.w900, FontWeight.w900, 10.5),
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 0.5,
                    color: Colors.black,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Dataly',
                    textAlign: TextAlign.center,
                    colors: [
                      Colors.white,
                      Color.fromARGB(255, 245, 245, 245),
                      Colors.purple,
                      Color.fromARGB(255, 79, 3, 210),
                      Colors.pinkAccent,
                      Colors.amber,
                      Colors.teal,
                      // Colors.red,
                    ],
                    textStyle: TextStyle(fontSize: 50),
                    speed: Duration(milliseconds: 500),
                  ),
                ],
                pause: Duration(milliseconds: 1500),
                totalRepeatCount: 1,
                isRepeatingAnimation: true,
              ),
            ),
            SizedBox(height: 0),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: .5,
                    color: Colors.black,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                  pause: Duration(seconds: 1),
                  animatedTexts: [
                    TyperAnimatedText('#LearnByDoing',
                        textAlign: TextAlign.center,
                        speed: Duration(milliseconds: 300),
                        curve: Curves.bounceInOut),
                  ],
                  totalRepeatCount: 1,
                  isRepeatingAnimation: true,
                  onFinished: () {
                    pushToHome();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
